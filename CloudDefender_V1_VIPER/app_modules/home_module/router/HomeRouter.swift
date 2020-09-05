//
//  HomeRouter.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

final class HomeRouter : PresenterToHomeRouterProtocol{
    
    static func createHomeModule() -> HomeCollectionViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "HomeCollectionViewController") as! HomeCollectionViewController
        
        let presenter : ViewToHomePresenterProtocol & InteractorToHomePresenterProtocol = HomePresenter()
        let interactor : PresenterToHomeInteractorProtocol = HomeInteractor()
        let router : PresenterToHomeRouterProtocol = HomeRouter()
        
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
    
    func showFileViewController(navigationController : UINavigationController, fileURL : URL, fileName : String, fileType : String) {
        
        let fileModule = FileRouter.createFileModule(fileURL: fileURL, fileName : fileName, fileType : fileType)
        navigationController.pushViewController(fileModule, animated: true)
    }
    
    func showSignViewController(navigationController : UINavigationController){
        let signModule = SignRouter.createSignModule()
        navigationController.pushViewController(signModule, animated: true)
    }
}
