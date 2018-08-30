import UIKit

typealias MLScoreTuple = (Bool, Double)
class StatsView: UIView {
    @IBOutlet weak var score: UILabel!
    let percentFormatter = { () -> NumberFormatter in
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = Locale(identifier: "en").decimalSeparator
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    
    public func updateWithScore(_ score: MLScoreTuple) {
        self.score.text = "Score: \(percentFormatter.string(from: NSNumber(value: score.1))!)%"
    }
}

