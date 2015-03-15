//
//  Baller_PersonInfoItemView.m
//  Baller
//
//  Created by malong on 15/1/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#define titleLabel_FontSize NUMBER(18.0, 17.0, 16.0, 16.0)
#define infoTextField_FontSize NUMBER(16.0, 16.0, 15.0, 15.0)

#import "Baller_InfoItemView.h"

@implementation Baller_InfoItemView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabelHorizontalScale = 0.156;
        self.infoTextFieldHorizontalScale = 0.553;
        self.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        placeHolder:(NSString *)placeHolder{
    
    self = [self initWithFrame:frame];
    if (self) {
        self.titleLabel.text = title;
        self.infoTextField.placeholder = placeHolder;
    }
    return  self;
}

- (void)setGrayCircleLayerRadius:(CGFloat)grayCircleLayerRadius{
    
    if (_grayCircleLayerRadius == grayCircleLayerRadius) {
        return;
    }

    _grayCircleLayerRadius = grayCircleLayerRadius;
    if (grayCircleLayerRadius == 0.0) {
        if (_grayCircleLayer) {
            _grayCircleLayer.hidden = YES;
        }
        return;
    }
    
    if (!_grayCircleLayer) {
        CALayer * grayCircleLayer = [CALayer layer];
        grayCircleLayer.backgroundColor = BALLER_CORLOR_696969.CGColor;
        [self.layer addSublayer:_grayCircleLayer = grayCircleLayer];
    }
    _grayCircleLayer.frame = CGRectMake(self.frame.size.width*self.titleLabelHorizontalScale/2.0-grayCircleLayerRadius, self.frame.size.height/2.0-grayCircleLayerRadius, 2*grayCircleLayerRadius, 2*grayCircleLayerRadius);
    _grayCircleLayer.cornerRadius = grayCircleLayerRadius;
    
}

- (void)setInfoCanEdited:(BOOL)infoCanEdited{
    if (_infoCanEdited == infoCanEdited) {
        return;
    }
    self.infoTextField.userInteractionEnabled = infoCanEdited;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*self.titleLabelHorizontalScale, (self.frame.size.height-titleLabel_FontSize)/2.0-1.0, self.frame.size.width*(1-self.titleLabelHorizontalScale), titleLabel_FontSize+2)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        
        _titleLabel = label;
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UITextField *)infoTextField
{
    if (!_infoTextField) {
        _infoTextField = [UITextField new];
        _infoTextField.frame = CGRectMake(self.frame.size.width*self.infoTextFieldHorizontalScale, (self.frame.size.height-titleLabel_FontSize)/2.0-2.5, self.frame.size.width*(1-self.infoTextFieldHorizontalScale)-10.0, infoTextField_FontSize+5.0);
        _infoTextField.userInteractionEnabled = self.infoCanEdited;
        _infoTextField.font = [UIFont systemFontOfSize:NUMBER(16.0, 15.0, 14.0, 14.0)];
        _infoTextField.textColor = BALLER_CORLOR_5c5c5c;
        [self addSubview:_infoTextField];
    }
    return _infoTextField;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
