import UIKit

class SettingsViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var pickedCarImageView: UIImageView!
    @IBOutlet weak var pickedBarrierImageView: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var speedTF: UITextField!
    @IBOutlet weak var selectCarLabel: UILabel!
    @IBOutlet weak var selectBarrierLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    
    // MARK: - var
    var carsArray: [Car] = []
    var barriersArray: [String] = []
    var indexCar = 0
    var indexBarrier = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    // MARK: - lifecycle funcs
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
        self.loadSettings()
        self.setupFonts()
    }
    
    // MARK: - IBActions
    @IBAction func buttonBack(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSave(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        let settings = Settings(self.userNameTF.text ?? "username",
                                self.speedTF.text ?? "5",
                                self.carsArray[self.indexCar],
                                self.barriersArray[self.indexBarrier],
                                AudioPlayerManager.shared.musicOff)
        UserDefaults.standard.set(encodable: settings, forKey: "settings")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressedLeftButtonPickCar(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        self.showCarLeft()
    }
    
    @IBAction func pressedRightButtonPickCar(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        self.showCarRight()
    }
    
    @IBAction func pressedLeftButtonPickBarrier(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        self.showBarrierLeft()
    }
    
    @IBAction func pressedRightButtonPickBarrier(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        self.showBarrierRight()
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if let isPlaying = AudioPlayerManager.shared.playerBackground?.isPlaying, isPlaying {
            AudioPlayerManager.shared.stopBackground(off: true)
        } else {
            AudioPlayerManager.shared.playSoundBack(musicOn: true)
        }
    }
}

// MARK: - extension
extension SettingsViewController {
    
    func loadData() {
        self.loadCars()
        self.loadBarriers()
    }
    
    func loadCars() {
        self.carsArray =
            [Car("yellowCar", "yellowBrokenCar"),
             Car("greenCar", "greenBrokenCar"),
             Car("pinkCar", "pinkBrokenCar"),
             Car("blueCar", "blueBrokenCar"),
             Car("brownCar", "brownBrokenCar"),
             Car("orangeCar", "orangeBrokenCar"),
             Car("pearCar", "pearBrokenCar"),
             Car("purpleCar", "purpleBrokenCar"),
             Car("violetCar", "violetBrokenCar"),
             Car("whiteCar", "whiteBrokenCar"),
             Car("aquamarineCar", "aquamarineBrokenCar"),
             Car("cherryCar", "cherryBrokenCar"),
             Car("lightBlueCar", "lightBlueBrokenCar"),
             Car("lightPinkCar", "lightPinkBrokenCar"),
             Car("redCar", "redBrokenCar")]
    }
    
    func loadBarriers() {
        self.barriersArray = ["boulder", "lumber", "boulder2", "oil", "bear", "squash"]
    }
    
    func loadSettings() {
        
        if let settings = UserDefaults.standard.value(Settings.self, forKey: "settings") {
            self.userNameTF.text = settings.user
            self.speedTF.text = settings.speed
            self.pickedCarImageView.image = UIImage(named: settings.car.imageNameCar)
            self.pickedBarrierImageView.image = UIImage(named: settings.barrier)
            if let index = carsArray.firstIndex(where: { $0.imageNameCar == settings.car.imageNameCar }) {
                self.indexCar = index
            }
            if let index = barriersArray.firstIndex(where: { $0 == settings.barrier }) {
                self.indexBarrier = index
            }
            self.switchToggle.setOn(!settings.musicOff, animated: true)
            AudioPlayerManager.shared.musicOff = settings.musicOff
        } else {
            let settings = Settings()
            self.userNameTF.text = settings.user
            self.speedTF.text = settings.speed
            self.pickedCarImageView.image = UIImage(named: settings.car.imageNameCar)
            self.pickedBarrierImageView.image = UIImage(named: settings.barrier)
        }
    }
    
    func showCarLeft() {
        self.setNext(index: &self.indexCar, by: carsArray)
        let newImageView = self.createCar(x: -self.pickedCarImageView.frame.size.width)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            newImageView.frame.origin.x += self.pickedCarImageView.frame.size.width
        }) { (_) in
            self.pickedCarImageView.image = newImageView.image
            newImageView.removeFromSuperview()
        }
    }
    
    func showCarRight() {
        self.setPrevious(index: &self.indexCar, by: carsArray)
        let newImageView = self.createCar(x: self.pickedCarImageView.frame.size.width)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            newImageView.frame.origin.x -= self.pickedCarImageView.frame.size.width
        }) { (_) in
            self.pickedCarImageView.image = newImageView.image
            newImageView.removeFromSuperview()
        }
    }
    
    func createCar(x: CGFloat) -> UIImageView {
        let newImageView = UIImageView()
        
        newImageView.frame = CGRect(x: x,
                                    y: 0,
                                    width: self.pickedCarImageView.frame.size.width,
                                    height: self.pickedCarImageView.frame.size.height)
        newImageView.contentMode = .scaleAspectFit
        newImageView.image = UIImage(named: self.carsArray[self.indexCar].imageNameCar)
        self.pickedCarImageView.addSubview(newImageView)
        
        return newImageView
    }
    
    func showBarrierLeft() {
        self.setNext(index: &self.indexBarrier, by: barriersArray)
        let newImageView = self.createBarrier(x: -self.pickedBarrierImageView.frame.size.width)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            newImageView.frame.origin.x += self.pickedBarrierImageView.frame.size.width
        }) { (_) in
            self.pickedBarrierImageView.image = newImageView.image
            newImageView.removeFromSuperview()
        }
    }
    
    func showBarrierRight() {
        self.setPrevious(index: &self.indexBarrier, by: barriersArray)
        let newImageView = self.createBarrier(x: self.pickedBarrierImageView.frame.size.width)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            newImageView.frame.origin.x -= self.pickedBarrierImageView.frame.size.width
        }) { (_) in
            self.pickedBarrierImageView.image = newImageView.image
            newImageView.removeFromSuperview()
        }
    }
    
    func createBarrier(x: CGFloat) -> UIImageView {
        let newImageView = UIImageView()
        
        newImageView.frame = CGRect(x: x,
                                    y: 0,
                                    width: self.pickedBarrierImageView.frame.size.width,
                                    height: self.pickedBarrierImageView.frame.size.height)
        newImageView.contentMode = .scaleAspectFit
        newImageView.image = UIImage(named: self.barriersArray[self.indexBarrier])
        self.pickedBarrierImageView.addSubview(newImageView)
        
        return newImageView
    }
    
    func setNext<T>(index: inout Int, by array: [T]) {
        if index == array.count - 1 {
            index = 0
        } else {
            index += 1
        }
    }
    
    func setPrevious<T>(index: inout Int, by array: [T]) {
        if index == 0 {
            index = array.count - 1
        } else {
            index -= 1
        }
    }
    
    func setupFonts() {

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let backButtonAttrString = NSAttributedString(string: self.backButton.titleLabel?.text ?? "", attributes: attributes)
        let settingsLabelAttrString = NSAttributedString(string: self.settingsLabel.text ?? "", attributes: attributes)
        let saveButtonAttrString = NSAttributedString(string: self.saveButton.titleLabel?.text ?? "", attributes: attributes)
        let selectCarLabelAttrString = NSAttributedString(string: self.selectCarLabel.text ?? "", attributes: attributes)
        let selectBarrierLabelAttrString = NSAttributedString(string: self.selectBarrierLabel.text ?? "", attributes: attributes)
        let nameLabelAttrString = NSAttributedString(string: self.nameLabel.text ?? "", attributes: attributes)
        let speedBarrierLabelAttrString = NSAttributedString(string: self.speedLabel.text ?? "", attributes: attributes)
        let userNameTFLabelAttrString = NSAttributedString(string: self.userNameTF.text ?? "", attributes: attributes)
        let speedTFLabelAttrString = NSAttributedString(string: self.speedTF.text ?? "", attributes: attributes)
        let musicLabelAttrString = NSAttributedString(string: self.musicLabel.text ?? "", attributes: attributes)
        
        self.backButton.setAttributedTitle(backButtonAttrString, for: .normal)
        self.backButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17)
        
        self.settingsLabel.attributedText = settingsLabelAttrString
        self.settingsLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.saveButton.setAttributedTitle(saveButtonAttrString, for: .normal)
        self.saveButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17)
        
        self.selectCarLabel.attributedText = selectCarLabelAttrString
        self.selectCarLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.selectBarrierLabel.attributedText = selectBarrierLabelAttrString
        self.selectBarrierLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.nameLabel.attributedText = nameLabelAttrString
        self.nameLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.speedLabel.attributedText = speedBarrierLabelAttrString
        self.speedLabel.font = UIFont(name: "Copperplate", size: 17)
        
        self.userNameTF.attributedText = userNameTFLabelAttrString
        self.userNameTF.font = UIFont(name: "Copperplate", size: 17)
        
        self.speedTF.attributedText = speedTFLabelAttrString
        self.speedTF.font = UIFont(name: "Copperplate", size: 17)
        
        self.musicLabel.attributedText = musicLabelAttrString
        self.musicLabel.font = UIFont(name: "Copperplate", size: 17)
    }
    
    func localization() {
        self.backButton.setTitle("Back".localized, for: .normal)
        self.saveButton.setTitle("Save".localized, for: .normal)
        self.settingsLabel.text = self.settingsLabel.text?.localized
        self.selectCarLabel.text = self.selectCarLabel.text?.localized
        self.selectBarrierLabel.text = self.selectBarrierLabel.text?.localized
        self.nameLabel.text = self.nameLabel.text?.localized
        self.speedLabel.text = self.speedLabel.text?.localized
        self.musicLabel.text = self.musicLabel.text?.localized
    }
    
}
