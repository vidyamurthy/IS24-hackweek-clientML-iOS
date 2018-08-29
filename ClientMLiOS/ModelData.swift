import Foundation

class ModelData: Codable {
    let weights: [[Double]]?
    let vectors: [[Double]]?
    let bias: Double?
    
    enum CodingKeys: String, CodingKey {
        case weights = "weights"
        case vectors = "vectors"
        case bias = "bias"
    }

    static public func loadFromFile() -> ModelData {
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "model", ofType: "json")!)
        let jsonData = try! Data(contentsOf: fileURL)
        let model = try! JSONDecoder().decode(ModelData.self, from: jsonData)
        
        return model
    }
    
    init(weights: [[Double]]?, vectors: [[Double]]?, bias: Double?) {
        self.weights = weights
        self.vectors = vectors
        self.bias = bias
    }
}
