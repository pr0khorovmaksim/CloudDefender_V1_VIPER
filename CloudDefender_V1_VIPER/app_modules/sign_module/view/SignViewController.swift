//
//  ViewController.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import UIKit


final class SignViewController: UIViewController {
    
    @IBAction func signIn ( _ sender : UIButton) {
        presenter?.SignIn(navigationController: navigationController!)
    }
    
    var presenter : ViewToSignPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension SignViewController : PresenterToSignViewProtocol{

}
