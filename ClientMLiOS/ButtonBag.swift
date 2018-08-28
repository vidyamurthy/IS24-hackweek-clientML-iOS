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
        newButtons.forEach { (button) in
            button.alpha = 0
            self.addArrangedSubview(button)
        }
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
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                sender.backgroundColor = sender.isSelected ? sender.tintColor : .white
            }
        }
        self.delegate?.buttonBagDidUpdate()
    }
    
    private func buttonWith(name: String) -> UIButton {
        let newButton = UIButton()
        newButton.setTitleColor(.white, for: .selected)
        newButton.backgroundColor = .white
        newButton.addTarget(self, action: #selector(update(sender:)), for: .touchUpInside)
        
        return newButton
    }
}
