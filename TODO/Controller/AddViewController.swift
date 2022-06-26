//
//  AddViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/25.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var addView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //View 모서리설정
        addView.layer.cornerRadius = 20
        addView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addView.layer.masksToBounds = true
        
        //back버튼 설정
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""

        //네비게이션 바 투명처리
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.initTitle()
        
    }
    
    func initTitle() {
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 128, height: 16))

        // 타이틀 속성
        nTitle.textAlignment = .center
        nTitle.font = UIFont.systemFont(ofSize: 24)
        nTitle.text = "APP TODO"
        nTitle.textColor = .white

        self.navigationItem.titleView = nTitle
    }
}
