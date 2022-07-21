//
//  SigninViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/23.
//

import UIKit
import Alamofire

class SigninViewController: UIViewController {
    

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var ninknameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckField: UITextField!
    
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //버튼 그림자
        signinBtn.layer.cornerRadius = 10
        signinBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor // 색깔
        signinBtn.layer.masksToBounds = false  
        signinBtn.layer.shadowOffset = CGSize(width:4, height: 4) // 위치조정
        signinBtn.layer.shadowRadius = 10 // 반경
        signinBtn.layer.shadowOpacity = 1 // alpha값
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        let id = idTextField.text ?? ""
        let pw = pwTextField.text ?? ""
        let nickname = ninknameTextField.text ?? ""
        let pwCheck = pwCheckField.text ?? ""
        
        let param = SigninRequest(user_name: nickname, user_id: id, user_pw: pw, user_confirmPw: pwCheck)
        postSignin(param)
        
    }
    
    @IBAction func idCheckBtn(_ sender: UIButton) {
        let id = idTextField.text ?? ""
        
        let param = IDCheckRequset(userid: id)
        postIDCheck(param)
    }
    
    //MARK: POSTSIGIN
    func postSignin(_ parameters: SigninRequest){
        AF.request("http://15.164.102.4:3001/enroll", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SigninResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("회원가입이 완료 되었습니다")
                        let signin_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) {
                            (action) in self.navigationController?.popViewController(animated: true)
                        }
                        signin_alert.addAction(okAction)
                        present(signin_alert, animated: false, completion: nil)
                        
                    } else {
                        print("회원가입 실패")
                        let signinFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        signinFail_alert.addAction(okAction)
                        present(signinFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let signinFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    signinFail_alert.addAction(okAction)
                    present(signinFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POST IDCHECK
    func postIDCheck(_ parameters: IDCheckRequset){
        AF.request("http://13.209.10.30:4004/user/duplicate", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: IDCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        let idCk_alert = UIAlertController(title: "가능", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        idCk_alert.addAction(okAction)
                        present(idCk_alert, animated: false, completion: nil)
                        
                    } else {
                        print("아이디 중복")
                        let idCkFail_alert = UIAlertController(title: "중복", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        idCkFail_alert.addAction(okAction)
                        present(idCkFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let idCkFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    idCkFail_alert.addAction(okAction)
                    present(idCkFail_alert, animated: false, completion: nil)
                }
            }
    }
}
