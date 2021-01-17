import UIKit
import CoreMotion

class GameViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var leftCurbView: UIView!
    @IBOutlet weak var rightCurbView: UIView!
    @IBOutlet weak var roadView: UIView!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var race2DLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // MARK: - let
    private let cmMotionManager = CMMotionManager()
    
    // MARK: - var
    var withDurationAnimations = TimeInterval.init()
    var step: CGFloat = 30
    var decorArray: [Decor] = []
    var barrierArray: [String] = []
    var gameOver = false
    var settings = Settings()
    var checkCollision = true
    var jumpHeight: CGFloat = 50
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        self.setupVariables()
        
        self.startAccelerometerUpdates()
        self.startDeviceMotionUpdates()
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
        self.setup()
        self.loadScene()
        self.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cmMotionManager.stopAccelerometerUpdates()
        cmMotionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - IBActions
    @IBAction func buttonBack(_ sender: UIButton) {
        AudioPlayerManager.shared.stopBackground()
        AudioPlayerManager.shared.playClick()
        self.stopGame()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leftPressedButton(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        self.moveLeft()
    }
    
    @IBAction func rightPressedButton(_ sender: UIButton) {
        AudioPlayerManager.shared.playClick()
        self.moveRight()
    }
    
    // MARK: - flow funcs
    private func setup() {
        if AudioPlayerManager.shared.canPlay() {
            AudioPlayerManager.shared.playDrive()
        }
        self.setupFonts()
    }
    
    func startAccelerometerUpdates() {
        if cmMotionManager.isAccelerometerAvailable {
            cmMotionManager.accelerometerUpdateInterval = 0.1
            cmMotionManager.startAccelerometerUpdates(to: .main) { [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    self?.moveCar(delta: CGFloat(acceleration.x))
                }
            }
        }
    }

    func startDeviceMotionUpdates() {
        if cmMotionManager.isDeviceMotionAvailable {
            cmMotionManager.deviceMotionUpdateInterval = 0.1
            cmMotionManager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let rate = data?.rotationRate {
                    if rate.x > 1.5 {
                        self?.jumpCar()
                    }
                }
            }
        }
    }
}

// MARK: - extension
private extension GameViewController {
    
    func setupVariables() {
        if let settings = UserDefaults.standard.value(Settings.self, forKey: KeysUserDefaults.settings.rawValue) {
            self.settings = settings
        }
        
        self.decorArray = loadDecorArray()
        self.barrierArray = loadBarrierArray()
        
        if let speed = TimeInterval(self.settings.speed) {
            self.withDurationAnimations = speed
        }
        AudioPlayerManager.shared.musicOff = settings.musicOff
    }
    
    func loadDecorArray() -> [Decor] {
        return
            [Decor("tree", false),
             Decor("bush", true),
             Decor("bush2", true),
             Decor("fir", false),
             Decor("house", false),
             Decor("leaf", true),
             Decor("puddle", true),
             Decor("stone", true),
             Decor("stone2", true)]
    }
    
    func loadBarrierArray() -> [String] {
        return [settings.barrier]
    }
    
    func loadScene() {
        self.loadCar()
    }
    
    func loadCar() {
        self.carImageView.frame.origin.x = 30
        self.carImageView.frame.origin.y = self.roadView.frame.height - self.carImageView.frame.height - 30
        self.carImageView.layer.zPosition = 1
        self.carImageView.image = UIImage(named: settings.car.imageNameCar)
    }
    
    func start() {
        self.firstStart()
        self.startRoad()
        self.startDecorations()
        self.startCollisionСheckTimer()
        self.startBarrierTimer()
    }
    
    func firstStart() {
        let road = UIImageView()
        road.frame = self.roadView.bounds
        road.image = UIImage(named: "road")
        road.contentMode = .scaleToFill
        self.roadView.addSubview(road)
        
        let finish = self.roadView.frame.size.height * 2
        UIView.animate(withDuration: self.withDurationAnimations, delay: 0, options: .curveLinear, animations: {
            road.frame.origin.y += finish
        }) { (_) in
            road.removeFromSuperview()
        }
    }
    
