//
//  HomeViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/24.
//

import Foundation
import UIKit
import FSCalendar
import Alamofire

class HomeViewController: UIViewController {
    
    var todoList: [TodoList] = []
    var selectedList: [TodoList] = []
    var events: [String] = []
    
    var selectedDate = ""
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var todoTableView: UITableView!
    
    //날짜 포맷
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy 년 MM 월"
        return formatter
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let toDayformatter = DateFormatter()
        toDayformatter.dateFormat = "yyyy년MM월dd일(EEEEE)"
        toDayformatter.locale = Locale(identifier: "ko_KR")
        selectedDate = toDayformatter.string(from: date as Date)
        
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoTableViewCell")
        
        setCalendar()
        
        self.navigationController?.isNavigationBarHidden = true
        
        //테이블뷰 셀 선 없애기
        todoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        let userid = UserDefaults.standard.string(forKey: "userid")!
        let param = TodoListRequest(userid: userid)
        postTodoList(param)
        
        self.todoTableView.reloadData()
        self.calendarView.reloadData()
        setEvents()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // AddView 화면으로 이동
    @IBAction func addBtn(_ sender: UIButton) {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    //MARK: POSTLIST
    func postTodoList(_ parameters: TodoListRequest){
        AF.request("http://13.209.10.30:4004/todo/list", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: TodoListResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        self.todoList = response.todo

                        self.selectedList.removeAll()
                        
                        for index in 0..<todoList.count {
                            let arr = todoList[index].date.components(separatedBy: " ")
                            if arr[0] == selectedDate {
                                let data = todoList[index]
                                let todoData: TodoList = TodoList(no: data.no, title: data.title, content: data.content, userid: data.userid, date: data.date)
                                self.selectedList.append(todoData)
                            }
                        }
                        
                        setEvents()
                        self.todoTableView.reloadData()
                        self.calendarView.reloadData()
                        
                    } else {
                        print("추가 실패")
                        let todoFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        todoFail_alert.addAction(okAction)
                        present(todoFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let todoFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    todoFail_alert.addAction(okAction)
                    present(todoFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POSTDELETE
    func postDelete(_ parameters: DeleteTodoRequest){
        AF.request("http://13.209.10.30:4004/todo/delete", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: DeleteTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("투두 삭제 성공")
                        
                        let userid = UserDefaults.standard.string(forKey: "userid")!
                        let param = TodoListRequest(userid: userid)
                        postTodoList(param)
                        
                    } else {
                        print("투두 삭제 실패")
                        let deleteFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        deleteFail_alert.addAction(okAction)
                        present(deleteFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let deleteFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    deleteFail_alert.addAction(okAction)
                    present(deleteFail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: 테이블뷰
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    //셀크기 동적 변화
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        let data = self.selectedList[indexPath.row]
        userCell.cellTitleLabel.text = data.title
        userCell.cellContentLabel.text = data.content
        
        return userCell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        detailVC.paramTitle = self.selectedList[indexPath.row].title
        detailVC.paramDate = self.selectedList[indexPath.row].date
        detailVC.paramContent = self.selectedList[indexPath.row].content
        detailVC.paramNo = self.selectedList[indexPath.row].no
        
    }
    
    //셀 밀어서 삭제
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //투두 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let tbDelete_alert = UIAlertController(title: "삭제", message: "투두를 삭제하시겠습니끼?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "예", style: .default) { (action) in
                
                print(self.selectedList)
                let userid = UserDefaults.standard.string(forKey: "userid")!
                let no = self.selectedList[indexPath.row].no
                let param = DeleteTodoRequest(no: no, userid: userid)
                self.postDelete(param)
            }
            
            let noAction = UIAlertAction(title: "아니요", style: .default)
            tbDelete_alert.addAction(okAction)
            tbDelete_alert.addAction(noAction)
            
            present(tbDelete_alert, animated: false, completion: nil)
            
        }
    }
}

//MARK: 캘린더 설정
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    private func setCalendar() {
        
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
        
        //이벤트 닷
        calendarView.appearance.eventDefaultColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
        calendarView.appearance.eventSelectionColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
        
        //오늘, 선택한 날짝 색
        calendarView.appearance.todayColor = UIColor.init(red: 0.176, green: 0.831, blue: 0.749, alpha: 1)
        calendarView.appearance.selectionColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
        
        //yearLabel설정
        yearLabel.text = dateFormatter.string(from: calendarView.currentPage)
        yearLabel.sizeToFit()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        yearLabel.text = self.dateFormatter.string(from: calendarView.currentPage)
    }
    
    //날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년MM월dd일(EEEEE)"
        dateformatter.locale = Locale(identifier: "ko_KR")
        selectedDate = dateformatter.string(from: date)
        print(selectedDate)
        
        //배열 초기화
        self.selectedList.removeAll()
        
        for index in 0..<todoList.count {
            
            let arr = todoList[index].date.components(separatedBy: " ")
            
            if arr[0] == selectedDate {
                let data = todoList[index]
                let todoData: TodoList = TodoList(no: data.no, title: data.title, content: data.content, userid: data.userid, date: data.date)
                self.selectedList.append(todoData)
                
            }
        }
        todoTableView.reloadData()
    }
    
    func setEvents(){
        
        events.removeAll()
        
        for index in 0..<todoList.count {
            let arr = todoList[index].date.components(separatedBy: " ")
            events.append(arr[0])
        }
    }
    
    //이벤트 닷 표시갯수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        setEvents()
        let eventformatter = DateFormatter()
        eventformatter.dateFormat = "yyyy년MM월dd일(EEEEE)"
        eventformatter.locale = Locale(identifier: "ko_KR")
        let eventDate = eventformatter.string(from: date)
        
        if events.contains(eventDate) {
            return 1
        } else {
            return 0
        }
    }
}


