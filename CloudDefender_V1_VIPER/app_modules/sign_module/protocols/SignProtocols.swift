//
//  SignProtocols.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToSignPresenterProtocol : class{
    
    var view : PresenterToSignViewProtocol? { get set }
    var router : PresenterToSignRouterProtocol? { get set }
    var interactor : PresenterToSignInteractorProtocol? { get set }
    
    func SignIn(navigationController : UINavigationController?)
}

protocol PresenterToSignViewProtocol : class{

}

protocol PresenterToSignRouterProtocol : class{
    
    static func createSignModule()-> SignViewController
    func showHomeViewController(navigationController : UINavigationController?)
}

protocol PresenterToSignInteractorProtocol : class{
    
    var presenter : InteractorToSignPresenterProtocol? { get set }
    func oAuthSwift(navigationController: UINavigationController?)
}

protocol InteractorToSignPresenterProtocol : class{
    func goToHome(navigationController: UINavigationController?)
}
