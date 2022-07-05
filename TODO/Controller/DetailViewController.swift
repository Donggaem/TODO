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
    @IBOutlet weak var dayTextField: UITextField!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var adaptBtn: UIButton!
    
    let textViewPlaceHolder = "내용을 입력하세요"
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detlTextView.isUserInteractionEnabled = false
        titleTextField.isUserInteractionEnabled = false
        dayTextField.isUserInteractionEnabled = false
        adaptBtn.setTitle("수정하기", for: .normal)
        
        detlTextView.delegate = self
        setTextView()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//    }
    
    @IBAction func adaptBtnPressed(_ sender: UIButton) {
        detlTextView.isUserInteractionEnabled = true
        titleTextField.isUserInteractionEnabled = true
        dayTextField.isUserInteractionEnabled = true
        adaptBtn.setTitle("완료", for: .normal)
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
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
