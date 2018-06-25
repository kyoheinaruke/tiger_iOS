import UIKit

class SearchItemTableViewController: UITableViewController, UISearchBarDelegate{
    
    var itemDataArray =  [ItemData]()
    var historylist = [SearchHistory]()
    let searchBar = UISearchBar()
    
    //検索履歴でタップした値を検索窓にセットする
    var receiveData: String = "" {
        didSet {
            searchBar.text = receiveData
        }
    }
    
    var imageCache = NSCache<AnyObject, UIImage>()
    
    // APIを利用するためのクライアントID
    let appid = "dj00aiZpPUNIckZyVnhsSmhSSCZzPWNvbnN1bWVyc2VjcmV0Jng9NWU-"
    let entryUrl: String = "https://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch"
    
    // 数字を金額の形式に整形するためのフォーマッター
    let priceFormat = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 保存している検索履歴の読み込み処理
        let userDefaults = UserDefaults.standard
        if let storedHistoryList = userDefaults.object(forKey: "historyText") as? Data {
            if let unarchiveHistoryList = NSKeyedUnarchiver.unarchiveObject(with: storedHistoryList) as? [SearchHistory] {
                historylist.append(contentsOf: unarchiveHistoryList)
            }
        }
        
        // 価格のフォーマット指定
        priceFormat.numberStyle = .currency
        priceFormat.currencyCode = "JPY"
        
        //長押しアクションの宣言
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //searchBarの実装
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar.placeholder = "検索キーワードを入力してください"
        searchBar.delegate = self
        
