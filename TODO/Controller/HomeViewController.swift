//
//  HomeViewController.swift
//  TODO
//
//  Created by 김동겸 on 2022/06/24.
//


import UIKit
import FSCalendar
import Alamofire

class HomeViewController: UIViewController {
    
    var todoList: [TodoList] = []
    var selectedList: [TodoList] = []
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var todoTableView: UITableView!
    
    //날짜 포맷
    private lazy var dateFormatter: DateFormatter = {
        let fomatter = DateFormatter()
        fomatter.locale = Locale(identifier: "ko_KR")
        fomatter.dateFormat = "YYYY년 MM월"
        return fomatter
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
                        print(todoList)
                        
                        self.todoTableView.reloadData()
                        self.calendarView.reloadData()
                        
                    } else {
                        print("추가 실패")
                        let addFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        addFail_alert.addAction(okAction)
                        present(addFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let addFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    addFail_alert.addAction(okAction)
                    present(addFail_alert, animated: false, completion: nil)
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
        return self.todoList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        let data = self.todoList[indexPath.row]
        userCell.cellTitleLabel.text = data.title
        userCell.cellContentLabel.text = data.content
        
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
    
    //날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            
            
        }
}


