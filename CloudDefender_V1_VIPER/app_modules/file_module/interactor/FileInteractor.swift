//
//  FileInteractor.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 24.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

final class FileInteractor : PresenterToFileInteractorProtocol{
    
    var presenter: InteractorToFilePresenterProtocol?
    
    func fileProcessing(fileURL: URL, fileName: String, fileType : String) {
        presenter?.showView(fileType: fileType, fileURL : fileURL, fileName : fileName)
    }
}
