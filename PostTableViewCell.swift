
import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
