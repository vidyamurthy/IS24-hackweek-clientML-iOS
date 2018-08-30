import UIKit

class ViewController: UIViewController, ButtonBagDelegate {
    
    @IBOutlet weak var statsHUD: StatsView!
    @IBOutlet weak var buttonBag: ButtonBag!
    private let scoreCalculator = ScoreCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBag.delegate = self
        buttonBag.setButtons(TagsToIndexTranslator.giveMe20RandomTags())
        let score = scoreCalculator.scoreFor([String]())
        statsHUD.updateWithScore(score)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        buttonBag.resetSelected()
        let score = scoreCalculator.scoreFor([String]())
        statsHUD.updateWithScore(score)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.buttonBag.alpha = 0
            self?.buttonBag.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { [weak self] (_) in
            self?.buttonBag.setButtons(TagsToIndexTranslator.giveMe20RandomTags())
            UIView.animate(withDuration: 0.3, animations: {
                self?.buttonBag.alpha = 1
                self?.buttonBag.transform = .identity
            }, completion: nil)
        }
    }
    
    func buttonBagDidUpdate() {
        if let selectedTags = buttonBag.selectedButtons() {
            let score = scoreCalculator.scoreFor(selectedTags)
            statsHUD.updateWithScore(score)
        } else {
            let score = scoreCalculator.scoreFor([String]())
            statsHUD.updateWithScore(score)
        }
    }
}

