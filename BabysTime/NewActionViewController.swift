//
//  NewActionViewController.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-07-06.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import UIKit

class NewActionViewController: UIViewController {
    
    @IBOutlet weak var newActionTextField: UITextField!
    @IBOutlet weak var logoTextField: UITextField!
    
    var selectedBabyActionClosure: ((BabyAction) -> Void)!
    
    @IBAction func addActionButton(_ sender: UIButton) {
        guard let logoText = logoTextField.text else{
            presentAlert("please enter emoji")
            return
        }
        guard let newActionText = newActionTextField.text else {
            presentAlert("please enter a title")
            return
        }
        
        if newActionText == "" {
            presentAlert("please enter a title")
            return
        }
        
        if newActionText.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            presentAlert("please enter a title")
            return
        }
        let newBabyAction = BabyAction(logo: logoText, title: newActionText)
        Database.shared.addBabyAction(newBabyAction)
        self.selectedBabyActionClosure(newBabyAction)
        self.dismiss(animated: true)
        
    }
        
    
    
    func presentAlert(_ message: String){
        let alert = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}

