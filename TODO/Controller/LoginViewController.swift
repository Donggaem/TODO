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
//    {
//        didSet{
//            idTextField.font = UIFont(name: "Roboto-Regular", size: 20)
//            let idPlaceholder = NSAttributedString(string: "ID", attributes:[NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.512, green: 0.512, blue: 0.512, alpha: 1), NSAttributedString.Key.font : UIFont.init(name: "Roboto-Regular", size: 20) ?? "System"])
//            
//            idTextField.attributedPlaceholder = idPlaceholder
//        }
//    }
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
        
        let param = LoginRequest(userid: id, userpw: pw)
        postLogin(param)
    }
    
    func postLogin(_ parameters: LoginRequest){
        AF.request("http://13.209.10.30:4004/user/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("로그인 성공")
                        UserDefaults.standard.set(idTextField.text, forKey: "userid")
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
                        self.changeRootViewController(homeNav)
                        
                    } else {
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
    
}

