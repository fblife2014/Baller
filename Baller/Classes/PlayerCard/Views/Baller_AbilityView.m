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
    _showEvaluateViews = NO;
}

- (void)setShowEvaluateViews:(BOOL)showEvaluateViews{
    if (_showEvaluateViews == showEvaluateViews) {
        return;
    }
    _showEvaluateViews = showEvaluateViews;
    self.topView.hidden = !showEvaluateViews;
    self.leftBottomView.hidden = !showEvaluateViews;
    self.leftTopView.hidden = !showEvaluateViews;
    self.rightBottomView.hidden = !showEvaluateViews;
    self.rightTopView.hidden = !showEvaluateViews;
    self.bottomView.hidden = !showEvaluateViews;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
