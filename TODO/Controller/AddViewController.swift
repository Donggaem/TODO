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
    
    @IBOutlet weak var addBtn: UIButton!
    
    //date picker 로 바꾸기 프로퍼티
    private let datePicker = UIDatePicker()
    private var diaryDate: Date? // 데이트 피커 에서 선택된 데이트 값 (옵셔널)
    
    private let textViewPlaceHolder = "내용을 입력하세요(500자이내)"
    var paramSeletedDate = ""
    private let maxCount = 500
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: SET UI
    private func setUI() {
        //버튼 그림자
        addBtn.layer.cornerRadius = 10
        addBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor // 색깔
        addBtn.layer.masksToBounds = false
        addBtn.layer.shadowOffset = CGSize(width:0, height: 4) // 위치조정
        addBtn.layer.shadowRadius = 4 // 반경
        addBtn.layer.shadowOpacity = 1 // alpha값
        
        addTextView.delegate = self
        self.addTextView.textContainerInset =
        UIEdgeInsets(top: 0, left: -addTextView.textContainer.lineFragmentPadding, bottom: 0, right: -addTextView.textContainer.lineFragmentPadding) // 텍스트뷰 안쪽 marin없애기
        
        setTextView()
        
        dateTextField.delegate = self
        
        configureDatePicker()
    }
    
    //MARK: IBAction
    @IBAction func addBtnPressed(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
        let content = addTextView.text ?? ""
        let date = dateTextField.text ?? ""
        
        let param = AddTodoRequest(title: title, content: content, date: date)
        postAddTodo(param)
    }
    
    @IBAction func dateEdit(_ sender: UITextField) {
        
        self.dateTextField.text = paramSeletedDate
    }
    
    //MARK: DATE PICKER
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date // 날짜만 나오게
        self.datePicker.preferredDatePickerStyle = .wheels // 데이트피커 스타일
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        self.datePicker.locale = Locale(identifier: "ko-KR") // 한국어 설정
        self.dateTextField.inputView = self.datePicker // 키보드대신 datePicker 보이기
        
        let dformmater = DateFormatter()
        dformmater.dateFormat = "yyyy-MM-dd"
        self.datePicker.date = dformmater.date(from: paramSeletedDate) ?? Date()
        
    }
    
    //addTarget 두번쨰 파라미터 셀렉터 메서드
    @ objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formmater = DateFormatter() // 데이트 타입을 사람이 읽을 수 있도록 사람이 변환을 해주거나, 날짜 타입에서 데이트 타입을 변환을시켜주는 역할
        formmater.dateFormat = "yyyy-MM-dd" //데이트 포멧형식 잡기
        formmater.locale = Locale(identifier: "ko_KR") // 한국어 표현
        self.diaryDate = datePicker.date // datePicker 에서 선택된 date값 넘기기
        self.dateTextField.text = formmater.string(from: datePicker.date) // 포멧한 데이트 값을 텍스트 필드에 표시
    }
    
    
    //MARK: POST ADDTODO
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postAddTodo(_ parameters: AddTodoRequest){
        AF.request(TodoURL.baseURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: AddTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(response)
                    if response.isSuccess == true {
                        
                        UserDefaults.standard.set(dateTextField.text, forKey: "date")
                        
                        let addTodo_alert = UIAlertController(title: "추가 완료", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default) {
                            (action) in self.navigationController?.popViewController(animated: true)
                        }
                        addTodo_alert.addAction(okAction)
                        present(addTodo_alert, animated: false, completion: nil)
                        
                    } else {
                        print("추가 실패")
                        let addFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        addFail_alert.addAction(okAction)
                        present(addFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let addFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    addFail_alert.addAction(okAction)
                    present(addFail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: 데이트 텍스트필드]
extension AddViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
}

//MARK: 텍스트뷰
extension AddViewController: UITextViewDelegate {
    
    private func setTextView(){
        
        
        //플레이스홀더 설정
        addTextView.text = textViewPlaceHolder
        addTextView.textColor = .placeholderText
        addTextView.font = UIFont(name: "Inter-SemiBold", size: 14.5)
        
        theTextViewHeightConstraint.isActive = false // 스토리보드에 설정된 콘스트레이트 무시
        addTextView.sizeToFit()
        addTextView.isScrollEnabled = false
        textViewDidChange(addTextView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = maxCount + 1
        //글자수가 초과 된 경우 or 초과되지 않은 경우
        if newLength > koreanMaxCount {
            let overflow = newLength - koreanMaxCount //초과된 글자수
            if text.count < overflow {
                return true
            }
            let index = text.index(text.endIndex, offsetBy: -overflow)
            let newText = text[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            
            textView.replace(textRange, withText: String(newText))
            
            return false
        }
        return true
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
            textView.textColor = .placeholderText
            textView.font = UIFont(name: "Inter-SemiBold", size: 14.5)
        }
        
        if textView.text.count > maxCount {
            //글자수 제한에 걸리면 마지막 글자를 삭제함.
            textView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "500자 이내로 적어주시기 바랍니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            if estimatedSize.height <= 450 {
                
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
}

