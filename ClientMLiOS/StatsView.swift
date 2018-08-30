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
    
    override func awakeFromNib() {
        self.score.textColor = UIColor(red: 0, green: 52/255.0, blue: 104/255.0, alpha: 1)
    }
    
    public func updateWithScore(_ score: MLScoreTuple) {
        self.score.text = "Score: \(percentFormatter.string(from: NSNumber(value: score.1))!)%"
    }
}

