//
//  ComposeViewController.swift
//  YourThink
//
//  Created by Minseop Kim on 2020/03/02.
//  Copyright © 2020 yourThink. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    var editTarget: Memo?
    var originalMemoContent: String?
    var originalMemoTitle: String?

    @IBOutlet weak var thinkTitleField: UITextField!
    
    
    
    
    @IBOutlet weak var thinkmemoTextView: UITextView!
    
    
    @IBAction func closeWrite(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveWrite(_ sender: Any) {
        
        guard let memo = thinkmemoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }
        
        guard let memoTitle = thinkTitleField.text, memoTitle.count > 0 else{
            alert(message: "제목을 입력하세요")
            return
            
        }
        if let target = editTarget{
            target.content = memo
            target.memoTitle = memoTitle
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name : ComposeViewController.memoDidChange ,object: nil)
        }else {
            DataManager.shared.addNewMemo(memo, memoTitle)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)

        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    

    
    
    
    var token: NSObjectProtocol?
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
        
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if let memo = editTarget{
            navigationItem.title = "메모 편집"
            thinkmemoTextView.text = memo.content
            thinkTitleField.text = memo.memoTitle
            originalMemoContent = memo.content
            originalMemoTitle = memo.memoTitle
        
        }else {
            navigationItem.title = "새 메모"
            thinkmemoTextView.text = "여기에 메모 내용을 입력하세요"
        }
    }
    
}

extension ComposeViewController {
    
    
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memDidChange")
}

