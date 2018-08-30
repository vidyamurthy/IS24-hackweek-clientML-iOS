import Foundation

class ScoreCalculator {
    var modelBias = 0.0
    var modelWeights = [[Double]]()
    var modelVectors = [[Double]]()
    var tags = [String]()
    
    init() {
        let model = ModelData.loadFromFile()
        modelBias = model.bias!
        modelWeights = model.weights!
        modelVectors = model.vectors!
    }
    
    public func scoreFor(_ tags: [String]) -> MLScoreTuple {
        self.tags = tags
        let prediction = predictManually()
        
        
        return (prediction > 0.6, prediction * 100)
    }
    
    func predictManually() -> Double {
        let b = modelBias
        let X = XMaker.makeXWith(tags: tags, size: modelWeights.count)
        let w = modelWeights
        let v = modelVectors
        
        let vPower2 = npPower2(matrix: v)
        let xPower2 = npPower2(vector: X)
        let dotX2andV2 = dot(vector: xPower2, matrix: vPower2)!
        let dotXandV = dot(vector: X, matrix: v)!
        let dotXAndVPower2 = npPower2(vector: dotXandV)
        let diffToSquare = npMinus(lhs: dotXAndVPower2, rhs: dotX2andV2)!
        let sum = diffToSquare.reduce(0, +) * 0.5
        let dotXandW = dot(hVector: X, vVector: w)!
        
        let exp = (-1)*(b + dotXandW + sum)
        
        return (1 - 1.0/Double(1 + pow(M_E, exp)))
    }
    
}

//hardcoded matrix math helpers
extension ScoreCalculator {
    func npPower2(vector: [Double]) -> [Double] {
        return vector.map({ (value) -> Double in
            return value*value
        })
    }
    
    func npPower2(matrix: [[Double]]) -> [[Double]] {
        return matrix.map({ (rowArray) -> [Double] in
            rowArray.map({ (value) -> Double in
                return value*value
            })
        })
    }
    
    func dot(hVector: [Double], vVector: [[Double]]) -> Double? {
        guard vVector[0].count == 1 else {
            return nil
        }
        
        var sum = 0.0
        for i in 0..<hVector.count {
            sum += hVector[i]*vVector[i][0]
        }
        return sum
    }
    
    func dot(vector: [Double], matrix: [[Double]]) -> [Double]? {
        guard vector.count == matrix.count else {
            return nil
        }
        
        var sum1 = 0.0
        var sum2 = 0.0
        for i in 0..<vector.count {
            sum1 += vector[i]*matrix[i][0]
            sum2 += vector[i]*matrix[i][1]
        }
        
        return [sum1,sum2]
    }
    
    func npMinus(lhs: [Double], rhs: [Double]) -> [Double]? {
        guard lhs.count == rhs.count else {
            return nil
        }
        var returnArray = [Double]()
        for i in 0..<lhs.count {
            returnArray.append(lhs[i]-rhs[i])
        }
        return returnArray
    }
}

class XMaker {
    static func makeXWith(tags: [String], size: Int) -> [Double] {
        var initialX = Array(repeating: 0.0, count: size)
        let indices = tags.map { (aTag) -> Int in
            return TagsToIndexTranslator.indexOf(tag: aTag)
        }
        indices.forEach { (index) in
            initialX[index] = 1
        }

        return initialX
    }
}



class TagsToIndexTranslator {
    struct Tag: Codable {
        let index: Int
        let name: String
    }
    
    static let tagsAndIndexCatalog: [Tag] = {
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "tags", ofType: "json")!)
        let jsonData = try! Data(contentsOf: fileURL)
        let model = try! JSONDecoder().decode([Tag].self, from: jsonData)
        return model
    }()
    
    static func indexOf(tag: String) -> Int {
        let filtered = tagsAndIndexCatalog.filter { (aTag) -> Bool in
            if aTag.name == tag {
                return true
            }
            return false
        }
        if filtered.count > 0 {
               return filtered.first!.index
        }
        
        return 0
    }
    
    static func giveMe20RandomTags() -> [String] {
        var randomTags = [String]()
        for _ in 0..<20 {
            let randIndex = arc4random_uniform(UInt32(tagsAndIndexCatalog.count))
            randomTags.append(tagsAndIndexCatalog[Int(randIndex)].name)
        }
        return randomTags
    }
}
