import UIKit

protocol ButtonBagDelegate: AnyObject {
    func buttonBagDidUpdate()
}

class ButtonBag: UIStackView {
    weak var delegate: ButtonBagDelegate?
    
    public func setButtons(_ buttonTitles: [String]) {
        removeOldButtons()
        addNewButtons(buttonTitles)
    }
    
    private func removeOldButtons() {
        let allButtons = self.subviews
        allButtons.forEach { (button) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    button.alpha = 0
                }, completion: { (_) in
                    button.removeFromSuperview()
                })
            }
        }
    }
    
    private func addNewButtons(_ buttonTitles: [String]) {
        var newButtons = [UIButton]()
        for buttonTitle in buttonTitles {
            newButtons.append(self.buttonWith(name: buttonTitle))
        }
        let maxWidth = UIScreen.main.bounds.size.width - 32
        var remainingWidth = maxWidth
        var rowStackView = newRowStack()
        newButtons.forEach { (button) in
            let buttonWidth = button.intrinsicContentSize.width
            if remainingWidth < buttonWidth {
                self.addArrangedSubview(rowStackView)
                remainingWidth = maxWidth
                rowStackView = newRowStack()
            } else {
                rowStackView.addArrangedSubview(button)
                button.alpha = 0
                remainingWidth -= (buttonWidth + 16)
            }
        }
        self.addArrangedSubview(rowStackView)
        
        newButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                button.alpha = 1
            }
        }
    }
    
    public func selectedButtons() -> [String]? {
        let allButtons = self.subviews
        var selectedButtons = [String]()
        allButtons.forEach { (maybeButton) in
            if let button = maybeButton as? UIButton {
                if button.isSelected {
                    selectedButtons.append(button.title(for: .normal)!)
                }
            }
        }
        return selectedButtons.count > 0 ? selectedButtons : nil
    }
    
    public func resetSelected() {
        let allStacks = self.subviews
        allStacks.forEach { (stackView) in
            stackView.subviews.forEach { (maybeButton) in
                if let button = maybeButton as? UIButton {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3) {
                            button.isSelected = false
                        }
                    }
                }
            }
        }
    }
}

extension ButtonBag {
    @objc private func update(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.buttonBagDidUpdate()
    }
    
    private func buttonWith(name: String) -> UIButton {
        let newButton = UIButton(type: .system)
        newButton.setTitle(name, for: .normal)
        newButton.addTarget(self, action: #selector(update(sender:)), for: .touchUpInside)
        
        return newButton
    }
    
    private func newRowStack() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.backgroundColor = self.backgroundColor
        rowStackView.distribution = .fillProportionally
        rowStackView.axis = .horizontal
        rowStackView.spacing = 16
        return rowStackView
    }
}
