//
//  FavoriteViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/26.
//  Copyright © 2018年 Mao Nishi. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //検索履歴を格納した配列
    
    //tableViewの宣言
    @IBOutlet weak var tableView: UITableView!
    

    
    // 数字を金額の形式に整形するためのフォーマッター
    let priceFormat = NumberFormatter()
    
    var imageCache = NSCache<AnyObject, UIImage>()
    
    var favoriteList = [MyItemList]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 保存しているお気に入りの読み込み処理
        let userDefaults = UserDefaults.standard
        if let storedFavoriteList = userDefaults.object(forKey: "favoriteList") as? Data {
            if let unarchiveFavoriteList = NSKeyedUnarchiver.unarchiveObject(with: storedFavoriteList) as? [MyItemList] {
                favoriteList.append(contentsOf: unarchiveFavoriteList)
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
        return favoriteList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell_f", for: indexPath) as! ItemTableViewCell
        
        let myItemData = favoriteList[indexPath.row]
        
        // 商品のタイトル設定
        cell.itemTitleLabel.text = myItemData.name
        // 商品価格設定処理（日本通貨の形式で設定する）
        let number = NSNumber(integerLiteral: Int(myItemData.price!)!)
        cell.itemPriceLabel.text = priceFormat.string(from: number)
        
        
        // 商品の総合評価を設定処理
        let rate = myItemData.review
        cell.itemRateLabel.text = ("評価\(rate!)／5")
        // 商品の評価件数を設定処理
        let reviewCount = myItemData.count
        cell.itemCountLabel.text = ("\(reviewCount!)件")
        
        
        // 商品のURL設定
        cell.itemUrl = myItemData.url
        // 画像の設定処理
        // すでにセルに設定されている画像と同じかどうかチェックする
        // 画像がまだ設定されていない場合に処理を行う
        guard let itemImageUrl = myItemData.medium else {
            // 画像なし商品
            return cell
        }
        // キャッシュの画像を取り出す
        if let cacheImage = imageCache.object(forKey: itemImageUrl as
            AnyObject) {
            // キャッシュ画像の設定
            cell.itemImageView.image = cacheImage
            return cell
        }
        // キャッシュの画像がないためダウンロードする
        guard let url = URL(string: itemImageUrl) else {
            // urlが生成できなかった
            return cell
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data:Data?,
            response:URLResponse?, error:Error?) in
            guard error == nil else {
                // エラーあり
                return
            }
            guard let data = data else {
                // データが存在しない
                return
            }
            guard let image = UIImage(data: data) else {
                // imageが生成できなかった
                return
            }
            // ダウンロードした画像をキャッシュに登録しておく
            self.imageCache.setObject(image, forKey: itemImageUrl as AnyObject)
            // 画像はメインスレッド上で設定する
            DispatchQueue.main.async {
                cell.itemImageView.image = image
            }
        }
        // 画像の読み込み処理開始
        task.resume()
        
        return cell
    }
    // 商品をタップして次の画面に遷移する前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ItemTableViewCell {
            if let webViewController =
                segue.destination as? WebViewController {
                // 商品ページのURLを設定する
                webViewController.itemUrl = cell.itemUrl
            }
        }
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
            //お気に入りリストから削除
            favoriteList.remove(at: indexPath.row)
            //セルを削除
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //データの保存　Date型にシリアライズする
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteList)
            //UserDefaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "favoriteList")
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
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
