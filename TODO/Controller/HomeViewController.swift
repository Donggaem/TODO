//
//  HomeViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/24.
//


import UIKit
import FSCalendar

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {


    @IBOutlet weak var year: UILabel!
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
        calendarView.appearance.headerTitleAlignment = .left // 헤더의 폰트 정렬 설정
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendarView.calendarHeaderView.isHidden = true
        calendarView.headerHeight = 0

        year.text = dateFormatter.string(from: calendarView.currentPage)
        year.sizeToFit()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        year.text = self.dateFormatter.string(from: calendarView.currentPage)
        }
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy년 M월"
        return df
    }()
}
