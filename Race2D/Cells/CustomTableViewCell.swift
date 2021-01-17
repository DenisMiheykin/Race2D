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
        
        self.setupFonts()
    }
    
    func setBackground(color: UIColor) {
        self.userLabel.backgroundColor = color
        self.scoreLabel.backgroundColor = color
        self.dateLabel.backgroundColor = color
        self.speedLabel.backgroundColor = color
    }
    
    func setupFonts() {

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black]

        self.userLabel.attributedText = NSAttributedString(string: self.userLabel.text ?? "", attributes: attributes)
        self.userLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.scoreLabel.attributedText = NSAttributedString(string: self.scoreLabel.text ?? "", attributes: attributes)
        self.scoreLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.dateLabel.attributedText = NSAttributedString(string: self.dateLabel.text ?? "", attributes: attributes)
        self.dateLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.speedLabel.attributedText = NSAttributedString(string: self.speedLabel.text ?? "", attributes: attributes)
        self.speedLabel.font = UIFont(name: "Copperplate", size: 17)
        
    }

}

