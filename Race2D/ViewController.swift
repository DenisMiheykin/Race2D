import UIKit
import AVFoundation

enum KeysUserDefaults: String {
    case raceResultsArray = "raceResultsArray"
    case settings = "settings"
}

class ViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startView: UIButton!
    @IBOutlet weak var settingsView: UIButton!
    @IBOutlet weak var scoreView: UIButton!
    
    // MARK: - var
    var settings = Settings()
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        //
        
        self.setupVariables()
        self.imageView.addParalaxEffect(amount: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    // MARK: - IBActions
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        fatalError()
    }
    
    @IBAction func buttonStart(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        guard let controller = UIStoryboard(name: "GameStoryboard", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func buttonSettings(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        guard let controller = UIStoryboard(name: "SettingsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func buttonScore(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        guard let controller = UIStoryboard(name: "ScoreStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - flow funcs
    private func setup() {
        self.setupShadowForButtons()
        self.setupFonts()
        if !(AudioPlayerManager.shared.playerBackground?.isPlaying ?? false)  {
            AudioPlayerManager.shared.playSoundBack()
        }
    }
    
    func setupVariables() {
        self.loadSettings()
        
        AudioPlayerManager.shared.musicOff = settings.musicOff
    }
    
    func loadSettings() {
        if let settings = UserDefaults.standard.value(Settings.self, forKey: KeysUserDefaults.settings.rawValue) {
            self.settings = settings
        }
    }
    
    func setupShadowForButtons() {
        self.startView.roundCorners()
        self.startView.dropshadow()
        self.settingsView.roundCorners()
        self.settingsView.dropshadow()
        self.scoreView.roundCorners()
        self.scoreView.dropshadow()
    }
    
    func setupFonts() {

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue,
                                                         NSAttributedString.Key.underlineColor: UIColor.gray]
        
        let startAttrString = NSAttributedString(string: self.startView.titleLabel?.text ?? "", attributes: attributes)
        let settingsAttrString = NSAttributedString(string: self.settingsView.titleLabel?.text ?? "", attributes: attributes)
        let scoreAttrString = NSAttributedString(string: self.scoreView.titleLabel?.text ?? "", attributes: attributes)
        
        self.startView.setAttributedTitle(startAttrString, for: .normal)
        self.startView.titleLabel?.font = UIFont(name: "Copperplate", size: 50)
        self.settingsView.setAttributedTitle(settingsAttrString, for: .normal)
        self.settingsView.titleLabel?.font = UIFont(name: "Copperplate", size: 50)
        self.scoreView.setAttributedTitle(scoreAttrString, for: .normal)
        self.scoreView.titleLabel?.font = UIFont(name: "Copperplate", size: 50)
        
    }
    
}
