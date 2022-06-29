//
//  HomeViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/24.
//


import UIKit
import FSCalendar

class HomeViewController: UIViewController {


    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    
    //날짜 포맷
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy년 M월"
        return df
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setCalendar()
        
    }
    

}

//MARK: 캘린더 설정
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    private func setCalendar() {
        
        calendarView.delegate = self
        calendarView.dataSource = self

        calendarView.appearance.titleDefaultColor = .gray // 평일 날짜 색깔
        calendarView.appearance.titleWeekendColor = .gray // 주말 날짜 색깔
        calendarView.appearance.weekdayTextColor = .gray // 요일 날짜 색깔
        calendarView.appearance.headerTitleColor = .black // 헤더의 폰트 색상 설정

        calendarView.appearance.headerDateFormat = "YYYY년 MM월" // 헤더의 날짜 포맷 설정
        calendarView.appearance.headerTitleAlignment = .left // 헤더의 폰트 정렬 설정
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendarView.calendarHeaderView.isHidden = true // 헤더 숨기기
        calendarView.headerHeight = 0 // 헤더 높이 조정

        //yearLabel설정
        yearLabel.text = dateFormatter.string(from: calendarView.currentPage)
        yearLabel.sizeToFit()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        yearLabel.text = self.dateFormatter.string(from: calendarView.currentPage)
        }
}
