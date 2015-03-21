//
//  Baller_BPAttentionPersonListHeader.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BPAttentionPersonListHeader.h"

@implementation Baller_BPAttentionPersonListHeader

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _leftButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, 0.0, ScreenWidth/2.0, frame.size.height) nomalTitle:@"球员" hlTitle:@"球员" titleColor:BALLER_CORLOR_767676 bgColor:nil nImage:nil hImage:nil action:@selector(leftButtonClicked:) target:self buttonTpye:UIButtonTypeCustom];
        _leftButton.titleLabel.font = SYSTEM_FONT_S(14.0);
        [self addSubview:_leftButton];
        
        _rightButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth/2.0, 0.0, ScreenWidth/2.0, frame.size.height) nomalTitle:@"球队" hlTitle:@"球队" titleColor:BALLER_CORLOR_767676 bgColor:nil nImage:nil hImage:nil action:@selector(rightButtonClicked:) target:self buttonTpye:UIButtonTypeCustom];
        _rightButton.titleLabel.font = SYSTEM_FONT_S(14.0);
        [self addSubview:_rightButton];
        
        //中线
        CALayer * line = [CALayer new];
        line.frame = CGRectMake(ScreenWidth/2.0-0.5, 9.0, 0.5, frame.size.height-18.0);
        line.backgroundColor = BALLER_CORLOR_b2b2b2.CGColor;
        [self.layer addSublayer:line];
        
        //底线
        CALayer * bottomLine = [CALayer new];
        bottomLine.frame = CGRectMake(0.0, frame.size.height-0.5, frame.size.width, 0.5);
        bottomLine.backgroundColor = BALLER_CORLOR_b2b2b2.CGColor;
        [self.layer addSublayer:bottomLine];
    }
    return self;
}

- (void)leftButtonClicked:(UIButton *)button{
    [_leftButton setTitleColor:UIColorFromRGB(0x1d8ed4) forState:UIControlStateNormal];
    [_rightButton setTitleColor:BALLER_CORLOR_767676 forState:UIControlStateNormal];

    if (_target && _leftClickedAction) {
        if ([_target respondsToSelector:_leftClickedAction]) {
            SuppressPerformSelectorLeakWarning([_target performSelector:_leftClickedAction withObject:nil]);

        }
    }
}

- (void)rightButtonClicked:(UIButton *)button{
    [_rightButton setTitleColor:UIColorFromRGB(0x1d8ed4) forState:UIControlStateNormal];
    [_leftButton setTitleColor:BALLER_CORLOR_767676 forState:UIControlStateNormal];
    if (_target && _rightClickedAction) {
        if ([_target respondsToSelector:_rightClickedAction]) {
            SuppressPerformSelectorLeakWarning([_target performSelector:_rightClickedAction withObject:nil]);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
