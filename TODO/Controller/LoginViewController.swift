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
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var todoLabel: UILabel!
    
//    let jsonObj: [String: Any] = [:]
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //버튼 그림자
        loginBtn.layer.cornerRadius = 10
        loginBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor // 색깔
        loginBtn.layer.masksToBounds = false
        loginBtn.layer.shadowOffset = CGSize(width:4, height: 4) // 위치조정
        loginBtn.layer.shadowRadius = 10 // 반경
        loginBtn.layer.shadowOpacity = 1 // alpha값
        
    }
    
    //MARK: IBAction
    @IBAction func toSigninPressed(_ sender: UIButton) {
        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        
        let id = idTextField.text ?? ""
        let pw = passwordTextField.text ?? ""
        
        let param = LoginRequest(user_id: id, user_pw: pw)
        postLogin(param)
    }
    
    func postLogin(_ parameters: LoginRequest){
        AF.request("http://15.164.102.4:3001/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        print("로그인 성공")
                        UserDefaults.standard.set(idTextField.text, forKey: "user_id")
                        UserDefaults.standard.set(response.data.token, forKey: "data")

                        print(response.data)
                        
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

