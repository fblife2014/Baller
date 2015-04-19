//
//  Baller_AbilityEditorView.m
//  Baller
//
//  Created by malong on 15/2/26.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_AbilityEditorView.h"
#import "Baller_AbilityInfoEditor.h"

@implementation Baller_AbilityEditorView

- (id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = CLEARCOLOR;
        self.detailButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
    }
    return self;
}

- (UIButton *)detailButton
{
    if (!_detailButton) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(showDetailDescription) forControlEvents:UIControlEventTouchUpInside];
        _detailButton = button;
        [self addSubview:_detailButton];
    }
    return _detailButton;
}

- (void)showDetailDescription{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:RGBAColor(0.0, 0.0, 0.0, 0.85)];
    button.alpha = 0;
    
    [[ViewFactory addAlabelForAView:button withText:[NSString stringWithFormat:@"等级： %@",[Baller_AbilityInfoEditor levelStringWithAbility:_abilities]] frame:CGRectMake(ScreenWidth/2.0-50, ScreenHeight/2.0-125, ScreenWidth-100, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];

    [[ViewFactory addAlabelForAView:button withText:[NSString stringWithFormat:@"投篮： %@",_abilities[@"shoot"]] frame:CGRectMake(ScreenWidth/2.0-50, ScreenHeight/2.0-85, ScreenWidth-100, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];
    [[ViewFactory addAlabelForAView:button withText:[NSString stringWithFormat:@"助攻： %@",_abilities[@"assists"]] frame:CGRectMake(ScreenWidth/2.0-50, ScreenHeight/2.0-55, ScreenWidth-50, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];
    [[ViewFactory addAlabelForAView:button withText:[NSString stringWithFormat:@"篮板： %@",_abilities[@"backboard"]] frame:CGRectMake(ScreenWidth/2.0-50, ScreenHeight/2.0-25, ScreenWidth-100, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];
    [[ViewFactory addAlabelForAView:button withText:[NSString stringWithFormat:@"抢断： %@",_abilities[@"steal"]] frame:CGRectMake(ScreenWidth/2.0-50, ScreenHeight/2.0+5, ScreenWidth-100, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];
    [[ViewFactory addAlabelForAView:button withText:[NSString stringWithFormat:@"封盖： %@",_abilities[@"over"]] frame:CGRectMake(ScreenWidth/2.0-50, ScreenHeight/2.0+35, ScreenWidth-100, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];
    
    [[ViewFactory addAlabelForAView:button withText:[NSString stringWithFormat:@"突破： %@",_abilities[@"breakthrough"]] frame:CGRectMake(ScreenWidth/2.0-50, ScreenHeight/2.0+65, ScreenWidth-100, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];


    
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

- (void)setAbilities:(NSDictionary *)abilities{
    if (_abilities == abilities) {
        return;
    }
    _abilities = [abilities copy];
    //依据各个能力值，获取六个点
    
    NSInteger shoot = [[abilities valueForKey:@"shoot"] integerValue];
    NSInteger assists = [[abilities valueForKey:@"assists"] integerValue];
    NSInteger backboard = [[abilities valueForKey:@"backboard"] integerValue];
    NSInteger steal = [[abilities valueForKey:@"steal"] integerValue];
    NSInteger over = [[abilities valueForKey:@"over"] integerValue];
    NSInteger breakthrough = [[abilities valueForKey:@"breakthrough"] integerValue];
    NSInteger totalNumber = [[abilities valueForKey:@"totalNumber"] integerValue];


    
    CGFloat radius = (self.frame.size.height+self.frame.size.width)/4.0;
    CGFloat midx = self.frame.size.width/2.0;
    CGFloat midy = self.frame.size.height/2.0;
    float baller_sin30 = 0.5;
    float baller_cos30 = sqrt(3.0)/2.0;
    
    //投篮点
    CGPoint shotPoint = CGPointMake(midx, radius*(1-[Baller_AbilityInfoEditor levelRatio:shoot totalNumber:totalNumber]));
    DLog(@"cos30 = %f",baller_cos30);
    //助攻点
    CGPoint assistsPoint = CGPointMake(midx+radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:assists totalNumber:totalNumber],midy-radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:assists totalNumber:totalNumber]-0.5);
    
    CGPoint shadowAssistsPoint = CGPointMake(midx+radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:assists totalNumber:totalNumber]-2,midy-radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:assists totalNumber:totalNumber]-2.0);

    
    //篮板点
    CGPoint reboundsPoint = CGPointMake(midx+radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:backboard totalNumber:totalNumber],midy+radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:backboard totalNumber:totalNumber]);
    
    CGPoint shadowReboundsPoint = CGPointMake(midx+radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:backboard totalNumber:totalNumber]-2.,midy+radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:backboard totalNumber:totalNumber]-2.);

    //抢断点
    CGPoint stealsPoint= CGPointMake(midx, radius*(1+[Baller_AbilityInfoEditor levelRatio:steal totalNumber:totalNumber]));
    CGPoint shadowStealsPoint= CGPointMake(midx, radius*(1+[Baller_AbilityInfoEditor levelRatio:steal totalNumber:totalNumber])-3.5);

    //封盖点
    CGPoint blocksPoint = CGPointMake(midx-radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:over totalNumber:totalNumber],midy+radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:over totalNumber:totalNumber]);
    CGPoint shadowBlocksPoint = CGPointMake(midx-radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:over totalNumber:totalNumber]+2.,midy+radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:over totalNumber:totalNumber]-2.);

    //突破点
    CGPoint breakthroughPoint = CGPointMake(midx-radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:breakthrough totalNumber:totalNumber],midy-radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:breakthrough totalNumber:totalNumber]-1);
    CGPoint shadowBreakthroughPoint = CGPointMake(midx-radius*baller_cos30*[Baller_AbilityInfoEditor levelRatio:breakthrough totalNumber:totalNumber]+2,midy-radius*baller_sin30*[Baller_AbilityInfoEditor levelRatio:breakthrough totalNumber:totalNumber]-2.5);

    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:shotPoint];
    [path addLineToPoint:assistsPoint];
    [path addLineToPoint:reboundsPoint];
    [path addLineToPoint:stealsPoint];
    [path addLineToPoint:blocksPoint];
    [path addLineToPoint:breakthroughPoint];
    [path addLineToPoint:shotPoint];

    if (_abilityDetailLayer) {
        [_abilityDetailLayer removeFromSuperlayer];
        _abilityDetailLayer = nil;
    }
    _abilityDetailLayer = [CAShapeLayer layer];
    CGRect pathRect = CGRectMake(MIN(blocksPoint.x, breakthroughPoint.x), shotPoint.y, MAX(reboundsPoint.x, assistsPoint.x)-MIN(blocksPoint.x, breakthroughPoint.x), stealsPoint.y-shotPoint.y);
    _abilityDetailLayer.bounds = pathRect;
    _abilityDetailLayer.frame = pathRect;
    _abilityDetailLayer.path = path.CGPath;
    _abilityDetailLayer.shadowColor = [UIColor blackColor].CGColor;
    _abilityDetailLayer.shadowOpacity = 0.5;
    _abilityDetailLayer.fillColor = [Baller_AbilityInfoEditor levelColorWithAbility:abilities].CGColor;
    _abilityDetailLayer.shadowOffset = CGSizeMake(2, 2);
    [self.layer addSublayer:_abilityDetailLayer];
    
    UIBezierPath * shadowPath = [UIBezierPath bezierPath];
    [shadowPath moveToPoint:shotPoint];
    [shadowPath addLineToPoint:shadowAssistsPoint];
    [shadowPath addLineToPoint:shadowReboundsPoint];
    [shadowPath addLineToPoint:shadowStealsPoint];
    [shadowPath addLineToPoint:shadowBlocksPoint];
    [shadowPath addLineToPoint:shadowBreakthroughPoint];
    [shadowPath addLineToPoint:shotPoint];
    
    
    //蒙版layer
    CGRect shadowPathRect = CGRectMake(MIN(shadowBlocksPoint.x, shadowBreakthroughPoint.x), shotPoint.y, MAX(shadowReboundsPoint.x, shadowAssistsPoint.x)-MIN(shadowBlocksPoint.x, shadowBreakthroughPoint.x), shadowStealsPoint.y-shotPoint.y);

    CAShapeLayer * shadowLayer = [CAShapeLayer layer];
    shadowLayer.bounds = shadowPathRect;
    shadowLayer.frame = shadowPathRect;
    UIColor * shadowLayerColor = RGBAColor(250, 250, 250, 0.25);
    shadowLayer.path = shadowPath.CGPath;
    shadowLayer.fillColor = shadowLayerColor.CGColor;
    shadowLayer.shadowColor = shadowLayerColor.CGColor;
    shadowLayer.shadowOpacity = 1.;
    [self.layer addSublayer:shadowLayer];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
