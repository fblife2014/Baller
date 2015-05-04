//
//  Baller_PrivacyPolicyViewController.swift
//  Baller
//
//  Created by malong on 15/5/4.
//  Copyright (c) 2015年 malong. All rights reserved.
//

import UIKit

class Baller_PrivacyPolicyViewController: BaseViewController {

    var privacyWebView:UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviTitleScrollView.resetTitle("隐私条款");
        
        self.privacyWebView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-44);
        self.privacyWebView.scalesPageToFit = true
        self.view.addSubview(self.privacyWebView);
        
        let url:NSURL = NSURL(string: "http://123.57.35.119:84/index.php?c=privacy")!
        self.privacyWebView.loadRequest(NSURLRequest(URL: url))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
