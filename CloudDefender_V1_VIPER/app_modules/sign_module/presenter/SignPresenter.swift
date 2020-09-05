//
//  SignPresenter.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

final class SignPresenter : ViewToSignPresenterProtocol{
    
    var view: PresenterToSignViewProtocol?
    var router: PresenterToSignRouterProtocol?
    var interactor: PresenterToSignInteractorProtocol?
    
    func SignIn(navigationController: UINavigationController){
        interactor?.oAuthSwift(navigationController: navigationController)
    }
}

extension SignPresenter : InteractorToSignPresenterProtocol{
    
    func goToHome(navigationController: UINavigationController){
        router?.showHomeViewController(navigationController: navigationController)
    }
}
