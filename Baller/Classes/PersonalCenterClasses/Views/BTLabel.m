//
//  BTLabel.m
//  asdasdasdasdasd
//
//  Created by Tongtong Xu on 15/3/22.
//  Copyright (c) 2015年 xxx Innovation Co. Ltd. All rights reserved.
//

#import "BTLabel.h"

@implementation BTLabel

- (void)awakeFromNib {
    [self configPaddingInDiffVersion];
}

- (void)drawTextInRect:(CGRect)rect {
    //因为中、英文、数字字符占位不同所以左右减一适配
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, self.padding-1, 0, self.padding-1))];
    CGRect bounds = rect;
    if (self.topCornerRadius) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(self.topCornerRadius, self.topCornerRadius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    if (self.bottomCornerRadius) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.bottomCornerRadius, self.bottomCornerRadius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    return CGRectInset([self.attributedText boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin context:nil], -self.padding, -5);
}

- (void)configPaddingInDiffVersion {
    if ([[UIScreen mainScreen] bounds].size.width < 374) {
        self.padding = 5;
    } else if ([[UIScreen mainScreen] bounds].size.width < 413) {
        self.padding = 8;
    } else if ([[UIScreen mainScreen] bounds].size.width < 500) {
        self.padding = 13;
    }
}

@end
