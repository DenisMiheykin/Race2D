import Foundation

class RaceResult: Codable {
    
    var user: String
    var speed: String
    var score: Int
    var date: String
    
    init(_ user: String, _ speed: String, _ score: Int, _ date: String) {
        self.user = user
        self.speed = speed
        self.score = score
        self.date = date
    }
    
    public enum CodingKeys: String, CodingKey {
        case user, speed, score, date
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.user = try container.decode(String.self, forKey: .user)
        self.speed = try container.decode(String.self, forKey: .speed)
        self.score = try container.decode(Int.self, forKey: .score)
        self.date = try container.decode(String.self, forKey: .date)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.user, forKey: .user)
        try container.encode(self.speed, forKey: .speed)
        try container.encode(self.score, forKey: .score)
        try container.encode(self.date, forKey: .date)
    }
    
}
