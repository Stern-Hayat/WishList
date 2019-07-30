
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var wishText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
