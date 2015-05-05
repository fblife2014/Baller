//
//  Baller_AbilityView.m
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_AbilityView.h"

#import <POP/POP.h>
@implementation Baller_AbilityView

- (IBAction)showDetailInfo:(id)sender {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:RGBAColor(0.0, 0.0, 0.0, 0.5)];
    [button setImage:[UIImage imageNamed:@"activityInfo"] forState:UIControlStateNormal];
    button.alpha = 0;
    button.frame = [UIScreen mainScreen].bounds;
    [button addTarget:self action:@selector(hideTheActivityInfo:) forControlEvents:UIControlEventTouchUpInside];
    [MAINWINDOW addSubview:button];
    [UIView animateWithDuration:0.4 animations:^{
        button.alpha = 1;
    }];

}
- (void)hideTheActivityInfo:(UIButton *)button{
    
    [button removeFromSuperview];
}


- (void)awakeFromNib{
    self.topView.hidden = YES;
    self.leftBottomView.hidden = YES;
    self.leftTopView.hidden = YES;
    self.rightBottomView.hidden = YES;
    self.rightTopView.hidden = YES;
    self.bottomView.hidden = YES;
    self.doneButton.hidden = YES;
    self.cancel.hidden = YES;
    _showEvaluateViews = NO;
}

- (void)setShowEvaluateViews:(BOOL)showEvaluateViews{
    if (_showEvaluateViews == showEvaluateViews) {
        return;
    }
    if (self.chosedAttributes.allKeys.count) {
        [self.chosedAttributes removeAllObjects];
    }
    _showEvaluateViews = showEvaluateViews;
    self.topView.hidden = !showEvaluateViews;
    self.leftBottomView.hidden = !showEvaluateViews;
    self.leftTopView.hidden = !showEvaluateViews;
    self.rightBottomView.hidden = !showEvaluateViews;
    self.rightTopView.hidden = !showEvaluateViews;
    self.bottomView.hidden = !showEvaluateViews;
    self.doneButton.hidden = !showEvaluateViews;
    self.cancel.hidden = !showEvaluateViews;
    
}

- (NSMutableDictionary *)chosedAttributes
{
    if (!_chosedAttributes) {
        _chosedAttributes = [NSMutableDictionary new];
    }
    return _chosedAttributes;
}

- (IBAction)doneButtonAction:(id)sender {
    if (0 == self.chosedAttributes.allValues.count) {
        [Baller_HUDView bhud_showWithTitle:@"您未选择要评价的能力"];
        return;
    }
    
    if (!_evaluatedPersonUid || !_evaluateType) {
        return;
    }


    NSMutableDictionary * parameters = self.chosedAttributes.mutableCopy;
    
    if ([_evaluateType isEqualToString:@"activity"]) {
        if (_activity_id) {
            [parameters setValue:_activity_id forKey:@"activity_id"];
        }else{
            return;
        }
        [parameters setValue:_evaluateType forKey:@"type"];
        
    }else if ([_evaluateType isEqualToString:@"friend"]){
        [parameters setValue:_evaluateType forKey:@"type"];

    }else{
        return;
    }
    [parameters setValue:_evaluatedPersonUid forKey:@"uid"];
    [parameters setValue:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode] forKey:@"authcode"];
    [AFNHttpRequestOPManager postWithSubUrl:Baller_evaluate_activity parameters:parameters responseBlock:^(id result, NSError *error) {

        if (error) {
            [Baller_HUDView bhud_showWithTitle:error.domain];
            return ;
        }
        
        if ([result intForKey:@"errorcode"] == 0) {
            self.showEvaluateViews = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EvaluateDone" object:self];
            [Baller_HUDView bhud_showWithTitle:@"评价成功！"];
            if (_evaluateButton)[_evaluateButton removeFromSuperview];
            
        }else{
            [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
        }
        
    }];
    
}

- (IBAction)cancelButtonAction:(id)sender {
    self.showEvaluateViews = NO;
}


- (IBAction)shootButtonAction:(id)sender {
    
    if (![self isHaveChosedThreeAttributes]) {
        [self shakeView:self.topView];
        [self.chosedAttributes setValue:@"1" forKey:@"shoot"];
    }
}

- (IBAction)assistButtonAction:(id)sender {

    if (![self isHaveChosedThreeAttributes]) {
        [self shakeView:self.rightTopView];

        [self.chosedAttributes setValue:@"1" forKey:@"assists"];
    }
}


- (IBAction)boardButtonAction:(id)sender {
    
    if (![self isHaveChosedThreeAttributes]) {
        [self shakeView:self.rightBottomView];
        [self.chosedAttributes setValue:@"1" forKey:@"backboard"];
    }
}
- (IBAction)stealButtonAction:(id)sender {
    
    if (![self isHaveChosedThreeAttributes]) {
        [self shakeView:self.bottomView];
        [self.chosedAttributes setValue:@"1" forKey:@"steal"];
    }
}

- (IBAction)coverButtonAction:(id)sender {

    if (![self isHaveChosedThreeAttributes]) {
        [self shakeView:self.leftBottomView];
        [self.chosedAttributes setValue:@"1" forKey:@"over"];

    }
}


- (IBAction)crossButtonAction:(id)sender {

    if (![self isHaveChosedThreeAttributes]) {
        [self shakeView:self.leftTopView];

        [self.chosedAttributes setValue:@"1" forKey:@"breakthrough"];

    }
}

- (BOOL)isHaveChosedThreeAttributes
{
    BOOL isHaveThree = self.chosedAttributes.allKeys.count==3;
    if (isHaveThree) {
        [Baller_HUDView bhud_showWithTitle:@"最多只可评价三项！"];
    }
    return isHaveThree;
}

/*!
 *  @brief  晃动按钮动画
 */
- (void)shakeView:(UIView *)aView
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @1000;
    positionAnimation.springBounciness = 10;
    __WEAKOBJ(weakView, aView)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakView.hidden = YES;
    });
    [aView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
