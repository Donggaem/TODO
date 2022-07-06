//
//  ViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/21.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: IBAction
    @IBAction func toSigninPressed(_ sender: UIButton) {
        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {

        
        let id = idTextField.text ?? ""
        let pw = passwordTextField.text ?? ""
        
        let param = LoginRequest(userId: id, password: pw)
        postLogin(param)
    }
    
    func postLogin(_ parameters: LoginRequest){
        AF.request("http://13.209.10.30:3030/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
        .validate()
        .responseDecodable(of: LoginResponse.self) { [self] response in
            switch response.result {
            case .success(let response):
                if response.check == true {
                    print("로그인 성공")
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
                    self.changeRootViewController(homeNav)
                    
                } else {
                    print("로그인 실패")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

