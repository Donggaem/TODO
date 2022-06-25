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

        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let homeVC = homeStoryboard.instantiateViewController(identifier: "HomeViewController")
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true)
    }
    @IBAction func add(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

