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
    
    private var todoList: [AllObject] = []
    private var selectedList: [Object] = []
    private var events: [String] = []
    
    private var selectedDate = ""
    
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
        
        setUI()
        
        getTodo()
        getAllTodo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        getTodo()
        getAllTodo()
        
        self.todoTableView.reloadData()
        self.calendarView.reloadData()
        
    }
    
    //MARK: SET UI
    private func setUI() {
        
        //오늘날짜
        let date = NSDate()
        let toDayformatter = DateFormatter()
        toDayformatter.dateFormat = "yyyy-MM-dd"
        selectedDate = toDayformatter.string(from: date as Date)
        print(selectedDate)
        
        //CalendarView
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        setCalendar()
        
        self.calendarView.reloadData()
        
        //TableView
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoTableViewCell")
        
        todoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블뷰 셀 선 없애기
        todoTableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat.leastNonzeroMagnitude))
        self.todoTableView.reloadData()
        
    }
    
    //MARK: IBAction
    // AddView 화면으로 이동
    @IBAction func addBtn(_ sender: UIButton) {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(addVC, animated: true)
        
        addVC.paramSeletedDate = selectedDate
    }
    
    @IBAction func settingBtn(_ sender: UIButton) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingPageViewController") as! SettingPageViewController
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    //MARK: GET TODOLIST
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getTodo() {
        AF.request("\(TodoURL.baseURL)/\(selectedDate)", method: .get, headers: header)
            .validate()
            .responseDecodable(of: TodoListResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        self.selectedList.removeAll()
                        
                        self.selectedList = response.data?.findedTodo ?? []
                        
                        self.todoTableView.reloadData()
                        //                        self.calendarView.reloadData()
                        
                        
                    } else {
                        print("조회실패")
                    }
                case .failure(let error):
                    self.selectedList.removeAll()
                    print("failure: \(error.localizedDescription)")
                }
            }
    }
    
    //MARK: GET ALLTODOLIST
    private func getAllTodo() {
        AF.request(TodoURL.baseURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: AllTodoListResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        self.todoList.removeAll()
                        
                        self.todoList = response.data?.findedAllTodo ?? []
                        
                        self.setEvents()
                        self.todoTableView.reloadData()
                        self.calendarView.reloadData()
                        
                        
                    } else {
                        print("조회실패")
                    }
                case .failure(let error):
                    self.selectedList.removeAll()
                    print("failure: \(error.localizedDescription)")
                }
            }
    }
    
    //MARK: DELETETODO
    private func postDelete(_ parameters: DeleteTodoRequest){
        AF.request(TodoURL.baseURL, method: .delete, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: DeleteTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(response)
                    if response.isSuccess == true {
                        print("투두 삭제 성공")
                        
                        self.getAllTodo()
                        self.getTodo()
                        
                        self.todoTableView.reloadData()
                        self.calendarView.reloadData()
                        
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
        
        detailVC.paramuuid = self.selectedList[indexPath.row].id
        detailVC.paramTitle = self.selectedList[indexPath.row].title
        detailVC.paramDate = self.selectedList[indexPath.row].date
        detailVC.paramContent = self.selectedList[indexPath.row].content
        
    }
    
    //셀 밀어서 삭제
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //투두 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let tbDelete_alert = UIAlertController(title: "삭제", message: "투두를 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "예", style: .default) { (action) in
                
                let uuid = self.selectedList[indexPath.row].id
                let param = DeleteTodoRequest(id: uuid )
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
        
        //        selectedDate = ""
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateformatter.string(from: date)
        print(selectedDate)
        
        
        todoTableView.reloadData()
        //        calendarView.reloadData()
        getTodo()
        print(selectedList)
    }
    
    private func setEvents(){
        events.removeAll()
        
        for index in 0..<todoList.endIndex {
            let arr = todoList[index].date.components(separatedBy: "T00:00:00.000Z")
            events.append(arr[0])
        }
    }
    
    //이벤트 닷 표시갯수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        setEvents()
        let eventformatter = DateFormatter()
        eventformatter.dateFormat = "yyyy-MM-dd"
        let eventDate = eventformatter.string(from: date)
        
        if events.contains(eventDate) {
            return 1
        } else {
            return 0
        }
    }
}


