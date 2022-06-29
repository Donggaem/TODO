//
//  DetalilViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/26.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailView: UIView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        naviSet()
        detailViewSet()

    }
    
    //MARK: 네비게이션바
    ///타이틀 설정
    private func initTitle() {
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 128, height: 16))

        // 타이틀 속성
        nTitle.textAlignment = .center
        nTitle.font = UIFont.systemFont(ofSize: 24)
        nTitle.text = "APP TODO"
        nTitle.textColor = .white

        self.navigationItem.titleView = nTitle
    }
    
    //네비게이션바 설정
    private func naviSet() {
        //back버튼 설정
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""

        //네비게이션 바 투명처리
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.initTitle()
    }
    
    //MARK: detailView
    private func detailViewSet() {
        //View 모서리설정
        detailView.layer.cornerRadius = 20
        detailView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        detailView.layer.masksToBounds = true
        
    }
}
