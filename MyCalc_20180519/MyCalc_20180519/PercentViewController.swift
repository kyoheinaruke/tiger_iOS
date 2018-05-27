//
//  PercentViewController.swift
//  MyCalc_20180519
//
//  Created by systena on 2018/05/19.
//  Copyright © 2018年 Kyohei Naruke. All rights reserved.
//

import UIKit

class PercentViewController: UIViewController {
    
    //金額を受け取るプロパティ
    var percent : Int = 0
    
    //割引率を表示するフィールド
    @IBOutlet weak var percentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap1Button(_ sender: Any) { //1ボタンタップ
        let value = percentField.text! + "1"      //文字列として1を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap2Button(_ sender: Any) { //2ボタンタップ
        let value = percentField.text! + "2"      //文字列として2を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap3Button(_ sender: Any) { //3ボタンタップ
        let value = percentField.text! + "3"      //文字列として3を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap4Button(_ sender: Any) { //4ボタンタップ
        let value = percentField.text! + "4"      //文字列として4を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap5Button(_ sender: Any) { //5ボタンタップ
        let value = percentField.text! + "5"      //文字列として5を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap6Button(_ sender: Any) { //6ボタンタップ
        let value = percentField.text! + "6"      //文字列として6を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap7Button(_ sender: Any) { //7ボタンタップ
        let value = percentField.text! + "7"      //文字列として7を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap8Button(_ sender: Any) { //8ボタンタップ
        let value = percentField.text! + "8"      //文字列として8を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap9Button(_ sender: Any) { //9ボタンタップ
        let value = percentField.text! + "9"      //文字列として9を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tap0Button(_ sender: Any) { //0ボタンタップ
        let value = percentField.text! + "0"      //文字列として0を追加する
        if let percent = Int(value){              //Int型に変換（nilでないことを確認済み）
            percentField.text = "\(percent)"        //価格フィールドに数値を反映する
        }
    }
    
    @IBAction func tapCButton(_ sender: Any) { //Cボタンタップ
        percentField.text = "0"            //価格フィールドに数値を反映する
        
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
