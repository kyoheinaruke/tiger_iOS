//
//  ViewController.swift
//  TodoList_20180519
//
//  Created by systena on 2018/05/19.
//  Copyright © 2018年 Kyohei Naruke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate {
    
    //TODOを格納した配列
    var todoList = [MyTodo]()
    
    //テーブルビューの紐付け、表示
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 保存しているToDoの読み込み処理
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(with: storedTodoList) as? [MyTodo] {
                todoList.append(contentsOf: unarchiveTodoList)
            }
        }
        
        //編集ボタンの実装（ボタンをタップしたとき処理の別実装方法）
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "ToDoリスト"
        navigationItem.leftBarButtonItem = editButtonItem
        
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
        
        //追加ボタンを追加
        let okAction = UIAlertAction(title: "追加", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            //OKボタンがタップされた時の処理
            if let textField = alertController.textFields?.first {
                //ToDoの配列に入力値を挿入。先頭に挿入する。
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, at: 0)
                
                //テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                          with: UITableViewRowAnimation.right)
                
                //ToDoの保存処理
                let userDefaults = UserDefaults.standard
                // Date型にシリアライズする
                let date = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
                userDefaults.set(date, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        //追加ボタンがタップされたときの処理
        alertController.addAction(okAction)
        
        //キャンセルボタンがタップされたときの処理
        let cancelButton = UIAlertAction(title: "キャンセル",style: UIAlertActionStyle.cancel, handler: nil)
        //キャンセルボタンを追加
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
        
        //行番号にあったToDoの情報を取得
        let myTodo = todoList[indexPath.row]
        //セルのラベルにTODOのタイトルをセット
        cell.textLabel?.text = myTodo.todoTitle
        //セルのチェックマーク状態をセット
        if myTodo.todoDone {
            //チェックあり
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            //チェックなし
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    
    //セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        if myTodo.todoDone{
            //完了済みの場合は未完了に変更
            myTodo.todoDone = false
        } else {
            //未完了の場合は完了済みに変更
            myTodo.todoDone = true
        }
        
        //セルの状態を変更
        tableView.reloadRows(at: [indexPath],with: UITableViewRowAnimation.fade)
        //データ保存。Date型にシリアライズする
        let date: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        //UserDefaults
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "todoList")
        userDefaults.synchronize()
    }

    //編集ボタンをタップした時の処理 (編集モードに切り替える)
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続
        super.setEditing(editing, animated: animated)
        //モードの切り替え
        tableView.isEditing = editing
    }
    
    
    //セルが移動可能であるかを返却する
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //並び替え時の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // データの順番を整える
        let targetList = todoList[sourceIndexPath.row]
        
        if let index = todoList.index(of: targetList) {
            //選択した元のリストを削除する
            todoList.remove(at: index)
            //移動先に選択していたリストを挿入する
            todoList.insert(targetList, at: destinationIndexPath.row)
            //データの保存　Date型にシリアライズする
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
            //UserDefaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        }
    }
    
    //削除ボタンをタップしたときの処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //削除処理かどうか
        if editingStyle == UITableViewCellEditingStyle.delete {
            //ToDoリストから削除
            todoList.remove(at: indexPath.row)
            //セルを削除
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //データの保存　Date型にシリアライズする
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
            //UserDefaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        }
    }

    //自ら横にフリックして削除ボタンを出せなくする
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }


}





// 独自クラスをシリアライズする際はには、NSObjectを継承し
// NSCodingプロトコルに準拠する必要がある
class MyTodo: NSObject,NSCoding {
    //ToDoのタイトル
    var todoTitle: String?
    //ToDoを完了したかどうかを表すフラグ
    var todoDone: Bool = false
    //コンストラクタ
    override init() {
        
    }
    // NSCodingプロトコルに宣言されているでシリアライズ処理。デコード処理
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    // NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
    
    
}







