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
   
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detlTextView.delegate = self
        setTextView()
        
    }
    
    @IBAction func adaptBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
    }
}

//MARK: 텍스트뷰
extension DetailViewController: UITextViewDelegate {

    func setTextView(){
        
        theTextViewHeightConstraint.isActive = false // 스토리보드에 설정된 콘스트레이트 무시
        detlTextView.sizeToFit()
        detlTextView.isScrollEnabled = false
        textViewDidChange(detlTextView)
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
