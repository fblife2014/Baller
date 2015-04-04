//
//  Baller_HUDView.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_HUDView.h"

@implementation Baller_HUDView

+ (instancetype)shareBallerHUDView{
    static Baller_HUDView * _shareHudView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shareHudView = [[Baller_HUDView alloc]init];
    });
    return _shareHudView;
}


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BALLER_CORLOR_NAVIGATIONBAR;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame labelTitle:(NSString *)title{
    
    if (self = [self initWithFrame:frame]) {
        
     _titleLabel = [ViewFactory addAlabelForAView:self withText:title frame:CGRectMake(5.0, frame.size.height/2.0-7.0, frame.size.width-10.0, 14.0) font:[UIFont systemFontOfSize:14.0] textColor:[UIColor blackColor]];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)bhud_showOnView:(UIView *)bottomView
{
    if (bottomView) {
        [bottomView addSubview:self];
    }else{
        [[[[UIApplication sharedApplication] delegate] window]addSubview:self];
    }
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.alpha = 1;
    [self.layer addAnimation:popAnimation forKey:nil];
    
    __WEAKOBJ(weakSelf, self);
    
    //一秒后隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf bhud_hide];
    });
    
}

- (void)bhud_hide
{
    DLog(@"hideAlertAction");
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    DLog(@"animationDidStop");
    
}

+ (void)bhud_showWithTitle:(NSString *)title{
    
    float titleWidth = [NSStringManager sizeOfCurrentString:title font:14.0 contentSize:CGSizeMake(ScreenWidth-100.0, 40.0)].width;
    
    Baller_HUDView * hudView = [[self class] shareBallerHUDView];
    hudView.frame = CGRectMake(ScreenWidth/2.0-titleWidth/2.0-10.0, ScreenHeight/3.0, titleWidth+20.0, 40.0);
    hudView.titleLabel.frame = CGRectMake(5.0, hudView.frame.size.height/2.0-7.0,hudView.frame.size.width-10.0, 14.0) ;
    hudView.titleLabel.text = title;
    [hudView bhud_showOnView:nil];
}

@end
