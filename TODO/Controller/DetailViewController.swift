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
    var paramuuid = ""
    
    private var buttonValue = false
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: SET UI
    private func setUI(){
        detlTextView.isUserInteractionEnabled = false
        titleTextField.isUserInteractionEnabled = false
        dateTextField.isUserInteractionEnabled = false
        adaptBtn.setTitle("수정하기", for: .normal)
        adaptBtn.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        //버튼 그림자
        deleteBtn.layer.cornerRadius = 10
        deleteBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor // 색깔
        deleteBtn.layer.masksToBounds = false
        deleteBtn.layer.shadowOffset = CGSize(width:0, height: 4) // 위치조정
        deleteBtn.layer.shadowRadius = 4 // 반경
        deleteBtn.layer.shadowOpacity = 1 // alpha값
        
        //버튼 그림자
        adaptBtn.layer.cornerRadius = 10
        adaptBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor // 색깔
        adaptBtn.layer.masksToBounds = false
        adaptBtn.layer.shadowOffset = CGSize(width:0, height: 4) // 위치조정
        adaptBtn.layer.shadowRadius = 4 // 반경
        adaptBtn.layer.shadowOpacity = 1 // alpha값
        
        detlTextView.delegate = self
        setTextView()
        
        let endIdx: String.Index = paramDate.index(paramDate.startIndex, offsetBy: 9)
        dateTextField.text = String(paramDate[...endIdx])
        titleTextField.text = paramTitle
        detlTextView.text = paramContent
        
        detlTextView.textColor = .black
        
        self.detlTextView.textContainerInset =
        UIEdgeInsets(top: 0, left: -detlTextView.textContainer.lineFragmentPadding, bottom: 0, right: -detlTextView.textContainer.lineFragmentPadding)//텍스트뷰 안쪽 여백 없애기
        
        configureDatePicker()
    }
    
    //MARK: IBAction
    @IBAction func adaptBtnPressed(_ sender: UIButton) {
        if buttonValue == false{
            detlTextView.isUserInteractionEnabled = true
            titleTextField.isUserInteractionEnabled = true
            dateTextField.isUserInteractionEnabled = true
            adaptBtn.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)
            adaptBtn.setTitle("완료", for: .normal)
            
            buttonValue = true
        } else {
            let update_alert = UIAlertController(title: "수정완료", message: "수정을 완료 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "예", style: .default){ (action) in
                let title = self.titleTextField.text ?? ""
                let content = self.detlTextView.text ?? ""
                let uuid = self.paramuuid
                let date = self.dateTextField.text ?? ""
                let param = UpdateTodoRequest(id: uuid, date: date, title: title, content: content)
                print(param)
                self.postUpdate(param)
                self.navigationController?.popViewController(animated: true)
            }
            let noAction = UIAlertAction(title: "아니요", style: .default)
            
            update_alert.addAction(noAction)
            update_alert.addAction(okAction)

            present(update_alert, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        
        let delete_alert = UIAlertController(title: "삭제", message: "삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예", style: .default){ (action) in
            let uuid = self.paramuuid
            let param = DeleteTodoRequest(id: uuid)
            self.postDelete(param)
            
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default)
        
        delete_alert.addAction(noAction)
        delete_alert.addAction(okAction)
        
        present(delete_alert, animated: false, completion: nil)
    }
    
    //MARK: POSTDELETE
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postDelete(_ parameters: DeleteTodoRequest){
        AF.request(TodoURL.baseURL, method: .delete, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
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
    
    //MARK: POSTUPDATE
    private func postUpdate(_ parameters: UpdateTodoRequest){
        AF.request(TodoURL.baseURL, method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: UpdateTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("투두 수정 성공")
                        print(response.message)
                        let update_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        update_alert.addAction(okAction)
                        present(update_alert, animated: false, completion: nil)
                        
                    } else {
                        print("투두 수정 실패")
                        let updateFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        updateFail_alert.addAction(okAction)
                        present(updateFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let updateFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    updateFail_alert.addAction(okAction)
                    present(updateFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: DATE PICKER
    
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date // 날짜만 나오게
        self.datePicker.preferredDatePickerStyle = .wheels // 데이트피커 스타일
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        self.datePicker.locale = Locale(identifier: "ko-KR") // 한국어 설정
        self.dateTextField.inputView = datePicker // 키보드대신 datePicker 보이기
        
        let dformmater = DateFormatter()
        dformmater.dateFormat = "yyyy-MM-dd"
        self.datePicker.date = dformmater.date(from: dateTextField.text ?? "") ?? Date()
        
    }
    
    //addTarget 두번쨰 파라미터 셀렉터 메서드
    @ objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formmater = DateFormatter() // 데이트 타입을 사람이 읽을 수 있도록 사람이 변환을 해주거나, 날짜 타입에서 데이트 타입을 변환을시켜주는 역할
        formmater.dateFormat = "yyyy-MM-dd" //데이트 포멧형식 잡기
        self.diaryDate = datePicker.date // datePicker 에서 선택된 date값 넘기기
        self.dateTextField.text = formmater.string(from: datePicker.date) // 포멧한 데이트 값을 텍스트 필드에 표시
    }
    
}

//MARK: 텍스트뷰
extension DetailViewController: UITextViewDelegate {
    
    private func setTextView(){
        
        //플레이스홀더 설정
        detlTextView.text = textViewPlaceHolder
        detlTextView.textColor = .placeholderText
        detlTextView.font = UIFont(name: "Inter-SemiBold", size: 14.5)
        
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
            textView.textColor = .placeholderText
            textView.font = UIFont(name: "Inter-SemiBold", size: 14.5)
            
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
