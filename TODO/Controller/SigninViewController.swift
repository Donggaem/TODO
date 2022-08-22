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
    
    @IBOutlet weak var idCheckBtn: UIButton!
    @IBOutlet weak var nameCkeckBtn: UIButton!
    
    var checkNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        checkNum = 0
    }
    
    //MARK: SET UI
    private func setUI() {
        
        //버튼 그림자
        signinBtn.layer.cornerRadius = 10
        signinBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor // 색깔
        signinBtn.layer.masksToBounds = false
        signinBtn.layer.shadowOffset = CGSize(width:4, height: 4) // 위치조정
        signinBtn.layer.shadowRadius = 10 // 반경
        signinBtn.layer.shadowOpacity = 1 // alpha값
        
        
    }
    
    //MARK: IBAction
    @IBAction func signInBtn(_ sender: UIButton) {
        let id = idTextField.text ?? ""
        let pw = pwTextField.text ?? ""
        let nickname = ninknameTextField.text ?? ""
        let pwCheck = pwCheckField.text ?? ""
        
        switch checkNum {
        case 0: let check_alert = UIAlertController(title: "실패", message: "아이디, 닉네임 중복 체크를 해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
            
        case 1:
            let check_alert = UIAlertController(title: "실패", message: "닉네임 중복 체크를 해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
        case 2:
            let param = SigninRequest(user_name: nickname, user_id: id, user_pw: pw, user_confirmPw: pwCheck)
            postSignin(param)
            
        default:
            checkNum = 0
            let check_alert = UIAlertController(title: "실패", message: "회원가입을 다시 시도해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
        }
        
//        if pw == pwCheck {
//            
//            let param = SigninRequest(user_name: nickname, user_id: id, user_pw: pw, user_confirmPw: pwCheck)
//            postSignin(param)
//            
//        }else {
//            let pwCheck_alert = UIAlertController(title: "실패", message: "비밀번호가 일치한지 확인해주세요", preferredStyle: UIAlertController.Style.alert)
//            let okAction = UIAlertAction(title: "확인", style: .default)
//            pwCheck_alert.addAction(okAction)
//            present(pwCheck_alert, animated: false, completion: nil)
//        }
        
        
    }
    
    @IBAction func idCheckBtn(_ sender: UIButton) {
        if idTextField.text == "" {
            let checkNil_alert = UIAlertController(title: "실패", message: "아이디를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            checkNil_alert.addAction(okAction)
            present(checkNil_alert, animated: false, completion: nil)
        }else {
            let id = idTextField.text ?? ""
            let param = IDCheckRequset(user_id: id)
            postIDCheck(param)
        }
    }
    
    @IBAction func nameCheckBtn(_ sender: UIButton) {
        if ninknameTextField.text == ""{
            let checkNil_alert = UIAlertController(title: "실패", message: "닉네임을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            checkNil_alert.addAction(okAction)
            present(checkNil_alert, animated: false, completion: nil)
        }else {
            let name = ninknameTextField.text ?? ""
            let param = NameCheckRequest(user_name: name)
            postNameCheck(param)
        }
        
    }
    
    //MARK: POST SIGIN
    private func postSignin(_ parameters: SigninRequest){
        AF.request(TodoURL.signinURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SigninResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("회원가입이 완료 되었습니다")
                        let signin_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default) {
                            (action) in self.navigationController?.popViewController(animated: true)
                        }
                        signin_alert.addAction(okAction)
                        present(signin_alert, animated: false, completion: nil)
                        
                    } else {
                        print("회원가입 실패")
                        let signinFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        signinFail_alert.addAction(okAction)
                        present(signinFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let signinFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    signinFail_alert.addAction(okAction)
                    present(signinFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POST IDCHECK
    private func postIDCheck(_ parameters: IDCheckRequset){
        AF.request(TodoURL.checkURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: IDCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        checkNum += 1
                        idCheckBtn.isUserInteractionEnabled = false
                        idTextField.isUserInteractionEnabled = false
                        
                        let idCk_alert = UIAlertController(title: "가능", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        idCk_alert.addAction(okAction)
                        present(idCk_alert, animated: false, completion: nil)
                        
                    } else {
                        print("아이디 중복")
                        let idCkFail_alert = UIAlertController(title: "중복", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        idCkFail_alert.addAction(okAction)
                        present(idCkFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let idCkFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    idCkFail_alert.addAction(okAction)
                    present(idCkFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POST NAMECHECK
    private func postNameCheck(_ parameters: NameCheckRequest){
        AF.request(TodoURL.checkURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: NameCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        checkNum += 1
                        nameCkeckBtn.isUserInteractionEnabled = false
                        ninknameTextField.isUserInteractionEnabled = false
                        
                        let nameCk_alert = UIAlertController(title: "가능", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        nameCk_alert.addAction(okAction)
                        present(nameCk_alert, animated: false, completion: nil)
                        
                    } else {
                        print("닉네임 중복")
                        let nameCkFail_alert = UIAlertController(title: "중복", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        nameCkFail_alert.addAction(okAction)
                        present(nameCkFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let nameCkFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    nameCkFail_alert.addAction(okAction)
                    present(nameCkFail_alert, animated: false, completion: nil)
                }
            }
    }
}
