import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - outlets
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    // MARK: - lifecycle funcs
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - flow funcs
    func configure(raceResult: RaceResult) {
        self.userLabel.text = raceResult.user
        self.scoreLabel.text = "\("Result".localized): \(raceResult.score)"
        self.dateLabel.text = raceResult.date
        self.speedLabel.text = "\("Speed".localized): \(raceResult.speed)"
    }
    
    func setBackground(color: UIColor) {
        self.userLabel.backgroundColor = color
        self.scoreLabel.backgroundColor = color
        self.dateLabel.backgroundColor = color
        self.speedLabel.backgroundColor = color
    }

}

// MARK: - extension
