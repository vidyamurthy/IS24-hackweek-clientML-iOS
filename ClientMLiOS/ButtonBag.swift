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
        let maxWidth = UIScreen.main.bounds.size.width
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
                remainingWidth -= buttonWidth
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
        let allButtons = self.subviews
        //todo get to the buttons
        allButtons.forEach { (maybeButton) in
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

extension ButtonBag {
    @objc private func update(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                sender.backgroundColor = sender.isSelected ? sender.tintColor : .white
            }
        }
        self.delegate?.buttonBagDidUpdate()
    }
    
    private func buttonWith(name: String) -> UIButton {
        let newButton = UIButton(type: .system)
        newButton.setTitle(name, for: .normal)
        newButton.setTitleColor(.white, for: .selected)
        newButton.backgroundColor = .white
        newButton.addTarget(self, action: #selector(update(sender:)), for: .touchUpInside)
        let size = newButton.intrinsicContentSize
        newButton.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return newButton
    }
    
    private func newRowStack() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.alignment = .fill
        rowStackView.axis = .horizontal
        return rowStackView
    }
}