    func startRoad() {
        let timer = Timer.scheduledTimer(withTimeInterval: self.withDurationAnimations / 2, repeats: true) { (timer) in
            if self.gameOver {
                timer.invalidate()
                self.exitGame()
                return
            }
            
            let road = UIImageView()
            road.frame = self.roadView.bounds
            road.frame.origin.y = -road.frame.size.height
            road.image = UIImage(named: "road")
            road.contentMode = .scaleToFill
            self.roadView.addSubview(road)
            
            let finish = self.roadView.frame.size.height * 2
            UIView.animate(withDuration: self.withDurationAnimations, delay: 0, options: .curveLinear, animations: {
                road.frame.origin.y += finish
            }) { (_) in
                road.removeFromSuperview()
            }
        }
        timer.fire()
    }
    
    func startDecorations() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.gameOver {
                timer.invalidate()
                self.exitGame()
                return
            }
            
            self.drawDecorationsLeftCurb()
            self.drawDecorationsRightCurb()
        }
        timer.fire()
    }
    
    func startCollisionСheckTimer() {
        let сollisionСheckTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (сollisionСheckTimer) in
            if self.gameOver {
                return
            }
            
            if self.carCollision() {
                self.gameOver = true
                сollisionСheckTimer.invalidate()
                self.carCrash()
                self.stopGame()
                self.exitGame()
                return
            }
        }
    }
    
    func startBarrierTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if self.gameOver {
                timer.invalidate()
                return
            }
            self.drawBarrier()
        }
    }
    
    func exitGame() {
        let y = self.roadView.frame.size.height / 2 - 10
        let gameOverLable = UILabel(frame: CGRect(x: 0, y: y, width: self.roadView.frame.size.width, height: 20))
        gameOverLable.text = "Game Over".localized
        gameOverLable.textAlignment = .center
        self.roadView.addSubview(gameOverLable)
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black]
        gameOverLable.attributedText = NSAttributedString(string: gameOverLable.text ?? "", attributes: attributes)
        gameOverLable.font = UIFont(name: "Copperplate", size: 20)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func moveRoad() {
        let road = UIImageView()
        road.frame = self.roadView.bounds
        road.frame.origin.y = -road.frame.size.height
        road.image = UIImage(named: "road")
        road.contentMode = .scaleToFill
        self.roadView.addSubview(road)
        
        let finish = self.roadView.frame.size.height * 3
        UIView.animate(withDuration: self.withDurationAnimations, delay: 0, options: .curveLinear, animations: {
            road.frame.origin.y += finish
        }) { (_) in
            road.removeFromSuperview()
        }
    }
    
    func drawDecorationsLeftCurb() {
        let decorView = self.createDecorations(curbView: self.leftCurbView)
        UIView.animate(withDuration: self.withDurationAnimations, delay: 0, options: .curveLinear, animations: {
            decorView.frame.origin.y += self.leftCurbView.frame.size.height * 2
        }) { (_) in
            decorView.removeFromSuperview()
        }
    }
    
    func drawDecorationsRightCurb() {
        let decorView = self.createDecorations(curbView: self.rightCurbView)
        UIView.animate(withDuration: self.withDurationAnimations, delay: 0, options: .curveLinear, animations: {
            decorView.frame.origin.y += self.rightCurbView.frame.size.height * 2
        }) { (_) in
            decorView.removeFromSuperview()
        }
    }
    
    func createDecorations(curbView: UIView) -> UIView {
        let side = self.leftCurbView.frame.size.width
        
        let decorImageView = UIImageView()
        let decor = getRandomDecor()
        decorImageView.image = UIImage(named: decor.imageName)
        if decor.isRandomSize {
            let origin = getOriginDecor(decor)
            let sideDecor = getSizeDecor(origin.x, origin.y)
            decorImageView.frame = CGRect(x: origin.x, y: origin.y, width: sideDecor, height: sideDecor)
        } else {
            decorImageView.frame = CGRect(x: 0, y: 0, width: side, height: side)
        }
        
        let decorView = UIView(frame: CGRect(x: 0, y: -side, width: side, height: side))
        decorView.addSubview(decorImageView)
        
        curbView.addSubview(decorView)
        
        return decorView
    }
    
    func drawBarrier() {
        let barrierView = self.createBarrier()
        
        self.startScoring(barrierView)
        
        UIView.animate(withDuration: self.withDurationAnimations, delay: 0, options: .curveLinear, animations: {
            barrierView.frame.origin.y += self.roadView.frame.size.height * 2
        }) { (_) in
            barrierView.removeFromSuperview()
        }
    }
    
    func createBarrier() -> UIView {
        let sideView = self.leftCurbView.frame.size.width
        
        let barrierImageView = UIImageView()
        let barrier = getRandomBarrier()
        barrierImageView.image = UIImage(named: barrier)
        barrierImageView.frame = CGRect(x: 0, y: 0 , width: sideView, height: sideView)
        
        let xMax = self.roadView.frame.width - sideView
        let barrierView = UIView(frame: CGRect(x: CGFloat.random(in: 0...xMax), y: -sideView, width: sideView, height: sideView))
        barrierView.tag = 1
        barrierView.addSubview(barrierImageView)
        self.roadView.addSubview(barrierView)
        
        return barrierView
    }
    
    func startScoring(_ barrier: UIView) {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            if self.gameOver {
                timer.invalidate()
                return
            }
            
            if let currentPositionBarrier = barrier.layer.presentation(), let currentPositionCar = self.carImageView.layer.presentation() {
                if currentPositionBarrier.frame.origin.y >= currentPositionCar.frame.origin.y + self.carImageView.frame.size.height {
                    timer.invalidate()
                    self.scoreLabel.text = "\(Int(self.scoreLabel.text!)! + 1)"
                }
            }
        }
    }
    
    func getRandomDecor() -> Decor {
        return self.decorArray[Int.random(in: 0..<self.decorArray.count)]
    }
    
    func getRandomBarrier() -> String {
        return self.barrierArray[Int.random(in: 0..<self.barrierArray.count)]
    }
    
    func getOriginDecor(_ decor: Decor) -> (x: CGFloat, y: CGFloat) {
        let halfWidthCurb = self.leftCurbView.frame.size.width / 2
        let x = CGFloat.random(in: 0..<halfWidthCurb)
        let y = CGFloat.random(in: 0..<halfWidthCurb)
        return (x, y)
    }
    
    func getSizeDecor(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
        let halfWidthCurb = self.leftCurbView.frame.size.width / 2
        let maxValue = max(x, y)
        
        return halfWidthCurb + CGFloat.random(in: 0..<halfWidthCurb - maxValue)
    }
    
    func moveLeft() {
        if self.gameOver {
            return
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.carImageView.frame.origin.x -= self.step
        }) { (_) in
            if self.exitLeft() {
                self.carCrash()
                self.stopGame()
            }
        }
    }
    
    func moveRight() {
        if self.gameOver {
            return
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.carImageView.frame.origin.x += self.step
        }) { (_) in
            if self.exitRight() {
                self.carCrash()
                self.stopGame()
            }
        }
    }
    
    func moveCar(delta: CGFloat) {
        if self.gameOver {
            return
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.carImageView.frame.origin.x += self.step * delta
        }) { (_) in
            if self.exitRight() || self.exitLeft() {
                self.carCrash()
                self.stopGame()
            }
        }
    }
    
    func jumpCar() {
        if self.gameOver {
            return
        }
        self.carUp()
    }
    
    func carUp() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.checkCollision = false
            self.carImageView.frame.size.width += self.jumpHeight
            self.carImageView.frame.size.height += self.jumpHeight
        }) { (_) in
            self.carDown()
        }
    }
    
    func carDown() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.carImageView.frame.size.width -= self.jumpHeight
            self.carImageView.frame.size.height -= self.jumpHeight
        }) { (_) in
            self.checkCollision = true
        }
    }
    
    func exitLeft() -> Bool {
        return self.carImageView.frame.origin.x < 0
    }
    
    func exitRight() -> Bool {
        return self.carImageView.frame.origin.x > self.roadView.frame.size.width - self.carImageView.frame.size.width
    }
    
    func carCollision() -> Bool {
        
        if !self.checkCollision {
            return false
        }
        
        let array = self.roadView.subviews
            .filter({
                if let currentPosition = $0.layer.presentation() {
                    return $0.tag == 1 && currentPosition.frame.intersects(self.carImageView.frame)
                }
                return false
            })
        
        return array.count > 0
    }
    
    func carCrash() {
        AudioPlayerManager.shared.stopBackground()
        AudioPlayerManager.shared.playCrash()
        self.carImageView.image = UIImage(named: settings.car.imageNameBrokenCar)
    }
    
    func stopGame() {
        self.gameOver = true
        self.nukeAllAnimations()
        self.saveResults()
    }
    
    func nukeAllAnimations() {
        self.leftCurbView.subviews.forEach({$0.layer.removeAllAnimations()})
        self.leftCurbView.layer.removeAllAnimations()
        self.leftCurbView.layoutIfNeeded()
        
        self.rightCurbView.subviews.forEach({$0.layer.removeAllAnimations()})
        self.rightCurbView.layer.removeAllAnimations()
        self.rightCurbView.layoutIfNeeded()
        
        self.roadView.subviews.forEach({$0.layer.removeAllAnimations()})
        self.roadView.layer.removeAllAnimations()
        self.roadView.layoutIfNeeded()
    }
    
    func saveResults() {
        let key = KeysUserDefaults.raceResultsArray.rawValue
        if var raceResults = UserDefaults.standard.value([RaceResult].self, forKey: key) {
            let currentResult = RaceResult(self.settings.user,
                                           self.settings.speed,
                                           Int(self.scoreLabel.text ?? "0") ?? 0,
                                           Date.init().string(format: "dd.MM.yy HH:mm:ss"))
            raceResults.insert(currentResult, at: 0)
            UserDefaults.standard.set(encodable: raceResults, forKey: key)
        } else {
            var raceResults: [RaceResult] = []
            let currentResult = RaceResult(self.settings.user,
                                           self.settings.speed,
                                           Int(self.scoreLabel.text ?? "0") ?? 0,
                                           Date.init().string(format: "dd.MM.yy HH:mm:ss"))
            raceResults.append(currentResult)
            UserDefaults.standard.set(encodable: raceResults, forKey: key)
        }
    }
    
    func setupFonts() {

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let backButtonAttrString = NSAttributedString(string: self.backButton.titleLabel?.text ?? "", attributes: attributes)
        let leftButtonAttrString = NSAttributedString(string: self.leftButton.titleLabel?.text ?? "", attributes: attributes)
        let rightButtonAttrString = NSAttributedString(string: self.rightButton.titleLabel?.text ?? "", attributes: attributes)
        let race2dLabelAttrString = NSAttributedString(string: self.race2DLabel.text ?? "", attributes: attributes)
        let scoreLabelAttrString = NSAttributedString(string: self.scoreLabel.text ?? "", attributes: attributes)
        
        self.backButton.setAttributedTitle(backButtonAttrString, for: .normal)
        self.backButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17)
        self.leftButton.setAttributedTitle(leftButtonAttrString, for: .normal)
        self.leftButton.titleLabel?.font = UIFont(name: "Copperplate", size: 30)
        self.rightButton.setAttributedTitle(rightButtonAttrString, for: .normal)
        self.rightButton.titleLabel?.font = UIFont(name: "Copperplate", size: 30)
        self.race2DLabel.attributedText = race2dLabelAttrString
        self.race2DLabel.font = UIFont(name: "Copperplate", size: 17)
        self.scoreLabel.attributedText = scoreLabelAttrString
        self.scoreLabel.font = UIFont(name: "Copperplate", size: 17)
        
    }
    
    func localization() {
        self.backButton.setTitle("Back".localized, for: .normal)
        self.leftButton.setTitle("LEFT".localized, for: .normal)
        self.rightButton.setTitle("RIGHT".localized, for: .normal)
        self.race2DLabel.text = self.race2DLabel.text?.localized
    }
}
