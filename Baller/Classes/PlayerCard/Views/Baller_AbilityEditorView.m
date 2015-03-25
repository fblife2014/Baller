//
//  Baller_AbilityEditorView.m
//  Baller
//
//  Created by malong on 15/2/26.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_AbilityEditorView.h"

@implementation Baller_AbilityEditorView

- (id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = CLEARCOLOR;
        layerColors = @[UIColorFromRGB(0xb5d3d4),
                        UIColorFromRGB(0xb6dbd3),
                        UIColorFromRGB(0xb8d7cf),
                        UIColorFromRGB(0xb9d4cb),
                        UIColorFromRGB(0xbbcfc6),
                        UIColorFromRGB(0xbdcac1),
                        UIColorFromRGB(0xc0c3bc),
                        UIColorFromRGB(0xc2b7b1),
                        UIColorFromRGB(0xc6ada8),
                        UIColorFromRGB(0xc2b7b1),
                        UIColorFromRGB(0xc6ada8),
                        UIColorFromRGB(0xcba49f),
                        UIColorFromRGB(0xcd9a96),
                        UIColorFromRGB(0xd1918f),
                        UIColorFromRGB(0xd28b87),
                        UIColorFromRGB(0xd78381),
                        UIColorFromRGB(0xd77c79),
                        UIColorFromRGB(0xda7674),
                        UIColorFromRGB(0xdc6e6d),
                        UIColorFromRGB(0xde6a6a),
                        UIColorFromRGB(0xe16565),
                        UIColorFromRGB(0xe26161)];
        
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
    
    [UIView animateWithDuration:0.5 animations:^{
        button.alpha = 0;
        button.bounds = CGRectMake([[AppDelegate sharedDelegate] window].center.x, [[AppDelegate sharedDelegate] window].center.y, 0, 0);
    }completion:^(BOOL finished) {
        [button removeFromSuperview];
    }];
}

- (void)setAbilities:(NSArray *)abilities{
    if (_abilities == abilities) {
        return;
    }
    _abilities = [abilities copy];
    
    //依据各个能力值，获取六个点
    
    CGFloat radius = (self.frame.size.height+self.frame.size.width)/4.0;
    CGFloat midx = self.frame.size.width/2.0;
    CGFloat midy = self.frame.size.height/2.0;
    float baller_sin30 = 0.5;
    float baller_cos30 = sqrt(3.0)/2.0;
    //投篮点
    CGPoint shotPoint = CGPointMake(midx, radius*(1-[abilities[0] floatValue]));
    DLog(@"cos30 = %f",baller_cos30);
    //助攻点
    CGPoint assistsPoint = CGPointMake(midx+radius*baller_cos30*[abilities[1] floatValue],midy-radius*baller_sin30*[abilities[1] floatValue]-0.5);
    
    CGPoint shadowAssistsPoint = CGPointMake(midx+radius*baller_cos30*[abilities[1] floatValue]-2,midy-radius*baller_sin30*[abilities[1] floatValue]-2.0);

    
    //篮板点
    CGPoint reboundsPoint = CGPointMake(midx+radius*baller_cos30*[abilities[2] floatValue],midy+radius*baller_sin30*[abilities[2] floatValue]);
    CGPoint shadowReboundsPoint = CGPointMake(midx+radius*baller_cos30*[abilities[2] floatValue]-2.,midy+radius*baller_sin30*[abilities[2] floatValue]-2.);

    //抢断点
    CGPoint stealsPoint= CGPointMake(midx, radius*(1+[abilities[3] floatValue]));
    CGPoint shadowStealsPoint= CGPointMake(midx, radius*(1+[abilities[3] floatValue])-3.5);

    //封盖点
    CGPoint blocksPoint = CGPointMake(midx-radius*baller_cos30*[abilities[4] floatValue],midy+radius*baller_sin30*[abilities[4] floatValue]);
    CGPoint shadowBlocksPoint = CGPointMake(midx-radius*baller_cos30*[abilities[4] floatValue]+2.,midy+radius*baller_sin30*[abilities[4] floatValue]-2.);

    //突破点
    CGPoint breakthroughPoint = CGPointMake(midx-radius*baller_cos30*[abilities[5] floatValue],midy-radius*baller_sin30*[abilities[5] floatValue]-1);
    CGPoint shadowBreakthroughPoint = CGPointMake(midx-radius*baller_cos30*[abilities[5] floatValue]+2,midy-radius*baller_sin30*[abilities[5] floatValue]-2.5);

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
    UIColor * color = layerColors[arc4random()%20];
    _abilityDetailLayer.path = path.CGPath;
    _abilityDetailLayer.fillColor = color.CGColor;
    _abilityDetailLayer.shadowColor = [UIColor blackColor].CGColor;
    _abilityDetailLayer.shadowOpacity = 0.5;
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
