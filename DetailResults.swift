
import UIKit
import EasyToast

class DetailResults: UITabBarController, FBSDKSharingDelegate {
    
    let defaults = UserDefaults.standard
    let obj = SearchKeyword.detailObj
    
    @IBAction func showAction(_ sender: UIBarButtonItem) {
        let type: String = obj["type"]! // as a part of key of defaults
        let detailID: String = obj["id"]! // the key to the obj of the dictionary
        var savedFavorites = defaults.dictionary(forKey: type)
        var savedID = defaults.array(forKey: "\(type)id") as? [String]
        
        let menu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        
        let addFavor = UIAlertAction(title: "Add to favorites", style: .default, handler: {action in
            // codes for adding favorites
            
            if savedID == nil { // save ID
                let newArr: [String] = [detailID]
//                print(newArr) // test
                self.defaults.set(newArr, forKey: "\(type)id")
            }
            else {
                savedID!.append(detailID)
//                print(savedID!) // test
                self.defaults.set(savedID, forKey: "\(type)id")
            }
            
            if savedFavorites == nil { // save obj
                let newDic = [detailID: self.obj]
                self.defaults.set(newDic, forKey: type)
            }
            else {
                savedFavorites![detailID] = self.obj
                self.defaults.set(savedFavorites, forKey: type)
            }
            
            self.view.showToast("Added to favorites!", position: .bottom, popTime: 3.0, dismissOnTap: true)
        })
        
        let removeFavor = UIAlertAction(title: "Remove from favorites", style: .default, handler: {action in
            // codes for removing favorites
            
            savedID!.remove(at: (savedID!.index(of: detailID))!)
            self.defaults.set(savedID, forKey: "\(type)id")
            savedFavorites!.remove(at: (savedFavorites?.index(forKey: detailID))!)
            self.defaults.set(savedFavorites, forKey: type)
            
            self.view.showToast("Removed to favorites!", position: .bottom, popTime: 3.0, dismissOnTap: true)
        })
        
        let share = UIAlertAction(title: "share", style: .default, handler: {action in
            // codes for share FB
            
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentTitle = self.obj["name"]
            content.contentDescription = "FB Share for CSCI 571"
            content.imageURL = NSURL(string: self.obj["profile"]!)! as URL
            
            FBSDKShareDialog.show(from: self, with: content, delegate: self)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        // decide actions sheet actions
        if savedID == nil || !(savedID!.contains(detailID)) {
            menu.addAction(addFavor)
        }
        else {
            menu.addAction(removeFavor)
        }
        menu.addAction(share)
        menu.addAction(cancel)
        
        present(menu, animated: true, completion: nil)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        self.view.showToast("Shared!", position: .bottom, popTime: 3.0, dismissOnTap: true)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        self.view.showToast("Not Shared!", position: .bottom, popTime: 3.0, dismissOnTap: true)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        self.view.showToast("Share Failed!", position: .bottom, popTime: 3.0, dismissOnTap: true)
    }
}
