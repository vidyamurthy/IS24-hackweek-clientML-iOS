import UIKit

typealias MLScoreTuple = (Bool, Double)
class StatsView: UIView {
    @IBOutlet weak var score: UILabel?
    @IBOutlet weak var status: UILabel?
    
    public func updateWithScore(_ score: MLScoreTuple) {
        
    }
}
