
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postTable: UITableView!
    @IBOutlet weak var errorMsg: UILabel!
    
    
    var obj: [String: String] = [:]
    var postArray = [String]()
    var timeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTable.isHidden = true
        self.errorMsg.isHidden = true
        SwiftSpinner.show("Loading data...")
        obj = SearchKeyword.detailObj
        search()
    }
    
    func search() {
        let detailID = obj["id"]!
//        print(detailID) // testing
//        let searchURL: String = "http://cs-server.usc.edu:11549/hw9/hw8.php?id=\(detailID)&type=post"
        let searchURL = "http://myapp2017-env.us-west-2.elasticbeanstalk.com/hw9/hw9.php?id=\(detailID)&type=post"
        Alamofire.request(searchURL).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if !json["posts"].isEmpty { // no "posts" ?
                    self.showResults(json["posts"])
                }
                else {
                    self.showError()
                }
            case .failure(let error):
                print(error)
                self.showError()
            }
        })
    }
    
    func showError() {
        self.postTable.isHidden = true
        self.errorMsg.isHidden = false
        SwiftSpinner.hide()
    }
    
    func showResults(_ json: JSON) {
        postArray = []
        timeArray = []
        if json["data"].count == 0 {
            self.showError()
        }
        for (_ , value) in json["data"] {
            if !value["created_time"].stringValue.isEmpty {
                let dateStr = value["created_time"].stringValue
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = formatter.date(from: dateStr)
                formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                timeArray.append(formatter.string(from: date!))
            }
            else {
                timeArray.append("Unknown")
            }
            if !value["message"].stringValue.isEmpty {
                postArray.append(value["message"].stringValue)
            }
            else if !value["story"].stringValue.isEmpty {
                postArray.append(value["story"].stringValue)
            }
            else {
                postArray.append("")
            }
        }
//        print(timeArray) // testing
        
        self.postTable.reloadData()
        self.postTable.estimatedRowHeight = 74
        self.postTable.rowHeight = UITableViewAutomaticDimension
        self.postTable.tableFooterView = UIView()
        self.postTable.isHidden = false
        self.errorMsg.isHidden = true
        SwiftSpinner.hide()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let imgURL = NSURL(string: obj["profile"]!)
        let img = NSData(contentsOf: (imgURL as URL?)!)
        cell.profilePhoto.image = UIImage(data: img! as Data)
        cell.message.text = postArray[indexPath.row]
        var frame = cell.message.frame
        frame.size.height = cell.message.contentSize.height
        cell.message.frame = frame
        cell.time.text = timeArray[indexPath.row]
        
        return cell
    }
}
