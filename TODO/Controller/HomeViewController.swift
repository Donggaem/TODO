//
//  HomeViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/24.
//


import UIKit
import FSCalendar

//테이블쎌 구조
struct cellModel {
    let title: String
    let contents: String
}



class HomeViewController: UIViewController {
    
    let testarray: [cellModel] = [
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa"),
        cellModel(title: "1", contents: "aaa")
    ]
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var todoTableView: UITableView!
    
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

        
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoTableViewCell")
        
        setCalendar()
        
        
    }
    
    // AddView 화면으로 이동
    @IBAction func addBtn(_ sender: UIButton) {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    
}

//MARK: 테이블뷰
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testarray.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        let data = self.testarray[indexPath.row]
        userCell.cellTitleLabel.text = data.title
        userCell.cellContentLabel.text = data.contents
        
        return userCell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //    //셀 밀어서 삭제
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //    //투두 삭제
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //
    //        }
    //    }
}

//MARK: 캘린더 설정
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    private func setCalendar() {
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.placeholderType = .none // 전,다음달 날짜 숨기기
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


