//
//  MemoListTableViewController.swift
//  YourThink
//
//  Created by Minseop Kim on 2020/03/02.
//  Copyright © 2020 yourThink. All rights reserved.
//

import UIKit

class ThinkListTableViewController: UITableViewController {

     let formatter: DateFormatter = {
        let f = DateFormatter()
         f.dateStyle = .long
         f.timeStyle = .short
         f.locale = Locale(identifier: "Ko_kr")
         return f
     }()
     
     override func viewWillAppear(_ animated: Bool) {
         //데이터 소스가 전달하는 최신 데이터로 업데이트 하는 것
         super.viewWillAppear(animated)
         DataManager.shared.fetchMemo()
         tableView.reloadData()
         
     }

     // observer를 받아들이고 혜제하는 것
     var token: NSObjectProtocol?
     deinit {
         if let token = token {
             NotificationCenter.default.removeObserver(token)
         }
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
             if let vc = segue.destination as? DetailViewController {
                 vc.memo = DataManager.shared.memoList[indexPath.row]
             }
         }
         
         
     }
         
    override func viewDidLoad() {
         super.viewDidLoad()
         thinkCellTableView.delegate = self
         thinkCellTableView.dataSource = self

         token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main){ [weak self] (noti) in self?.tableView.reloadData()
         }

     }
        
    @IBOutlet weak var thinkCellTableView: UITableView!
    

    // MARK: - Table view data source

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // 이 메소드를 통해 몇개의 테이블 뷰를 호출할지
         return DataManager.shared.memoList.count
     }

     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // 개별 셀을 화면에 호출할때 마다 반복적을 호출된다!, IndexPath가 몇번째 셀인지
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         // indexpath 의 row 데이터에 몇번째 쎌인지 알 수 있다.
         let target = DataManager.shared.memoList[indexPath.row]
         
        cell.textLabel?.text = target.memoTitle
        cell.detailTextLabel?.text = formatter.string(for : target.insertDate)

         return cell
     }
     

     
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         return true
     }
     
     
     override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         return .delete
     }
     
     
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             
             let target = DataManager.shared.memoList[indexPath.row]
             DataManager.shared.delectMemo(target)
             
             DataManager.shared.memoList.remove(at: indexPath.row)
             
             tableView.deleteRows(at: [indexPath], with: .fade)
             
         } else if editingStyle == .insert {
         }
     }
     


}
