
import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumTitle: UILabel!
    
    @IBOutlet weak var photo1: UIImageView!

    @IBOutlet weak var photo2: UIImageView!
    
    class var expandedHeight: CGFloat {get {return 425}}
    class var onePhotoHeight: CGFloat {get {return 240}}
    class var defaultHeight: CGFloat {get {return 44}}
    var isObserved = false
    
    func checkHeight() {
        photo2.isHidden = (frame.size.height < AlbumTableViewCell.expandedHeight)
        photo1.isHidden = (frame.size.height < AlbumTableViewCell.onePhotoHeight)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func watchFrameChanges() {
        if !isObserved {
            isObserved = true
//            print("add observer")
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            checkHeight()
        }
    }
    
    func ignoreFrameChanges() {
        if isObserved {
//            print("remove observer")
            removeObserver(self, forKeyPath: "frame")
            isObserved = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    deinit {
        ignoreFrameChanges()
    }

}
