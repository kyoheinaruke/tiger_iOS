//: Playground - noun: a place where people can play
import UIKit
import Foundation

//ジャンケン配列
let jankenar : [String] = ["グー","チョキ","パー"]

//ジャンケン配列の要素と値を表示(繰り返し)
for (ct, value) in jankenar.enumerated(){
    print("\(ct)：\(value)")
}

//ランダムで取得した手をの勝敗を判定する関数
var drawcount = 0
var wincount = 0
var losecount = 0

func Match (P1 : Int , P2 : Int) -> String {
    
    let match = (P1 , P2)
    let result : String
    
    switch match {
        //あいこの場合
        case (0,0),(1,1),(2,2) : result = "あいこ"
        drawcount += 1 //あいこの回数をカウント
        
        //P1の勝ちのパターン
        case (0,1),(1,2),(2,0) : result = "P1の勝ち"
        wincount += 1 //P1が勝った回数をカウント
        
        //P1の勝ちのパターン
        case (0,2),(1,0),(2,1) : result = "P1の負け"
        losecount += 1 //P1が負けた回数をカウント
        
        //エラーのパターン
        default : result = "エラー"
    }
    //戻り値
    return result
}

print("---------------------------------------------------")

//繰り返し(配列の数値を直接見るパターン)
for count in 1...1000 {
    print("\(count)回目") //ランダム関数の(n回目表示)
    
    let p1 = arc4random_uniform(UInt32(count + 3)) % 3 //Player1の手をランダム関数で決める
    let p2 = arc4random_uniform(UInt32(count + 3)) % 3 //Player2の手をランダム関数で決める

    print("・P1は\(p1),\(jankenar[Int(p1)])です") //Player1の手の結果を表示
    print("・P2は\(p2),\(jankenar[Int(p2)])です") //Player2の手の結果を表示

    
    let match = Match(P1:Int(p1) , P2:Int(p2)) //勝敗を判定する関数の呼び出し
    
    print("結果は\(match)でした！\n") //勝敗の表示
    
}

//最終結果を表示
print("↓ ↓ ↓ 最終結果 ↓ ↓ ↓")
print("あいこの回数は\(drawcount)回でした。")
print("P1が勝った回数は\(wincount)回でした。")
print("P1が負けた回数は\(losecount)回でした。")

