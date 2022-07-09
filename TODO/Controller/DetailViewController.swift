//
//  DetalilViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/26.
//

import UIKit

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
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //    }
    
    @IBAction func adaptBtnPressed(_ sender: UIButton) {
        detlTextView.isUserInteractionEnabled = true
        titleTextField.isUserInteractionEnabled = true
        dateTextField.isUserInteractionEnabled = true
        adaptBtn.setTitle("완료", for: .normal)
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
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
