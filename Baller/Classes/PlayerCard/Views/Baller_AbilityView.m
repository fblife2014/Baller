//
//  Baller_AbilityView.m
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_AbilityView.h"

@implementation Baller_AbilityView

- (void)awakeFromNib{
    self.topView.hidden = YES;
    self.leftBottomView.hidden = YES;
    self.leftTopView.hidden = YES;
    self.rightBottomView.hidden = YES;
    self.rightTopView.hidden = YES;
    self.bottomView.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
