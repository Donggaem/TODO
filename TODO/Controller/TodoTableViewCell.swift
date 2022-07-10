//
//  TodoTableViewCell.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/30.
//

import UIKit

class TodoTableViewCell: UITableViewCell, UITableViewDelegate {
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellContentLabel: UILabel!
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0))
//    }

    
}
