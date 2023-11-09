

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var starIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var transferButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Public Method
extension FriendTableViewCell {
    func updateUI(friend: FriendModel) {
        self.starIcon.isHidden = friend.isTop == "0"
        self.nameLabel.text = friend.name
        self.transferButton.layer.borderColor = UIColor(red: 236/255, green: 0, blue: 140/255, alpha: 1).cgColor
    }
}
