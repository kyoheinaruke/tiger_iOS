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
    
    let p1 = arc4random_uniform(UInt32(count + 3)) % 3 //Player1の手をランダム関数で決める
    let p2 = arc4random_uniform(UInt32(count + 3)) % 3 //Player2の手をランダム関数で決める

    print("・P1は\(p1),\(jankenar[Int(p1)])") //Player1の手の結果を表示
    print("・P2は\(p2),\(jankenar[Int(p2)])") //Player2の手の結果を表示

    let Mat = (p1 , p2)
    
    switch Mat {
        case (0,0) : print("引き分け") //P1がグーの場合,P2がグーの場合
        case (0,1) : print("p1の勝ち") //P1がグーの場合,P2がチョキの場合
        case (0,2) : print("p1の負け") //P1がグーの場合,P2がパーの場合
        
        case (1,0) : print("p1の負け") //P1がチョキの場合,P2がグーの場合
        case (1,1) : print("引き分け") //P1がチョキの場合,P2がチョキの場合
        case (1,2) : print("p1の勝ち") //P1がチョキの場合,P2がパーの場合
        
        case (2,0) : print("p1の勝ち") //P1がパーの場合,P2がグーの場合
        case (2,1) : print("p1の負け") //P1がパーの場合,P2がチョキの場合
        case (2,2) : print("引き分け") //P1がパーの場合,P2がパーの場合
        
        default : print("エラー")

    }
    
    print()
    
}
