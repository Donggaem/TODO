//
//  AddViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/25.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var addTextView: UITextView!
    @IBOutlet weak var theTextViewHeightConstraint: NSLayoutConstraint!
    
    let textViewPlaceHolder = "내용을 입력하세요"
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextView.delegate = self
        setTextView()
        
    }
    
    @IBAction func addBtnPressed(_ sender: UIButton) {
    }
}

//MARK: 텍스트뷰
extension AddViewController: UITextViewDelegate {

    func setTextView(){
        
        //플레이스홀더 설정
        addTextView.text = textViewPlaceHolder
        addTextView.textColor = .lightGray
        
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
