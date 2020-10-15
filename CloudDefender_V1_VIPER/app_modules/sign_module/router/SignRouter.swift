//
//  SignRouter.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

final class SignRouter : PresenterToSignRouterProtocol{
    
    static func createSignModule() -> SignViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "SignViewController") as! SignViewController
        
        let presenter : ViewToSignPresenterProtocol & InteractorToSignPresenterProtocol = SignPresenter()
        let interactor : PresenterToSignInteractorProtocol = SignInteractor()
        let router : PresenterToSignRouterProtocol = SignRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    static var mainstoryboard : UIStoryboard{
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func showHomeViewController(navigationController : UINavigationController?) {
        
        let homeModule = HomeRouter.createHomeModule()
        navigationController?.pushViewController(homeModule, animated: true)
    }
}
