

import UIKit

class EmptyView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: String(describing: String(describing: EmptyView.self)), bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
    
    func configure(title:String, image:UIImage) {
        self.title.text = title
        self.imageView.image = image
        self.imageView.tintColor = Constants.Colors.highlightColor
    }

}
