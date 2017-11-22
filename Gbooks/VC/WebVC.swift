

import UIKit

class WebVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    
    var link:URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: link)
        webView.loadRequest(request)
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
