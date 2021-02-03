////
////  ViewController.swift
////  QiitaApp
////
////  Created by 日高隼人 on 2021/02/02.
////
//
//import UIKit
//
//struct Qiita:Codable {
//
//    let title: String
//    let createdAt: String
//    let user: User
//
//    enum CodingKeys: String, CodingKey {
//        case title = "title"
//        case createdAt = "created_at"
//        case user = "user"
//    }
//}
//
//struct User: Codable {
//    let name: String
//    let profileImageUrl:String
//
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case profileImageUrl = "profile_url"
//    }
//}
//
//class ViewController: UIViewController {
//
//    private let cellId = "cellId"
//    private var qiitas = [Qiita]()
//
//    let tableView:UITableView = {
//        let tv = UITableView()
//        return tv
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(tableView)
//        tableView.frame.size = view.frame.size
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(QiitaTableViewCell.self, forCellReuseIdentifier:cellId)
//        navigationItem.title = "Qiitaの記事"
//
//        getQiitaApi()
//    }
//
//    private func getQiitaApi() {
//
//        guard let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=1") else { return }
//
//        var request = URLRequest(url:url)
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with:url) { (data, response, err) in
//            if let err = err {
//                print("情報の取得に失敗しました。；",err)
//                return
//            }
//
//            if let data = data {
//                do {
////                  let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    let qiita = try JSONDecoder().decode([Qiita].self, from: data)
//
//
//                    self.qiitas = qiita
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//
//                    print("json: ", qiita)
//
//                } catch (let err) {
//                    print("情報の取得に失敗しました。:",err)
//                }
//            }
//        }
//        task.resume()
//
//    }
//}
//
//extension ViewController : UITableViewDelegate,UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return qiitas.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QiitaTableViewCell
//
//        cell.qiita = qiitas[indexPath.row]
//
//
//        return cell
//    }
//}
//
//class QiitaTableViewCell: UITableViewCell {
//
//    var qiita: Qiita? {
//        didSet {
//            bodyTextLabel.text = qiita?.title
//            let url = URL(string: qiita?.user.profileImageUrl ?? "")
//            do {
//                let data = try Data(contentsOf: url!)
//                let image = UIImage(data: data)
//                userImageView.image = image
//            }catch let err {
//                print("Error : \(err.localizedDescription)")
//            }
//        }
//    }
//
//    let userImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.clipsToBounds = true
//        return iv
//    }()
//
//    let bodyTextLabel: UILabel = {
//        let label = UILabel()
//        label.text = "something in here"
//        label.font = .systemFont(ofSize: 15)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        addSubview(userImageView)
//        addSubview(bodyTextLabel)
//        [
//            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            userImageView.widthAnchor.constraint(equalToConstant: 50),
//            userImageView.heightAnchor.constraint(equalToConstant: 50),
//
//            bodyTextLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
//            bodyTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//        ].forEach{ $0.isActive = true }
//
//        userImageView.layer.cornerRadius = 50 / 2
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var articles: [[String: Any]] = [] //追加

    override func viewDidLoad() {
        super.viewDidLoad()

        let url: URL = URL(string: "http://qiita.com/api/v2/items")!
        let task: URLSessionTask  = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                let articles = json.map { (article) -> [String: Any] in
                    return article as! [String: Any]
                }
                self.articles = articles //追加
            }
            catch {
                print(error)
            }
        })
        task.resume()

        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count //変更
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let article = articles[indexPath.row] //追加
        let title = article["title"] as! String //追加
        cell.bindData(text: "title: \(title)") //変更
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section) index: \(indexPath.row)")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        return
    }
}
