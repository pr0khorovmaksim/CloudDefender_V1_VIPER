//
//  AccessLevelAlertController.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 17.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

final class HomeAccessLevelAlertController: UIAlertController, UITableViewDataSource {
    
    fileprivate var controller : UITableViewController
    
    fileprivate var createValue : Bool? = false
    fileprivate var readValue : Bool? = false
    fileprivate var deleteValue : Bool?  = false
    fileprivate var ownerValue : Bool?  = false
    fileprivate var SummLevel  : Int? = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        controller = UITableViewController(style: .plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        controller.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        controller.tableView.dataSource = self
        
        controller.tableView.addObserver(self, forKeyPath: "contentSize", options: [.initial, .new], context: nil)
        self.setValue(controller, forKey: "contentViewController")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        guard keyPath == "contentSize" else { return }
        controller.preferredContentSize = controller.tableView.contentSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        controller.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    @objc func switchChangedCreate(mySwitch: UISwitch) {
        if mySwitch.isOn == true{
            createValue = true
        }else{
            createValue = false
        }
    }
    
    @objc func switchChangedRead(mySwitch: UISwitch) {
        if mySwitch.isOn == true{
            readValue = true
        }else{
            readValue = false
        }
    }
    
    @objc func switchChangedDelete(mySwitch: UISwitch) {
        if mySwitch.isOn == true{
            deleteValue = true
        }else{
            deleteValue = false
        }
    }
    
    @objc func switchChangedOwner(mySwitch: UISwitch) {
        if mySwitch.isOn == true{
            ownerValue = true
        }else{
            ownerValue = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        createValue  = false
        readValue = false
        deleteValue  = false
        ownerValue  = false
        SummLevel = 0
        
        switch(indexPath.row) {
        case 0:
            cell.textLabel?.text = "Создание"
            let switchView = UISwitch(frame: CGRect.zero)
            cell.accessoryView = switchView
            switchView.addTarget(self, action: #selector(switchChangedCreate), for: UIControl.Event.valueChanged)
            switchView.setOn(false, animated: false)
            break
        case 1:
            cell.textLabel?.text = "Чтение"
            let switchView = UISwitch(frame: CGRect.zero)
            cell.accessoryView = switchView
            switchView.addTarget(self, action: #selector(switchChangedRead), for: UIControl.Event.valueChanged)
            switchView.setOn(false, animated: false)
            break
        case 2:
            cell.textLabel?.text = "Удаление"
            let switchView = UISwitch(frame: CGRect.zero)
            cell.accessoryView = switchView
            switchView.addTarget(self, action: #selector(switchChangedDelete), for: UIControl.Event.valueChanged)
            switchView.setOn(false, animated: false)
            break
        case 3:
            cell.textLabel?.text = "Полные"
            let switchView = UISwitch(frame: CGRect.zero)
            cell.accessoryView = switchView
            switchView.addTarget(self, action: #selector(switchChangedOwner), for: UIControl.Event.valueChanged)
            switchView.setOn(false, animated: false)
            break
            
        default:
            fatalError()
        }
        return cell
    }
}
