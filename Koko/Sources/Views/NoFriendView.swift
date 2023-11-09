

import UIKit

class NoFriendView: UIView {
    
    // MARK: - Variables and Properties
    @IBOutlet weak var addFriendButton: UIButton!
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
}

// MARK: - Setup
fileprivate extension NoFriendView {
    func customInit() {
        addViewFromXib()
        addFriendsButtom()
    }
    
    func addViewFromXib() {
        let view = Bundle.main.loadNibNamed("\(NoFriendView.self)", owner: self, options: nil)!.first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    func addFriendsButtom() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = addFriendButton.bounds
        gradientLayer.cornerRadius = 20
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor(red: 86/255, green: 179/255, blue: 11/255, alpha: 1).cgColor, UIColor(red: 166/255, green: 204/255, blue: 66/255, alpha: 1).cgColor]
        addFriendButton.layer.insertSublayer(gradientLayer, at: 1)
        addFriendButton.layer.shadowColor = UIColor(red: 121/255, green: 196/255, blue: 27/255, alpha: 0.4).cgColor
        addFriendButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addFriendButton.layer.shadowRadius = 8
    }
}
