//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//セッションの取り出し
let session = URLSession.shared

//URLオブジェクトを生成
if let url = URL(string: "http://www.yahoo.co.jp") {
    //リストオブジェクトを生成
    let request = URLRequest(url: url)
    
    //処理タスクを生成
    let task = session.dataTask(with: request, completionHandler: {
        (data: Data?, response:URLResponse?, error:Error?) in
        
        //データ取得後に呼ばれる処理はここに記載する
        guard let data = data else {
            print("データなし")
            return
        }
        
        //Data型の変数をString型に変換してprintで出力
        let value = String(data: data, encoding: String.Encoding.utf8)
        print(value)
    })
    
    //処理開始
    task.resume()
    
    
}



// https://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch?appid=dj00aiZpPUNIckZyVnhsSmhSSCZzPWNvbnN1bWVyc2VjcmV0Jng9NWU-&query=iphone






