//
//  FileProtocols.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 24.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation

protocol ViewToFilePresenterProtocol : class{
    
    var view : PresenterToFileViewProtocol? { get set}
    var interactor : PresenterToFileInteractorProtocol? { get set }
    var router : PresenterToFileRouterProtocol? { get set }
    
    var fileURL: URL? { get set }
    var fileName: String? { get set }
    var fileType: String? { get set }
    
    func fileProcessing()
}

protocol PresenterToFileViewProtocol : class{
    
    func openFile(fileType : String, fileURL : URL, fileName : String)
}

protocol PresenterToFileRouterProtocol : class{
    
    static func createFileModule(fileURL : URL, fileName : String, fileType : String) -> FileViewController
}

protocol PresenterToFileInteractorProtocol : class{
    
    var presenter : InteractorToFilePresenterProtocol? { get set }
    func fileProcessing(fileURL : URL, fileName : String, fileType : String)
}

protocol InteractorToFilePresenterProtocol : class{
    
    func showView(fileType: String, fileURL : URL, fileName : String)
}
