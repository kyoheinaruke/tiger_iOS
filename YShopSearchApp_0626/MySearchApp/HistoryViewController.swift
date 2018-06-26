//
//  HistoryViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/23.
//  Copyright © 2018年 Mao Nishi. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    //検索履歴を格納した配列
    var historylist = [SearchHistory]()
    // 遷移先のViewControllerに渡す変数
    var giveData: String = "hoge"
    
    //tableViewの宣言
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 保存している検索履歴の読み込み処理
        let userDefaults = UserDefaults.standard
        if let storedHistoryList = userDefaults.object(forKey: "historyText") as? Data {
            if let unarchiveHistoryList = NSKeyedUnarchiver.unarchiveObject(with: storedHistoryList) as? [SearchHistory] {
                historylist.append(contentsOf: unarchiveHistoryList)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //テーブルの行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //検索履歴の配列の長さを返却する
        return historylist.count
    }
    
    //テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Storyboardで指定したhistoryCellCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        //行番号にあった検索履歴の情報を取得
        let myhistory = historylist[indexPath.row]
        
        //セルのラベルに検索履歴のテキストをセット
        cell.textLabel?.text = myhistory.searchText
        
        return cell
    }
    
    //編集ボタンをタップしたときの処理
    @IBAction func changeMode(sender: AnyObject) {
        //通常モードと編集モードを切り替える。
        if(tableView.isEditing == true) {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    //削除ボタンをタップしたときの処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //削除処理かどうか
        if editingStyle == UITableViewCellEditingStyle.delete {
            //検索履歴リストから削除
            historylist.remove(at: indexPath.row)
            //セルを削除
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //データの保存　Date型にシリアライズする
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: historylist)
            //UserDefaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "historyText")
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
    
    //検索履歴のリストをタップしたらモーダルを閉じて元の画面の検索窓に値をセットする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let myhistory = historylist[indexPath.row]
        giveData = myhistory.searchText!
        
        // navigationControllerを取得
        let navigationController = self.presentingViewController as! UINavigationController
        
        // 前画面のViewControllerを取得
        let iewController = navigationController.topViewController as! SearchItemTableViewController
        
        // 前画面のViewControllerの値を更新
        iewController.receiveData = giveData
        
        // モーダルを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


