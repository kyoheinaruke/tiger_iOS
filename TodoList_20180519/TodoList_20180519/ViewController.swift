//
//  ViewController.swift
//  TodoList_20180519
//
//  Created by systena on 2018/05/19.
//  Copyright © 2018年 Kyohei Naruke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //TODOを格納した配列
    var todoList = [String]()
    
    //テーブルビューの紐付け、表示
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // +ボタンがタップされた時の処理
    @IBAction func tapAddButton(_ sender: Any) {
        //アラートダイアログを作成
        let alertController = UIAlertController(title: "ToDo追加" , message: "ToDoを入力してください", preferredStyle: UIAlertControllerStyle.alert)
        
        //テキストエリアを追加
        alertController.addTextField(configurationHandler: nil)
        
        //OKボタンを追加
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(action: UIAlertAction) in
            //OKボタンがタップされた時の処理
            if let textFiled = alertController.textFields?.first {
                //ToDoの配列に入力値を挿入。先頭に挿入する。
                self.todoList.insert(textFiled.text!, at: 0)
                
                //テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],with: UITableViewRowAnimation.right)
            }
        }
        //OKボタンがタップされたときの処理
        alertController.addAction(okAction)
        
        //CANCELボタンがタップされたときの処理
        let cancelButton = UIAlertAction(title: "CANCEL",style: UIAlertActionStyle.cancel, handler: nil)
        //CANCELボタンを追加
        alertController.addAction(cancelButton)
        
        //アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
        
    }
    
    //テーブルの行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //ToDoの配列の長さを返却する
        return todoList.count
    }
    
    //テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        //行番号にあったToDoのタイトルを取得
        let todoTitle = todoList[indexPath.row]
        //セルのラベルにTODOのタイトルをセット
        cell.textLabel?.text = todoTitle
        return cell
    }


}

