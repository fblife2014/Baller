//
//  Baller_BallParkCollectionReusableView.h
//  Baller
//
//  Created by malong on 15/1/20.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef NS_ENUM(NSInteger, BallParkType) {
    BallParkTypeIdentifyed = 0,    //已认证
    BallParkTypeIdentifing         //未认证
};

typedef void (^TopButtonClickBlock)(BallParkType ballParkType);

#import <UIKit/UIKit.h>

@interface Baller_BallParkCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *nearButton;

@property (weak, nonatomic) IBOutlet UIButton *authButton;

@property (copy, nonatomic) TopButtonClickBlock topButtonClickBlock;

@end
