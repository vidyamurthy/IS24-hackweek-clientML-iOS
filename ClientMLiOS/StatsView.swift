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
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
    }
    
    public func updateWithScore(_ score: MLScoreTuple) {
        switch score.1 {
        case 0..<40:
            self.backgroundColor = UIColor(red: 255/255.0, green: 87/255.0, blue: 63/255.0, alpha: 1)
        case 60..<100:
            self.backgroundColor = UIColor(red: 76/255.0, green: 175/255.0, blue: 80/255.0, alpha: 1)
        default:
            self.backgroundColor = UIColor(red: 251/255.0, green: 192/255.0, blue: 45/255.0, alpha: 1)
        }
        self.score.text = "Score: \(percentFormatter.string(from: NSNumber(value: score.1))!)%"
    }
}

