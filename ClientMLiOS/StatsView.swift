import UIKit

typealias MLScoreTuple = (Bool, Double)
class StatsView: UIView {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var status: UILabel!
    
    public func updateWithScore(_ score: MLScoreTuple) {
        self.score.text = "Score: \(score.1)"
        self.status.text = statusTextFor(score.0)
    }
}

func statusTextFor(_ isLead: Bool) -> String {
    if isLead {
        return "You're a lead"
    } else {
        return "You're not a lead yet"
    }
}
