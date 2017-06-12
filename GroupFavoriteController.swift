
import UIKit

class GroupFavoriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupTable: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var errorMsg: UILabel!

    var savedID: [String]? = []
    var savedFavor: [String: Any]? = [:]
    var currPage: Int = 0
    var num_row: Int = 0
    var idArray = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        savedID = UserDefaults.standard.array(forKey: "groupid") as? [String]
        if savedID == nil {
            savedID = []
        }
        savedFavor = UserDefaults.standard.dictionary(forKey: "group")
        if savedFavor == nil {
            savedFavor = [:]
        }
//        print(savedID!) // test
        showResult()
    }
    
    func showResult() {
        let num: Int = savedID!.count - currPage * 10
        num_row = (num > 10) ? 10 : (num > 0) ? num : 0
        if num_row > 0 {
            let subArr: ArraySlice<String> = savedID![currPage * 10..<currPage * 10 + num_row]
            idArray = Array(subArr)
            self.groupTable.reloadData()
            self.groupTable.isHidden = false
            self.errorMsg.isHidden = true
            self.groupTable.tableFooterView = UIView()
        }
        else {
            idArray = []
            self.groupTable.isHidden = true
            self.errorMsg.isHidden = false
        }
            
        if num > 10 {
            nextButton.isEnabled = true
            nextButton.addTarget(self, action: #selector(self.seeNext), for: .touchUpInside)
        }
        else {
            nextButton.isEnabled = false
        }
        
        if currPage == 0 {
            prevButton.isEnabled = false
        }
        else {
            prevButton.isEnabled = true
            prevButton.addTarget(self, action: #selector(self.seePrev), for: .touchUpInside)
        }
    }
    
    func seeNext() {
        currPage += 1
        showResult()
    }
    
    func seePrev() {
        currPage -= 1
        showResult()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return num_row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupFavorite") as! SearchTableViewCell
        
        let id = idArray[indexPath.row]
        let obj = savedFavor![id] as! [String: String]
        //        print(obj) // test
        
        let imgURL = NSURL(string: obj["profile"]!)
        let img = NSData(contentsOf: (imgURL as URL?)!)
        cell.profilePhoto.image = UIImage(data: (img! as Data))
        cell.name.text = obj["name"]
        
        if self.savedID == nil || !(savedID!.contains(id)) {
            cell.favorite.image = UIImage(named: "empty")! // favorite
        }
        else {
            cell.favorite.image = UIImage(named: "filled")! // favorite
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SearchKeyword.detailObj = savedFavor![idArray[indexPath.row]] as! [String: String]
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "DetailResults") as! UITabBarController
        show(desController, sender: self)
    }
}
