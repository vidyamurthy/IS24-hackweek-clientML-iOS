import Foundation

class ScoreCalculator {
    public func scoreFor(_ tags: [String]) -> MLScoreTuple {
        let isGood = arc4random_uniform(500) > 250
        let score = Double(arc4random_uniform(500))
        return (isGood, score)
    }
}
