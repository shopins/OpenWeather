import UIKit

class BounceButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5, delay: 0 , usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
        super.touchesEnded(touches, with: event)
    }
}
