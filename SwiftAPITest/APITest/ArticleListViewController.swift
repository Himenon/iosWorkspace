//
//  ArticleListViewController.swift
//  APITest
//
//  Created by Himeno Kosei on 2016/02/26.
//  Copyright © 2016年 Himeno Kosei. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController, UITableViewDataSource {
    let table = UITableView() // プロパティにtableを追加
    var articles: [[String: String?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新着記事" // Navigation Barのタイトルを設定
        
        table.frame = view.frame // tableの大きさをviewの大きさに合わせる
        view.addSubview(table)  // viewにtableを乗せる
        table.dataSource = self
        getArticles()
    }
    
    func getArticles() {
        Alamofire.request(.GET, "https://qiita.com/api/v2/items")
            .responseJSON{ response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                
                json.forEach { (_, json) in
                    let article: [String: String?] = [
                        "title": json["title"].string,
                        "userId": json["user"]["id"].string
                    ]
                    self.articles.append(article)
                }
                //print(self.articles)
                self.table.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articles.count)
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row] // 行数番目の記事を取得
        cell.textLabel?.text = article["title"]! // 記事のタイトルをtextLabelにセット
        cell.detailTextLabel?.text = article["userId"]! // 投稿者のユーザーIDをdetailTextLabelにセット
        return cell
    }
    
    
}
