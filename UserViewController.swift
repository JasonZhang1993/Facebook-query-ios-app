
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var userTable: UITableView!

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var errorMsg: UILabel!
    
    var q = String()
    var idArray = [String]()
    var photoURL = [String]()
    var nameArray = [String]()
    var next_page = String()
    var prev_page = String()
    var searchURL = String()
    
    var savedID: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        prevButton.isEnabled = false
        SwiftSpinner.show("Loading data...")
        q = SearchKeyword.keyword
        savedID = UserDefaults.standard.array(forKey: "userid") as? [String] // only read userDefault
        search(for: "q")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedID = UserDefaults.standard.array(forKey: "userid") as? [String]
        self.userTable.reloadData()
        self.userTable.tableFooterView = UIView()
    }
    
    func search(for keyword: String) {
//        print(SearchKeyword.keyword) // testing
        if keyword == "q" {
//            searchURL = "http://cs-server.usc.edu:11549/hw9/hw8.php?q=\(q)&type=user"
            searchURL = "http://myapp2017-env.us-west-2.elasticbeanstalk.com/hw9/hw9.php?q=\(q)&type=user"
        }
        else if keyword == "next"
        {
            searchURL = next_page
        }
        else if keyword == "prev" {
            searchURL = prev_page
        }
        else {
            searchURL = ""
        }
        Alamofire.request(searchURL).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["data"].isEmpty || json["data"].count == 0 {
                    self.showError(json)
                }
                else {
                    self.showResults(json)
                }
            case .failure(let error):
                print(error)
                self.showError(JSON(error))
            }
        })
    }
    
    func showError(_ json: JSON) {
        self.userTable.isHidden = true
        self.errorMsg.isHidden = false
        self.setButton(json)
        SwiftSpinner.hide()
    }
    
    func showResults(_ json: JSON) {
        idArray = []
        photoURL = []
        nameArray = []
        next_page = ""
        prev_page = ""
        for (_, value) in json["data"] {
            idArray.append(value["id"].stringValue)
            photoURL.append(value["picture"]["data"]["url"].stringValue)
            nameArray.append(value["name"].stringValue)
        }
//        print(nameArray) // testing
        
        self.setButton(json)
        self.userTable.reloadData()
        self.userTable.tableFooterView = UIView()
        self.userTable.isHidden = false
        self.errorMsg.isHidden = true
        SwiftSpinner.hide()
    }
    
    func setButton(_ json: JSON) {
        next_page = json["paging"]["next"].stringValue
        prev_page = json["paging"]["previous"].stringValue
        
        if self.next_page.isEmpty {
            nextButton.isEnabled = false
        }
        else {
            nextButton.isEnabled = true
            nextButton.addTarget(self, action: #selector(self.seeNext), for: .touchUpInside)
        }
        if self.prev_page.isEmpty {
            prevButton.isEnabled = false
        }
        else {
            prevButton.isEnabled = true
            prevButton.addTarget(self, action: #selector(self.seePrev), for: .touchUpInside)
        }
    }
    
    func seeNext() {
        print("paging next...") // testing
        search(for: "next")
    }
    
    func seePrev() {
        print("paging previous...") // testing
        search(for: "prev")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("\(idArray.count)") // testing
        return idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! SearchTableViewCell
        let imgURL = NSURL(string: photoURL[indexPath.row])
        let img = NSData(contentsOf: (imgURL as URL?)!)
        cell.profilePhoto.image = UIImage(data: (img! as Data))
        cell.name.text = nameArray[indexPath.row]
        if self.savedID == nil || !(savedID!.contains(idArray[indexPath.row])) {
            cell.favorite.image = UIImage(named: "empty")! // favorite
        }
        else {
            cell.favorite.image = UIImage(named: "filled")! // favorite
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // assign singleton
        let cell: SearchTableViewCell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        SearchKeyword.detailObj = [
            "id": idArray[indexPath.row],
            "name": cell.name.text!,
            "profile": photoURL[indexPath.row],
            "type": "user"
        ]
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "DetailResults") as! UITabBarController
        show(desController, sender: self)
    }
}
