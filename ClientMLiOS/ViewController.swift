import UIKit


class ViewController: UIViewController, ButtonBagDelegate {
    
    @IBOutlet weak var statsHUD: StatsView!
    @IBOutlet weak var buttonBag: ButtonBag!
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var topAnimationConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomAnimationConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightAnimationConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftAnimationConstraint: NSLayoutConstraint!
    
    var flashedOnce = false
    
    private let scoreCalculator = ScoreCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBag.delegate = self
        buttonBag.setButtons(TagsToIndexTranslator.giveMe20RandomTags())
        let score = scoreCalculator.scoreFor([String]())
        statsHUD.updateWithScore(score)
        updateProgressViewWith(score: score.1)
        animationView.subviews.forEach { (view) in
            view.layer.cornerRadius = 2
        }
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
        
        updateProgressViewWith(score: score.1)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.statsHUD.updateWithScore(score)
            self?.animationView.layoutIfNeeded()
            self?.animationView.alpha = CGFloat((score.1 - 40.0) / 20.0)
            }, completion: nil)
    }
    
    func buttonBagDidUpdate() {
        var score: MLScoreTuple
        if let selectedTags = buttonBag.selectedButtons() {
            score = scoreCalculator.scoreFor(selectedTags)
        } else {
            score = scoreCalculator.scoreFor([String]())
        }
        
        updateProgressViewWith(score: score.1)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.statsHUD.updateWithScore(score)
            self?.animationView.layoutIfNeeded()
            self?.animationView.alpha = CGFloat((score.1 - 40.0) / 20.0)
        }) { [weak self] (_) in
            if score.1 >= 60 {
                self?.flashAnimationView()
                self?.flashedOnce = true
            } else {
                self?.flashedOnce = false
            }
        }
    }
    
    func flashAnimationView() {
        guard flashedOnce == false else {
            return
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.animationView.backgroundColor = self?.animationView.subviews.first!.backgroundColor!
            self?.animationView.alpha = 0.2
        }) { [weak self] (_) in
            UIView.animate(withDuration: 0.05, animations: {
                self?.animationView.backgroundColor = .clear
                self?.animationView.alpha = 1
            })
        }
    }
    
    func updateProgressViewWith(score: Double) {
        let defaultWidth = animationView.frame.width / 4
        let defaultHeight = animationView.frame.height / 4
        
        let maxWidth = animationView.frame.width
        let maxHeight = animationView.frame.height - 4
        
        if score <= 40.0 {
            topAnimationConstraint.constant = defaultWidth
            bottomAnimationConstraint.constant = defaultWidth
            
            rightAnimationConstraint.constant = defaultHeight
            leftAnimationConstraint.constant = defaultHeight
           animationView.setNeedsLayout()
            return
        }
        if score >= 60.0 {
            topAnimationConstraint.constant = maxWidth
            bottomAnimationConstraint.constant = maxWidth
            
            rightAnimationConstraint.constant = maxHeight
            leftAnimationConstraint.constant = maxHeight
            animationView.setNeedsLayout()
            return
        }
        
        let calculatedWidth = ((maxWidth - defaultWidth) / 20.0) * CGFloat(score - 40.0)
        let calculatedHeight = ((maxHeight - defaultHeight) / 20.0) * CGFloat(score - 40.0)
        
        topAnimationConstraint.constant = calculatedWidth + defaultWidth
        bottomAnimationConstraint.constant = calculatedWidth + defaultWidth
        
        rightAnimationConstraint.constant = calculatedHeight + defaultHeight
        leftAnimationConstraint.constant = calculatedHeight + defaultHeight
        animationView.setNeedsLayout()
    }
}

