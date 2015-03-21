//
//  Baller_HUDView.h
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

//baller的提示视图。比如“关注”、“取消关注”等提示语。

#import <UIKit/UIKit.h>

@interface Baller_HUDView : UIView

/*!
 *  @brief  提示标签
 */
@property (nonatomic, strong)UILabel * titleLabel;


- (id)initWithFrame:(CGRect)frame labelTitle:(NSString *)title;

- (void)bhud_showOnView:(UIView *)bottomView;

- (void)bhud_hide;

+ (instancetype)shareBallerHUDView;

+ (void)bhud_showWithTitle:(NSString *)title;

@end
