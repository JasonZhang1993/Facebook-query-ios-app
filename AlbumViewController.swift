
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AlbumTable: UITableView!
    @IBOutlet weak var errorMsg: UILabel!

    var selectedIndexPath: IndexPath?
    
    var obj: [String: String] = [:]
    var nameArray = [String]()
    var idArray = [String]() // if high-res is needed
    var picURL = [[String]]()
    var numOfPhotos = [Int]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.AlbumTable.isHidden = true
        self.errorMsg.isHidden = true
        SwiftSpinner.show("Loading data...")
        obj = SearchKeyword.detailObj
        search()
    }
    
    func search() {
        let detailID = obj["id"]!
//        let searchURL: String = "http://cs-server.usc.edu:11549/hw9/hw8.php?id=\(detailID)&type=album"
        let searchURL = "http://myapp2017-env.us-west-2.elasticbeanstalk.com/hw9/hw9.php?id=\(detailID)&type=album"
        Alamofire.request(searchURL).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if !json["albums"].isEmpty { // no "albums" ?
                    self.showResults(json["albums"])
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
        self.AlbumTable.isHidden = true
        self.errorMsg.isHidden = false
        SwiftSpinner.hide()
    }
    
    func showResults(_ json: JSON) {
        idArray = []
        nameArray = []
        picURL = []
        numOfPhotos = []
        if json["data"].count == 0 {
            self.showError()
        }
        for (_ , value) in json["data"] {
            idArray.append(value["id"].stringValue)
            nameArray.append(value["name"].stringValue)
            var pics: [String] = []
            if !value["photos"]["data"][0].isEmpty {
                pics.append(value["photos"]["data"][0]["picture"].stringValue)
                if !value["photos"]["data"][1].isEmpty {
                    pics.append(value["photos"]["data"][1]["picture"].stringValue)
                }
            }
            self.picURL.append(pics) // number of photos ? 2D array
            self.numOfPhotos.append(value["photos"]["data"].count)
        }
//        print(nameArray) // testing
        
        self.AlbumTable.reloadData()
        self.AlbumTable.tableFooterView = UIView()
        self.AlbumTable.isHidden = false
        self.errorMsg.isHidden = true
        SwiftSpinner.hide()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell") as! AlbumTableViewCell
        cell.albumTitle.text = nameArray[indexPath.row]
        for (index, photoURL) in picURL[indexPath.row].enumerated() {
//            print("Row \(indexPath.row) photo \(index): \(photoURL)") // testing
            let imgURL = NSURL(string: photoURL)
            let img = NSData(contentsOf: (imgURL as URL?)!)
            if index == 0 {
                cell.photo1.image = UIImage(data: (img! as Data))
            }
            else {
                cell.photo2.image = UIImage(data: (img! as Data))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // no photos ? not clockable or remove extra cells?
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath { // close cell
            selectedIndexPath = nil
        }
        else { // open cell
            selectedIndexPath = indexPath
        }
        var indexPaths: Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths.append(previous)
        }
        if let current = selectedIndexPath {
            indexPaths.append(current)
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumTableViewCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumTableViewCell).ignoreFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            if numOfPhotos[indexPath.row] == 0 {
                return AlbumTableViewCell.defaultHeight
            }
            else if numOfPhotos[indexPath.row] == 1 {
                return AlbumTableViewCell.onePhotoHeight
            }
            else {
                return AlbumTableViewCell.expandedHeight
            }
        }
        else {
            return AlbumTableViewCell.defaultHeight
        } 
    }
    
}
