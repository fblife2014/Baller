//
//  Baller_AlertLabel.h
//  Baller
//
//  Created by malong on 15/2/26.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Baller_AlertLabel : UILabel

@property (nonatomic,strong)UIView * aboveView; //上层视图

- (void)showLabel;
- (void)hideLabel;

@end
