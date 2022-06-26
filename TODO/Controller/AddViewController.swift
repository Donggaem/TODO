//
//  AddViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/25.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.backgroundColor = .blue
        self.initTitle()
        
    }
    
    func initTitle() {
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))

        // 타이틀 속성
        nTitle.textAlignment = .center
        nTitle.font = UIFont.systemFont(ofSize: 24)
        nTitle.text = "APP TODO"
        nTitle.textColor = .white

//        let color = UIColor(red: 59, green: 130, blue: 246, alpha: 1.0)
//
//        self.navigationController?.navigationBar.backgroundColor = color
        self.navigationItem.titleView = nTitle
    }
}
