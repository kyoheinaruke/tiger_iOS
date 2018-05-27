//
//  ResultViewController.swift
//  MyCalc_20180519
//
//  Created by systena on 2018/05/19.
//  Copyright © 2018年 Kyohei Naruke. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    //最初の画面で入力した金額
    var price : Int = 0
    
    //全画面で入力した割合
    var percent : Int = 0
    
    //計算結果を表示するフィールド
    @IBOutlet weak var resultField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //割引率の算出
        let percentValue = Float(percent) / 100
        
        //割引金額の算出
        let waribikiPrice = Float(price) * percentValue
        
        //割引後の金額を算出
        let persenOffPrice = price - Int(waribikiPrice)
        
        //結果を表示する
        resultField.text = "\(persenOffPrice)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
