//
//  Baller_CustomAnnotationView.m
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#define kCalloutWidth       240.0
#define kCalloutHeight      70.0

#import "Baller_CustomAnnotationView.h"
@interface Baller_CustomAnnotationView()

@end

@implementation Baller_CustomAnnotationView
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[Baller_CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        [self.calloutView.portraitView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

@end
