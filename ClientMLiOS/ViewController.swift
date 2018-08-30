import UIKit

class ViewController: UIViewController, ButtonBagDelegate {
    
    @IBOutlet weak var statsHUD: StatsView!
    @IBOutlet weak var buttonBag: ButtonBag!
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var topAnimationConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomAnimationConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightAnimationConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftAnimationConstraint: NSLayoutConstraint!
    
    private let scoreCalculator = ScoreCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBag.delegate = self
        buttonBag.setButtons(TagsToIndexTranslator.giveMe20RandomTags())
        let score = scoreCalculator.scoreFor([String]())
        statsHUD.updateWithScore(score)
        updateAnimationFor(score: score.1)
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
            updateAnimationFor(score: score.1)
        } else {
            let score = scoreCalculator.scoreFor([String]())
            statsHUD.updateWithScore(score)
            updateAnimationFor(score: score.1)
        }
    }
    
    func updateAnimationFor(score: Double) {
        let defaultWidth = animationView.frame.width / 4
        let defaultHeight = animationView.frame.height / 4
        
        let maxWidth = animationView.frame.width
        let maxHeight = animationView.frame.height - 16
        
        if score <= 40.0 {
            topAnimationConstraint.constant = defaultWidth
            bottomAnimationConstraint.constant = defaultWidth
            
            rightAnimationConstraint.constant = defaultHeight
            leftAnimationConstraint.constant = defaultHeight
           
            return
        }
        if score >= 60.0 {
            topAnimationConstraint.constant = maxWidth
            bottomAnimationConstraint.constant = maxWidth
            
            rightAnimationConstraint.constant = maxHeight
            leftAnimationConstraint.constant = maxHeight
           
            return
        }
        
        let calculatedWidth = ((maxWidth - defaultWidth) / 20.0) * CGFloat(score - 40.0)
        let calculatedHeight = ((maxHeight - defaultHeight) / 20.0) * CGFloat(score - 40.0)
        
        topAnimationConstraint.constant = calculatedWidth + defaultWidth
        bottomAnimationConstraint.constant = calculatedWidth + defaultWidth
        
        rightAnimationConstraint.constant = calculatedHeight + defaultHeight
        leftAnimationConstraint.constant = calculatedHeight + defaultHeight
        
        
        animationView.alpha = CGFloat((score - 40.0) / 20.0)
        
    }
}

