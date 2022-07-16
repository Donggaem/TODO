//
//  AddViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/25.
//

import UIKit
import Alamofire

class AddViewController: UIViewController {
    
    @IBOutlet weak var addTextView: UITextView!
    @IBOutlet weak var theTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    //date picker 로 바꾸기 프로퍼티
    private let datePicker = UIDatePicker()
    private var diaryDate: Date? // 데이트 피커 에서 선택된 데이트 값 (옵셔널)
    
    let textViewPlaceHolder = "내용을 입력하세요"
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextView.delegate = self
        setTextView()
        configureDatePicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func addBtnPressed(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
        let content = addTextView.text ?? ""
        let date = dateTextField.text ?? ""
        let userid = UserDefaults.standard.string(forKey: "userid")!
        
        let param = AddTodoRequest(title: title, content: content, userid: userid, date: date)
        postAddTodo(param)
    }
    
    //MARK: DATE PICKER
    
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date // 날짜만 나오게
        self.datePicker.preferredDatePickerStyle = .wheels // 데이트피커 스타일
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        self.datePicker.locale = Locale(identifier: "ko-KR") // 한국어 설정
        self.dateTextField.inputView = self.datePicker // 키보드대신 datePicker 보이기
    }
    
    //addTarget 두번쨰 파라미터 셀렉터 메서드
    @ objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formmater = DateFormatter() // 데이트 타입을 사람이 읽을 수 있도록 사람이 변환을 해주거나, 날짜 타입에서 데이트 타입을 변환을시켜주는 역할
        formmater.dateFormat = "yyyy년MM월dd일(EEEEE)" //데이트 포멧형식 잡기
        formmater.locale = Locale(identifier: "ko_KR") // 한국어 표현
        self.diaryDate = datePicker.date // datePicker 에서 선택된 date값 넘기기
        self.dateTextField.text = formmater.string(from: datePicker.date) // 포멧한 데이트 값을 텍스트 필드에 표시
    }
    
    //MARK: POST ADDTODO
    func postAddTodo(_ parameters: AddTodoRequest){
        AF.request("http://13.209.10.30:4004/todo", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: AddTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        let addTodo_alert = UIAlertController(title: "추가 완료", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) {
                            (action) in self.navigationController?.popViewController(animated: true)
                        }
                        addTodo_alert.addAction(okAction)
                        present(addTodo_alert, animated: false, completion: nil)
                        
                    } else {
                        print("추가 실패")
                        let addFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        addFail_alert.addAction(okAction)
                        present(addFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let addFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    addFail_alert.addAction(okAction)
                    present(addFail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: 텍스트뷰
extension AddViewController: UITextViewDelegate {
    
    func setTextView(){
        
        //플레이스홀더 설정
        addTextView.text = textViewPlaceHolder
        addTextView.textColor = UIColor(red: 0.631, green: 0.631, blue: 0.667, alpha: 1)
        addTextView.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        theTextViewHeightConstraint.isActive = false // 스토리보드에 설정된 콘스트레이트 무시
        addTextView.sizeToFit()
        addTextView.isScrollEnabled = false
        textViewDidChange(addTextView)
    }
    
    //텍스트뷰 열릴시
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    //텍스트뷰 닫힐시
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            if estimatedSize.height <= 50 {
                
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
}

