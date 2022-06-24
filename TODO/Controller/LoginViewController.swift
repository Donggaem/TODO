//
//  ViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/21.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func ToSigninPressed(_ sender: UIButton) {

        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController")
        homeVC.modalPresentationStyle = .fullScreen
        //homeVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(homeVC, animated: true)
    }
    
}
