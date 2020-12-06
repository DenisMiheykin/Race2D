import Foundation

class Car: Codable {
    
    var imageNameCar: String
    var imageNameBrokenCar: String
    
    init(_ imageNameCar: String, _ imageNameBrokenCar: String) {
        self.imageNameCar = imageNameCar
        self.imageNameBrokenCar = imageNameBrokenCar
    }
    
    public enum CodingKeys: String, CodingKey {
        case imageNameCar, imageNameBrokenCar
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imageNameCar = try container.decode(String.self, forKey: .imageNameCar)
        self.imageNameBrokenCar = try container.decode(String.self, forKey: .imageNameBrokenCar)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.imageNameCar, forKey: .imageNameCar)
        try container.encode(self.imageNameBrokenCar, forKey: .imageNameBrokenCar)
    }
}