        return searchBar
    }
    
    //searchBarの幅
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // キーボードのsearchボタンがタップされたときに呼び出される
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 入力された文字の取り出し
        guard let inputText = searchBar.text else {
            // 入力文字なし
            return
        }
        
        // 入力文字数が0文字より多いかどうかチェックする
        guard inputText.lengthOfBytes(using: String.Encoding.utf8) > 0 else {
            // 0文字より多くはなかった
            return
        }
        
        // 保持している商品をいったん削除
        itemDataArray.removeAll()
        
        // パラメータを指定する
        let parameter = ["appid": appid, "query": inputText]
        
        // パラメータをエンコードしたURLを作成する
        let requestUrl = createRequestUrl(parameter: parameter)
        
        // APIをリクエストする
        request(requestUrl: requestUrl)
        
        // キーボードを閉じる
        searchBar.resignFirstResponder()
        
        
        //検索履歴の配列に入力値を挿入。先頭に挿入する。
        let historyText = SearchHistory()
        historyText.searchText = inputText
        self.historylist.insert(historyText, at: 0)
        
        //検索履歴の保存処理
        let userDefaults = UserDefaults.standard
        // Date型にシリアライズする
        let date = NSKeyedArchiver.archivedData(withRootObject: self.historylist)
        userDefaults.set(date, forKey: "historyText")
        userDefaults.synchronize()
        
    }
    
    // パラメータのURLエンコード処理
    func encodeParameter(key: String, value: String) -> String? {
        // 値をエンコードする
        guard let escapedValue = value.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                // エンコード失敗
                return nil
        }
        // エンコードした値をkey=valueの形式で返却する
        return "\(key)=\(escapedValue)"
    }
    
    // URL作成処理
    func createRequestUrl(parameter: [String: String]) -> String {
        var parameterString = ""
        for key in parameter.keys {
            // 値の取り出し
            guard let value = parameter[key] else {
                // 値なし。次のfor文の処理を行う
                continue
            }
            // すでにパラメータが設定されていた場合
            if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                // パラメータ同士のセパレータである&を追加する
                parameterString += "&"
            }
            // 値をエンコードする
            guard let encodeValue = encodeParameter(key: key, value: value)
                else {
                    // エンコード失敗。次のfor文の処理を行う
                    continue
            }
            // エンコードした値をパラメータとして追加する
            parameterString += encodeValue
        }
        let requestUrl = entryUrl + "?" + parameterString
        return requestUrl
    }
    
    // リクエストを行う
    func request(requestUrl: String) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // URL生成失敗
            return
        }
        // リクエスト生成
        let request = URLRequest(url: url)
        // 商品検索APIをコールして商品検索を行う
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data:Data?,
            response:URLResponse?, error:Error?) in
            // 通信完了後の処理
            // エラーチェック
            guard error == nil else {
                // エラー表示
                let alert = UIAlertController(title: "エラー",
                                              message: error?.localizedDescription,
                                              preferredStyle: UIAlertControllerStyle.alert)
                // UIに関する処理はメインスレッド上で行う
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            // JSONで返却されたデータをパースして格納する
            guard let data = data else {
                // データなし
                return
            }
            
            do {
                // パース実施
                let resultSet = try JSONDecoder().decode(ItemSearchResultSet.self, from: data)
                // 商品のリストに追加
                self.itemDataArray.append(contentsOf: resultSet.resultSet.firstObject.result.items)
                
            } catch let error {
                print("## error: \(error)")
            }
            
            // テーブルの描画処理を実施
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 通信開始
        task.resume()
    }
    
    // MARK: - Table view data source
    // テーブルのセクション数を取得
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクション内の商品数を取得
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDataArray.count
    }
    
    
    
    //総合評価の値でソート
    //評価ソートボタンタップ時の処理
    @IBAction func tapReviewSortButton(_ sender: Any) {
        //データがないときに処理が落ちるため、セルがない時に何もしないことを記載
        if (itemDataArray.count == 0) {
            
        } else {
            //バブルソート
            for x in 0..<itemDataArray.count-1{
                for y in x+1..<itemDataArray.count{
                    if (itemDataArray[x].reviewInfo.review! < itemDataArray[y].reviewInfo.review!){
                        let  itemList = itemDataArray[x]
                        itemDataArray[x] = itemDataArray[y]
                        itemDataArray[y] = itemList
                    }
                }
            }
            //並び替えの反映
            tableView.reloadData()
        }
        
    }
    
    //価格の値でソート
    //価格ソートボタンタップ時の処理
    @IBAction func tapPriceSortButton(_ sender: Any) {
        
        
        //  var priceSortCount = 0
        
        //データがないときに処理が落ちるため、セルがない時に何もしないことを記載
        if (itemDataArray.count == 0) {
            
        } else {
            //if (priceSortCount % 2 == 0) {
            //バブルソート(昇順)
            for x in 0..<itemDataArray.count-1{
                for y in x+1..<itemDataArray.count{
                    if ( Int(itemDataArray[x].priceInfo.price!)!  > Int(itemDataArray[y].priceInfo.price!)!){
                        let  itemList = itemDataArray[x]
                        itemDataArray[x] = itemDataArray[y]
                        itemDataArray[y] = itemList
                    }
                }
            }
            // }// else {
            //バブルソート(降順)
            //   for x in 0..<itemDataArray.count-1{
            //       for y in x+1..<itemDataArray.count{
            //           if ( Int(itemDataArray[x].priceInfo.price!)!  < Int(itemDataArray[y].priceInfo.price!)!){
            //            let  itemList = itemDataArray[x]
            //               itemDataArray[x] = itemDataArray[y]
            //            itemDataArray[y] = itemList
            //        }
            //      }
            //    }
            //  }
            //並び替えの反映
            // priceSortCount = priceSortCount + 1
            tableView.reloadData()
        }
        
    }
    
    
    // MARK: - Table view data source
    // テーブルセルの取得処理
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "itemCell", for: indexPath) as? ItemTableViewCell else {
                return UITableViewCell()
        }
        let itemData = itemDataArray[indexPath.row]
        // 商品のタイトル設定
        cell.itemTitleLabel.text = itemData.name
        // 商品価格設定処理（日本通貨の形式で設定する）
        let number = NSNumber(integerLiteral: Int(itemData.priceInfo.price!)!)
        cell.itemPriceLabel.text = priceFormat.string(from: number)
        
        
        // 商品の総合評価を設定処理
        let rate = itemData.reviewInfo.review
        cell.itemRateLabel.text = ("評価\(rate!)／5")
        // 商品の評価件数を設定処理
        let reviewCount = itemData.reviewInfo.count
        cell.itemCountLabel.text = ("\(reviewCount!)件")
        
        
        // 商品のURL設定
        cell.itemUrl = itemData.url
        // 画像の設定処理
        // すでにセルに設定されている画像と同じかどうかチェックする
        // 画像がまだ設定されていない場合に処理を行う
        guard let itemImageUrl = itemData.imageInfo.medium else {
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
    
    @objc func longPress(sender: UILongPressGestureRecognizer){
        //押された位置でcellのpathを取得
        let point = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if sender.state == UIGestureRecognizerState.began{
            //セルが長押しされたときの処理
            let itemList = itemDataArray[(indexPath?.row)!]
            let myItemList = MyItemList()
            
            myItemList.name = itemList.name
            myItemList.url = itemList.url
            myItemList.medium = itemList.imageInfo.medium
            myItemList.price = itemList.priceInfo.price
            myItemList.review = itemList.reviewInfo.review
            myItemList.count = itemList.reviewInfo.count
            
            //お気に入り情報の保存処理
            let userDefaults = UserDefaults.standard
            // Date型にシリアライズする
            let date = NSKeyedArchiver.archivedData(withRootObject: myItemList)
            userDefaults.set(date, forKey: "myItemList")
            userDefaults.synchronize()
            
        }
        else{
            
        }
    }
    
    
    
    func fav(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "itemCell", for: indexPath) as? ItemTableViewCell else {
                return UITableViewCell()
        }
        let itemData = itemDataArray[indexPath.row]
        // 商品のタイトル設定
        cell.itemTitleLabel.text = itemData.name
        // 商品価格設定処理（日本通貨の形式で設定する）
        let number = NSNumber(integerLiteral: Int(itemData.priceInfo.price!)!)
        cell.itemPriceLabel.text = priceFormat.string(from: number)
        
        
        // 商品の総合評価を設定処理
        let rate = itemData.reviewInfo.review
        cell.itemRateLabel.text = ("評価\(rate!)／5")
        // 商品の評価件数を設定処理
        let reviewCount = itemData.reviewInfo.count
        cell.itemCountLabel.text = ("\(reviewCount!)件")
        
        
        // 商品のURL設定
        cell.itemUrl = itemData.url
        // 画像の設定処理
        // すでにセルに設定されている画像と同じかどうかチェックする
        // 画像がまだ設定されていない場合に処理を行う
        guard let itemImageUrl = itemData.imageInfo.medium else {
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
    
    // 履歴から戻るボタンをタップしたときの処理
    @IBAction func restart(_ segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    
}


class SearchHistory: NSObject,NSCoding {
    //検索履歴のタイトル
    var searchText: String?
    //コンストラクタ
    override init() {
        
    }
    // NSCodingプロトコルに宣言されているでシリアライズ処理。デコード処理
    required init?(coder aDecoder: NSCoder) {
        searchText = aDecoder.decodeObject(forKey: "searchText") as? String
    }
    
    // NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理
    func encode(with aCoder: NSCoder) {
        aCoder.encode(searchText, forKey: "searchText")
    }
    
    
}

// 独自クラスをシリアライズする際はには、NSObjectを継承し
// NSCodingプロトコルに準拠する必要がある
class MyItemList: NSObject,NSCoding {
    // 商品名
    var name: String?
    // 商品URL
    var url: String?
    // 商品画像URL
    var medium: String?
    // 価格
    var price: String?
    // 評価値
    var review: String?
    // 評価数
    var count: String?
    
    //コンストラクタ
    override init() {
        
    }
    // NSCodingプロトコルに宣言されているでシリアライズ処理。デコード処理
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        medium = aDecoder.decodeObject(forKey: "medium") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        review = aDecoder.decodeObject(forKey: "review") as? String
        count = aDecoder.decodeObject(forKey: "count") as? String
    }
    
    // NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(medium, forKey: "medium")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(review, forKey: "review")
        aCoder.encode(count, forKey: "count")
    }
    
    
}

