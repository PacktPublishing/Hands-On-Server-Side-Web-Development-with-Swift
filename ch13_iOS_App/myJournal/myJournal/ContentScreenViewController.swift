//
//  ContentScreenViewController.swift
//  myJournal
//
//  Created by Angus yeung on 10/25/18.
//  Copyright © 2018 Server Side Swift. All rights reserved.
//

import UIKit
import WebKit

class ContentScreenViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let myWebview = webView {
                let url = NSURL(string: detail)
                let request = NSURLRequest(url: url! as URL)
                self.navigationItem.title = detail
                myWebview.load(request as URLRequest)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}
