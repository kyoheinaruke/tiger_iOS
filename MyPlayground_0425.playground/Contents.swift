//: Playground - noun: a place where people can play

import UIKit
import Foundation

//ジャンケン配列
let jankenar : [String] = ["グー","チョキ","パー"]

//ジャンケン配列の要素と値を表示(繰り返し)
for (ct, value) in jankenar.enumerated(){
    print("\(ct)：\(value)")
}


print("---------------------------------------------------")

//繰り返し
for count in 1...10 {
    print("\(count)回目") //ランダム関数の(n回目表示)
    
    let p1 = arc4random_uniform(2) //Player1の手をランダム関数で決める
    let p2 = arc4random_uniform(2) //Player2の手をランダム関数で決める

    print("・P1は\(p1),\(jankenar[Int(p1)])") //Player1の手の結果を表示
    print("・P2は\(p2),\(jankenar[Int(p2)])") //Player2の手の結果を表示

    if p1 == 0 {  //P1がグーの場合
        if p2 == 0 { //P2がグーの場合
            print("引き分け")
        } else if p2 == 1 { //P2がチョキの場合
            print("p1の勝ち")
        } else { //P2がパーの場合
            print("p1の負け")
        }
    } else if p1 == 1 { //P1がチョキの場合
        if p2 == 0 { // P2がグーの場合
            print("p1の負け")
        } else if p2 == 1 { //P2がチョキの場合
            print("引き分け")
        } else { //P2がパーの場合
            print("p1の勝ち")
        }
    } else { // P1がパーの場合
        if p2 == 0 { // P2がグーの場合
            print("p1の勝ち")
        } else if p2 == 1 { //P2がチョキの場合
            print("p1の負け")
        } else { //P2がパーの場合
            print("引き分け")
        }
    }
    
    print()
    
}
