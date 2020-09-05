//
//  FilePresenter.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 24.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation

final class FilePresenter : ViewToFilePresenterProtocol{
    
    var view: PresenterToFileViewProtocol?
    var interactor: PresenterToFileInteractorProtocol?
    var router: PresenterToFileRouterProtocol?
    
    var fileURL: URL?
    var fileName : String?
    var fileType : String?
    
    func fileProcessing(){
        guard let fileURL = fileURL, let fileName = fileName, let fileType = fileType else { return }
        interactor?.fileProcessing(fileURL : fileURL, fileName : fileName, fileType : fileType)
    }
}

extension FilePresenter : InteractorToFilePresenterProtocol{
    
    func showView(fileType: String, fileURL: URL, fileName : String){
        view?.openFile(fileType: fileType, fileURL : fileURL, fileName : fileName)
    }
}
