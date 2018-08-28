import UIKit

class ViewController: UIViewController, ButtonBagDelegate {
    
    @IBOutlet weak var statsHUD: StatsView!
    @IBOutlet weak var buttonBag: ButtonBag!
    private let scoreCalculator = ScoreCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBag.delegate = self
        buttonBag.setButtons(["view buy expose",
                              "do buy search",
                              "search in berlin",
                              "ran out of ideas for button titles",
                              "event 1",
                              "event 2",
                              "bla bla",
                              "nooooo",
                              "yeeeea",
                              "awww yisss"])
        let score = scoreCalculator.scoreFor([String]())
        statsHUD.updateWithScore(score)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        buttonBag.resetSelected()
        let score = scoreCalculator.scoreFor([String]())
        statsHUD.updateWithScore(score)
    }
    
    func buttonBagDidUpdate() {
        if let selectedTags = buttonBag.selectedButtons() {
            let score = scoreCalculator.scoreFor(selectedTags)
            statsHUD.updateWithScore(score)
        }
    }
}

