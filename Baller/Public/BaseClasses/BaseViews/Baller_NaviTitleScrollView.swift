//
//  Baller_NaviTitleScrollView.swift
//  Baller
//
//  Created by malong on 15/4/24.
//  Copyright (c) 2015年 malong. All rights reserved.
//

import UIKit

class Baller_NaviTitleScrollView: UIScrollView {

    var titleLable:UILabel = UILabel(frame: CGRectZero)
  
    convenience init(frame: CGRect, title:NSString) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        self.showsHorizontalScrollIndicator = false
        self.titleLable.textColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.titleLable.font = UIFont.systemFontOfSize(18)
        self.titleLable.textAlignment = NSTextAlignment.Center
        self.titleLable.backgroundColor = UIColor.clearColor()
        self.titleLable.text = title as String
        self.titleLable.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        self.titleLable.shadowOffset = CGSizeMake(0.0, 1.0);
        self.addSubview(self.titleLable)
    }

    func resetTitle(title:NSString)
    {
        self.titleLable.text = title as String
        let  width:CGFloat = NSStringManager.sizeOfCurrentString(title as String, font: 18, contentSize: CGSizeMake(CGFloat.max, 20)).width
        self.contentSize = CGSizeMake(width, 20);

        if width > self.frame.size.width {
            self.titleLable.frame = CGRectMake(0.0, 0.0, width, 20)
            self.contentOffset = CGPointMake(width/2.0-self.frame.size.width/2.0, 0)
        }else{
            self.titleLable.frame = CGRectMake(self.frame.size.width/2.0-width/2.0, 0.0, width, 20)
            self.contentOffset = CGPointMake(0, 0)
        }
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
