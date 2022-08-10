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
    
    var isAutoLogin = false
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.string(forKey: "uid") == nil){
            print("저장된값이 없음")
            
        }else {
            let id = UserDefaults.standard.string(forKey: "uid") ?? ""
            let pw = UserDefaults.standard.string(forKey: "upw") ?? ""
            
            let param = LoginRequest(user_id: id, user_pw: pw)
            postLogin(param)
        }
        setUI()
        
    }
    
    //MARK: SET UI
    private func setUI() {
        
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
        
        if isAutoLogin == true {
            UserDefaults.standard.set(idTextField.text, forKey: "uid")
            UserDefaults.standard.set(passwordTextField.text, forKey: "upw")
            
        }else {
            UserDefaults.standard.set(nil, forKey: "uid")
            UserDefaults.standard.set(nil, forKey: "upw")
        }
        
        let id = idTextField.text ?? ""
        let pw = passwordTextField.text ?? ""
        
        let param = LoginRequest(user_id: id, user_pw: pw)
        postLogin(param)
    }
    @IBAction func autoLoginAction(_ sender: UIButton) {
        // auto login 선택 여부
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            isAutoLogin = true
            
            
        }else{
            isAutoLogin = false
            
        }
        
    }
    
    //MARK: POST LOGIN
    private func postLogin(_ parameters: LoginRequest){
        AF.request(TodoURL.loginURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        print("로그인 성공")
                        
                        UserDefaults.standard.set(response.data?.token, forKey: "data")
                        
                        
                        
                        print(response.data ?? "")
                        
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
                        self.changeRootViewController(homeNav)
                        
                    } else {
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
    
}

