import UIKit

class Settings: Codable {
    
    var user: String
    var speed: String
    var car: Car
    var barrier: String
    var musicOff: Bool
    
    init() {
        self.user = "username"
        self.speed = "5"
        self.car = Car("yellowCar", "yellowBrokenCar")
        self.barrier = "boulder"
        self.musicOff = false
    }
    
    init(_ user: String, _ speed: String, _ car: Car, _ barrier: String, _ musicOff: Bool) {
        self.user = user
        self.speed = speed
        self.car = car
        self.barrier = barrier
        self.musicOff = musicOff
    }
    
    public enum CodingKeys: String, CodingKey {
        case user, speed, car, barrier, musicOff
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.user = try container.decode(String.self, forKey: .user)
        self.speed = try container.decode(String.self, forKey: .speed)
        self.car = try container.decode(Car.self, forKey: .car)
        self.barrier = try container.decode(String.self, forKey: .barrier)
        self.musicOff = try container.decode(Bool.self, forKey: .musicOff)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.user, forKey: .user)
        try container.encode(self.speed, forKey: .speed)
        try container.encode(self.car, forKey: .car)
        try container.encode(self.barrier, forKey: .barrier)
        try container.encode(self.musicOff, forKey: .musicOff)
    }
    
}
