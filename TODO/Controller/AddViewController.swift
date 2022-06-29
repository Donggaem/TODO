//
//  AddViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/25.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var addView: UIView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviSet()
        addViewSet()
    }
    
    
    //MARK: 네비게이션바
    //타이틀 설정
    private func initTitle() {
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 128, height: 16))

        // 타이틀 속성
        nTitle.textAlignment = .center
        nTitle.font = UIFont.systemFont(ofSize: 24)
        nTitle.text = "ADD TODO"
        nTitle.textColor = .white

        self.navigationItem.titleView = nTitle
    }
    
    //네이게이션 바 설정
    private func naviSet() {
        
        //back버튼 설정
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""

        //네비게이션 바 투명처리
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.initTitle()
    }
    
    //MARK: addView
    private func addViewSet() {
        //View 모서리설정
        addView.layer.cornerRadius = 20
        addView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addView.layer.masksToBounds = true
    }
}
