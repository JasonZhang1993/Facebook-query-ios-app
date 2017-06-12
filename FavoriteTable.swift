
import UIKit

class FavoriteTable: UITabBarController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
    }
    
    func sideMenu() {
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = UIScreen.main.bounds.size.width * 0.85 // the width of side menu
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
