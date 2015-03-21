//
//  Baller_BPAttentionPersonListHeader.h
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Baller_BPAttentionPersonListHeader : UIView
@property (nonatomic, weak)id target;
@property (nonatomic, assign)SEL leftClickedAction;
@property (nonatomic, assign)SEL rightClickedAction;
@property (nonatomic, strong)UIButton * leftButton;
@property (nonatomic, strong)UIButton * rightButton;

- (void)leftButtonClicked:(UIButton *)button;
- (void)rightButtonClicked:(UIButton *)button;

@end
