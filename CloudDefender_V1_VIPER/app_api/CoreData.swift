//
//  CoreData.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 08.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreData{
    
    func saveUserData(userId: String?, userName : String?, userEmail : String?, whois : String?){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if whois == "User"{
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let userObject = NSManagedObject(entity: entity!, insertInto: context) as! User
            userObject.userId = userId
            userObject.userName = userName
            userObject.userEmail = userEmail
        }
        if whois == "AuthorizedUser"{
            let entity = NSEntityDescription.entity(forEntityName: "AuthorizedUser", in: context)
            let userObject = NSManagedObject(entity: entity!, insertInto: context) as! AuthorizedUser
            userObject.authorizedUserName = userName
            userObject.authorizedUserEmail = userEmail
            userObject.authorizedUserId = userId
        }
        do{
            try context.save()
        }
        catch{
            print("Ошибка: \(error.localizedDescription)")
        }
    }
    
    func checkingIfAUserExists() -> (String?, String?){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestUser : NSFetchRequest<User> = User.fetchRequest()
        let fetchRequestAuthorizedUser : NSFetchRequest<AuthorizedUser> = AuthorizedUser.fetchRequest()
        let count = try! context.count(for: fetchRequestUser)
            if count > 0 {
                let itemsUser = try! context.fetch(fetchRequestUser)
                let itemsAuthorizedUser = try! context.fetch(fetchRequestAuthorizedUser)
                for i in 0...count-1{
                    if itemsUser[i].value(forKey: "userName") as? String == itemsAuthorizedUser[0].value(forKey: "authorizedUserName") as? String && itemsUser[i].value(forKey: "userEmail") as? String == itemsAuthorizedUser[0].value(forKey: "authorizedUserEmail") as? String{
                        let userId = itemsUser[i].value(forKey: "userId")! as? String
                        let userId1 = userId?.dropFirst()
                        let userName = itemsUser[i].value(forKey: "userName")! as? String
                        let userIdFetch = String((userId1?.dropLast())!)
                        let userNameIdFetch = userName
                        return (userIdFetch, userNameIdFetch)
                    }
                }
            }
        return ("", "")
    }
    
    func countAuthorizedUser() -> Int{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<AuthorizedUser> = AuthorizedUser.fetchRequest()
        let count = try! context.count(for: fetchRequest)
        return count
    }
    
    func deleteUser(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<AuthorizedUser> = AuthorizedUser.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        try! context.execute(deleteRequest)
    }
}
