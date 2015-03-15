//
//  Baller_AlertLabel.m
//  Baller
//
//  Created by malong on 15/2/26.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_AlertLabel.h"
#import "UIColor+CustomColors.h"
#import <POP/POP.h>

@implementation Baller_AlertLabel

- (id)init{
    if(self = [super init]){
        self.font = [UIFont fontWithName:@"Avenir-Light" size:14];
        self.textColor = [UIColor customYellowColor];
//        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)showLabel
{
    self.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.aboveView.layer.position.y - 0.75*self.aboveView.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLabel];
    });
}

- (void)hideLabel
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.aboveView.layer.position.y);
    [self.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}



@end
