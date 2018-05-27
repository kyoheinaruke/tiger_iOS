//
//  ViewController.swift
//  MyCalc_20180519
//
//  Created by systena on 2018/05/19.
//  Copyright © 2018年 Kyohei Naruke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //金額を表示するフィールド
    @IBOutlet weak var priceField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       //UserDefaultsの参照
        let userDefaults = UserDefaults.standard
        
        //textというキーを指定して保存していた値を取り出す
        if let value = userDefaults.string(forKey : "text"){
            priceField.text = value
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap1Button(_ sender: Any) { //1ボタンタップ
        let value = priceField.text! + "1"      //文字列として1を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap2Button(_ sender: Any) { //2ボタンタップ
        let value = priceField.text! + "2"      //文字列として2を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap3Button(_ sender: Any) { //3ボタンタップ
        let value = priceField.text! + "3"      //文字列として3を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap4Button(_ sender: Any) { //4ボタンタップ
        let value = priceField.text! + "4"      //文字列として4を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap5Button(_ sender: Any) { //5ボタンタップ
        let value = priceField.text! + "5"      //文字列として5を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap6Button(_ sender: Any) { //6ボタンタップ
        let value = priceField.text! + "6"      //文字列として6を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap7Button(_ sender: Any) { //7ボタンタップ
        let value = priceField.text! + "7"      //文字列として7を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap8Button(_ sender: Any) { //8ボタンタップ
        let value = priceField.text! + "8"      //文字列として8を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap9Button(_ sender: Any) { //9ボタンタップ
        let value = priceField.text! + "9"      //文字列として9を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap0Button(_ sender: Any) { //0ボタンタップ
        let value = priceField.text! + "0"      //文字列として0を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap00Button(_ sender: Any) { //00ボタンタップ
        let value = priceField.text! + "00"     //文字列として00を追加する
        if let price = Int(value){              //Int型に変換（nilでないことを確認済み）
            priceField.text = "\(price)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tapCButton(_ sender: Any) { //Cボタンタップ
        priceField.text = "0"            //価格フィールドに数値を反映する
        
    }
    
    //ボタンをタップしたときの処理
    @IBAction func tapActionButton(_ sender: Any) {
        //UserDefaultsの参照
        let userDefaults = UserDefaults.standard
        
        //textというキーで値を保存する
        userDefaults.set(priceField.text, forKey : "text")
        
        //UserDefaultsへの値の保存を明示的に行う
        userDefaults.synchronize()
        
    }
    
    //画面遷移時の処理
    override func prepare (for segue : UIStoryboardSegue,sender : Any?){
        
        //次画面の取り出し
        let viewController = segue.destination as! PercentViewController
        
        //金額フィールドの文字列
        
    }
    
    
    //最後の画面から遷移後の処理
    @IBAction func restart(_ segue : UIStoryboardSegue){
        priceField.text = "0" //金額フィールドのクリアを行う
    }
    
    
}

