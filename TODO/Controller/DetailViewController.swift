//
//  DetalilViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/26.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detlTextView: UITextView!
    @IBOutlet weak var theTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var adaptBtn: UIButton!
    
    //date picker 로 바꾸기 프로퍼티
    private let datePicker = UIDatePicker()
    private var diaryDate: Date? // 데이트 피커 에서 선택된 데이트 값 (옵셔널)
    
    let textViewPlaceHolder = "내용을 입력하세요"
    
    var paramTitle = ""
    var paramDate = ""
    var paramContent = ""
    var paramNo = 0
    
    var buttonValue = false
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detlTextView.isUserInteractionEnabled = false
        titleTextField.isUserInteractionEnabled = false
        dateTextField.isUserInteractionEnabled = false
        adaptBtn.setTitle("수정하기", for: .normal)
        
        detlTextView.delegate = self
        setTextView()
        
        configureDatePicker()
        
        titleTextField.text = paramTitle
        dateTextField.text = paramDate
        detlTextView.text = paramContent
        
        detlTextView.textColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

    
    @IBAction func adaptBtnPressed(_ sender: UIButton) {
        if buttonValue == false{
            detlTextView.isUserInteractionEnabled = true
            titleTextField.isUserInteractionEnabled = true
            dateTextField.isUserInteractionEnabled = true
            adaptBtn.setTitle("완료", for: .normal)
            
            buttonValue = true
        } else {
            let update_alert = UIAlertController(title: "수정완료", message: "수정을 완료 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "예", style: .default){ (action) in
                let no = self.paramNo
                let title = self.paramTitle
                let content = self.paramContent
                let userid = UserDefaults.standard.string(forKey: "userid")!
                let date = self.paramDate
                let param = UpdateTodoRequest(no: no, title: title, content: content, userid: userid, date: date)
                self.postUpdate(param)
                self.navigationController?.popViewController(animated: true)
            }
            let noAction = UIAlertAction(title: "아니요", style: .default)
            update_alert.addAction(okAction)
            update_alert.addAction(noAction)
            present(update_alert, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        
        let delete_alert = UIAlertController(title: "삭제", message: "삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예", style: .default){ (action) in
            let userid = UserDefaults.standard.string(forKey: "userid")!
            let no = self.paramNo
            let param = DeleteTodoRequest(no: no, userid: userid)
            self.postDelete(param)
            
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default)
        delete_alert.addAction(okAction)
        delete_alert.addAction(noAction)
        present(delete_alert, animated: false, completion: nil)
    }
    
    //MARK: POSTDELETE
    func postDelete(_ parameters: DeleteTodoRequest){
        AF.request("http://13.209.10.30:4004/todo/delete", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: DeleteTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("투두 삭제 성공")
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        print("투두 삭제 실패")
                        let deleteFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        deleteFail_alert.addAction(okAction)
                        present(deleteFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let deleteFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    deleteFail_alert.addAction(okAction)
                    present(deleteFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POSTUPDATE
    func postUpdate(_ parameters: UpdateTodoRequest){
        AF.request("http://13.209.10.30:4004/todo/update", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: UpdateTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("투두 수정 성공")
                        print(response.message)
                        
                    } else {
                        print("투두 수정 실패")
                        let deleteFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        deleteFail_alert.addAction(okAction)
                        present(deleteFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let deleteFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    deleteFail_alert.addAction(okAction)
                    present(deleteFail_alert, animated: false, completion: nil)
                }
            }
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
        formmater.dateFormat = "yyyy 년 MM 월 dd 일(EEEEE)" //데이트 포멧형식 잡기
        formmater.locale = Locale(identifier: "ko_KR") // 한국어 표현
        self.diaryDate = datePicker.date // datePicker 에서 선택된 date값 넘기기
        self.dateTextField.text = formmater.string(from: datePicker.date) // 포멧한 데이트 값을 텍스트 필드에 표시
    }
    
}

//MARK: 텍스트뷰
extension DetailViewController: UITextViewDelegate {
    
    func setTextView(){
        
        //플레이스홀더 설정
        detlTextView.text = textViewPlaceHolder
        detlTextView.textColor = .lightGray
        
        theTextViewHeightConstraint.isActive = false // 스토리보드에 설정된 콘스트레이트 무시
        detlTextView.sizeToFit()
        detlTextView.isScrollEnabled = false
        textViewDidChange(detlTextView)
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
