
import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menu: UITableView!
    
    let labels: [String] = ["FB Search", "Home", "Favorites", "About me"]
    let icons: [UIImage] = [UIImage(named: "fb")!, UIImage(named: "home")!, UIImage(named: "favorite")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.menu.tableFooterView = UIView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1{
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell

        if indexPath.section == 0 {
            cell.menuIcon.image = icons[indexPath.row]
            cell.menuLabel.text! = labels[indexPath.row]
        }
        else if indexPath.section == 1 {
            cell.menuIcon.image = icons[indexPath.row + 1]
            cell.menuLabel.text! = labels[indexPath.row + 1]
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as! MenuTableViewCell
            cell.menuIcon = nil
            cell.menuLabel.text! = labels[indexPath.row + 3]

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "MENU"
        }
        else if section == 2 {
            return "OTHERS"
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController: SWRevealViewController = self.revealViewController()
        
        let cell: MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        if cell.menuLabel.text! == "Home" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        else if cell.menuLabel.text! == "Favorites" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "FavoriteTable") as! FavoriteTable
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        else if cell.menuLabel.text! == "About me" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)

        }
    }

}
