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
        
        if let id = UserDefaults.standard.string(forKey: "uid"), let pw = UserDefaults.standard.string(forKey: "upw") {
            let param = LoginRequest(user_id: id, user_pw: pw)
            postLogin(param)
        }else {
            print("저장된값이 없음")
        }
        
        setUI()
        setTextField()
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
        loginBtn.isEnabled = false
        
    }
    
    //MARK: IBAction
    @IBAction func toSigninPressed(_ sender: UIButton) {
        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if idTextField.text == "" || idTextField.text == nil {
            let alert = UIAlertController(title: "실패", message: "아이디를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            
        } else if passwordTextField.text == "" || passwordTextField.text == nil {
            let alert = UIAlertController(title: "실패", message: "비밀번호를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            
        }else {
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
                        
                        TodoLog.debug("postLogin")
                        
                        UserDefaults.standard.set(response.data?.token, forKey: "data")
                        
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
                        self.changeRootViewController(homeNav)
                        
                    } else {
                        TodoLog.error("postLogin")
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

extension LoginViewController: UITextFieldDelegate {
    
    private func setTextField() {
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
    }
    
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
        
        //2개 텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인.
        if !(self.idTextField.text?.isEmpty ?? true) && !(self.passwordTextField.text?.isEmpty ?? true) {
            loginBtn(willActive: true)
        }
        else {
            
            loginBtn(willActive: false)
        }
        
    }
    
    //버튼 활성화/비활성화
    func loginBtn(willActive: Bool) {
        
        if(willActive == true) {
            loginBtn.isEnabled = true
        } else {
            loginBtn.isEnabled = false
        }
    }
}
