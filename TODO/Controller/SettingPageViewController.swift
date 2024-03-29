//
//  SettingPageViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/27.
//

import UIKit
import Alamofire

class SettingPageViewController: UIViewController {
    
    let token = UserDefaults.standard.string(forKey: "data")
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: IBAction
    //개인정보 처리방침 및 이용약관 버튼
    @IBAction func termsOfUseBtnPressed(_ sender: UIButton) {
        if let url = URL(string: "https://summer-echidna-7ed.notion.site/e9f53b711e8345c79b8047322cc69604") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    //오픈소스라이브러리 버튼
    @IBAction func openSourcePressed(_ sender: UIButton) {
        if let url = URL(string: "https://mini-mail-719.notion.site/TODO-OSS-Notice-bac449a4f12f47739dae001a8847afee") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    //로그아웃 버튼
    @IBAction func logoutPressed(_ sender: UIButton) {
        let logout_alert = UIAlertController(title: "로그아웃", message: "로그아웃을 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예", style: .default){ (action) in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginNav = storyBoard.instantiateViewController(identifier: "LoginNav")
            self.changeRootViewController(loginNav)
            UserDefaults.standard.removeObject(forKey: "data")
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: "upw")
            
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default)
        
        logout_alert.addAction(noAction)
        logout_alert.addAction(okAction)
        
        present(logout_alert, animated: false, completion: nil)
    }
    
    //회원탈퇴 버튼
    @IBAction func ResignPressed(_ sender: UIButton) {
        
        let Resign_alert = UIAlertController(title: "회원탈퇴를 하시겠습니까?", message: "비밀번호를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
        Resign_alert.addTextField { (myTextField) in
            myTextField.isSecureTextEntry = true
        }
        let okAction = UIAlertAction(title: "예", style: .default){ (action) in
            
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: "upw")
            
            let userpw = Resign_alert.textFields?[0].text ?? ""
            let param = ResignRequest(user_pw: userpw)
            self.postResign(param)
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default)
        Resign_alert.addAction(okAction)
        Resign_alert.addAction(noAction)
        present(Resign_alert, animated: false, completion: nil)
    }
    
   
    
    //MARK: POST RESIGN
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postResign(_ parameters: ResignRequest){
        AF.request(TodoURL.resignURL, method: .delete, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: ResignResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        print("회원탈퇴 성공")
                        let resign_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default){ (action) in
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let loginNav = storyBoard.instantiateViewController(identifier: "LoginNav")
                            self.changeRootViewController(loginNav)
                            UserDefaults.standard.removeObject(forKey: "data")
                        }
                        resign_alert.addAction(okAction)
                        present(resign_alert, animated: false, completion: nil)
                        
                    } else {
                        let resignFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        resignFail_alert.addAction(okAction)
                        present(resignFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let resignFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    resignFail_alert.addAction(okAction)
                    present(resignFail_alert, animated: false, completion: nil)
                }
            }
    }
}
