//
//  FileRouter.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 24.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

final class FileRouter : PresenterToFileRouterProtocol{
    
    static func createFileModule(fileURL : URL, fileName : String, fileType : String) -> FileViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "FileViewController") as! FileViewController
        
        let presenter : ViewToFilePresenterProtocol & InteractorToFilePresenterProtocol = FilePresenter()
        let interactor : PresenterToFileInteractorProtocol = FileInteractor()
        let router : PresenterToFileRouterProtocol = FileRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        
        presenter.fileURL = fileURL
        presenter.fileName = fileName
        presenter.fileType = fileType
        
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    static var mainstoryboard : UIStoryboard{
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
