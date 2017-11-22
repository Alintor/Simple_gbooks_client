

import UIKit
import WebKit

class WebVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    
    var link:URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: link)
        webView.load(request)
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
