//
//  SignInteractor.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

final class SignInteractor : PresenterToSignInteractorProtocol{
    
    var presenter: InteractorToSignPresenterProtocol?
    
    fileprivate var coreData : CoreData = CoreData()
    fileprivate let networkDataFetcher : NetworkDataFetcher = NetworkDataFetcher()
    
    fileprivate var userName : String?
    fileprivate var userEmail : String?
    fileprivate var isRegisterSuccess: Bool?
    fileprivate var isOAuthSuccess: Bool?
    fileprivate var oauthswift : OAuth2Swift?
    
    fileprivate let serialQueue = DispatchQueue(label: "com.self.serialGCD")
    fileprivate let serialQueue2 = DispatchQueue(label: "swift.serial.queue")
    fileprivate let group = DispatchGroup()
    fileprivate let group2 = DispatchGroup()
    
    func oAuthSwift(navigationController : UINavigationController?){
        let count = coreData.countAuthorizedUser()
        if count == 0{
            group2.enter()
            serialQueue2.async {
                self.OAuth()
            }
            group2.notify(queue: .main) {
                if self.isRegisterSuccess == true && self.isOAuthSuccess == true {
                    self.presenter?.goToHome(navigationController : navigationController)
                }else{
                    print("Ошибка: Не прошел OAuth")
                }
            }
        }else{
            print("Ошибка: Не прошел OAuth")
        }
    }
    
    private func OAuth(){
        let oauthswift = OAuth2Swift(
            consumerKey: "831609926475-cmut9eherrh7no21adgiluco39k0df0i.apps.googleusercontent.com",
            consumerSecret: "",
            authorizeUrl: "https://accounts.google.com/o/oauth2/auth",
            accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
            responseType: "code"
        )
        oauthswift.allowMissingStateCheck = true
        
        guard let rwURL = URL(string: "maksim.test-oauth2:/https://romansuvorov.ru/clouddefender/api/test") else { return }
        oauthswift.authorize(withCallbackURL: rwURL, scope: "https://www.googleapis.com/auth/userinfo.profile+https://www.googleapis.com/auth/userinfo.email", state: "", completionHandler: { (result) -> Void in
            
            self.oauthswift = oauthswift
            
            switch (result){
                
            case .failure(let error):
                print("failure: \(error.localizedDescription)")
                
            case .success(_):
                
                oauthswift.client.get("https://www.googleapis.com/oauth2/v3/userinfo", completionHandler: {
                    (result2) -> Void in
                    
                    switch (result2){
                    case .failure(let error):
                         print("Ошибка: \(error.localizedDescription)")
                    case .success(let request):
                        let data = request.dataString()
                        self.userName = data!.components(separatedBy: "name\": \"").last?.components(separatedBy: "\",").first
                        self.userEmail = data!.components(separatedBy: "email\": \"").last?.components(separatedBy: "\",").first
                        self.group.enter()
                        self.serialQueue.async {
                            self.register(userName: self.userName!, userEmail: self.userEmail!)
                        }
                        self.group.notify(queue: .main) {
                            if self.isRegisterSuccess == true{
                                self.isOAuthSuccess = true
                            }else{
                                self.isOAuthSuccess = false
                            }
                        }
                    }
                })
            }
        })
    }
    
    private func register(userName : String, userEmail : String){
        
        let parameters : [String: Any]  = ["username":"\(userName)","email":"\(userEmail)"]
        
        self.networkDataFetcher.fetchRegister(parameters: parameters) { (response) in
            guard let response = response else { return }
            
            let responseString = String(data: response, encoding: .utf8)
            let a = responseString!.dropLast()
            let b = a.dropFirst()
            if b == "Данный пользователь уже зарегистрирован"{
                self.isRegisterSuccess = false
            }
            else{
                let userId = String(data: response, encoding: .utf8)!
                self.coreData.saveUserData(userId: userId, userName: userName, userEmail: userEmail, whois: "User")
                self.coreData.saveUserData(userId: userId, userName: userName, userEmail: userEmail, whois: "AuthorizedUser")
                self.isRegisterSuccess = true
            }
            self.group.leave()
            self.group2.leave()
        }
    }
}
