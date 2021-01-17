import UIKit

class ScoreViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - var
    var raceResults: [RaceResult] = []
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
        self.setupFonts()
    }
    
    // MARK: - IBActions
    @IBAction func buttonBack(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        UserDefaults.standard.set(encodable: raceResults, forKey: KeysUserDefaults.raceResultsArray.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - extension
extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.raceResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row % 2 == 0 {
            cell.setBackground(color: .lightGray)
        } else {
            cell.setBackground(color: .white)
        }
        
        cell.configure(raceResult: raceResults[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.raceResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    func loadScores() {
        if let raceResults = UserDefaults.standard.value([RaceResult].self, forKey: KeysUserDefaults.raceResultsArray.rawValue) {
            self.raceResults = raceResults
        }
    }
    
    func setupFonts() {

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let backButtonAttrString = NSAttributedString(string: self.backButton.titleLabel?.text ?? "", attributes: attributes)
        let scoreLabelAttrString = NSAttributedString(string: self.scoreLabel.text ?? "", attributes: attributes)
        
        self.backButton.setAttributedTitle(backButtonAttrString, for: .normal)
        self.backButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17)
        
        self.scoreLabel.attributedText = scoreLabelAttrString
        self.scoreLabel.font = UIFont(name: "Copperplate", size: 17)
        
    }
    
    func localization() {
        self.backButton.setTitle("Back".localized, for: .normal)
        self.scoreLabel.text = self.scoreLabel.text?.localized
    }
    
}
