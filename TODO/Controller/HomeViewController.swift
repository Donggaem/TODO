//
//  HomeViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/24.
//


import UIKit
import FSCalendar

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        calendarView.dataSource = self

        calendarView.appearance.titleDefaultColor = .gray // 평일 날짜 색깔
        calendarView.appearance.titleWeekendColor = .gray // 주말 날짜 색깔
        calendarView.appearance.weekdayTextColor = .gray // 요일 날짜 색깔
        calendarView.appearance.headerTitleColor = .black // 헤더의 폰트 색상 설정
        
        calendarView.appearance.headerDateFormat = "YYYY년 MM월" // 헤더의 날짜 포맷 설정
        calendarView.appearance.headerTitleFont = UIFont(name: "toboto", size: 18)
        calendarView.appearance.headerTitleAlignment = .center // 헤더의 폰트 정렬 설정
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
    }
    

    

}
