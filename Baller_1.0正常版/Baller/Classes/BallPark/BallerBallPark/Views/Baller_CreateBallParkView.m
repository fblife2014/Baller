//
//  Baller_CreateBallParkView.m
//  Baller
//
//  Created by malong on 15/1/24.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_CreateBallParkView.h"
#import "Baller_InfoItemView.h"
#import "Baller_ImagePicker.h"

@implementation Baller_CreateBallParkView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        ballParkInfos = [NSMutableDictionary dictionary];
        
        CGFloat titleFontSize = NUMBER(17.0, 16.0, 15.0, 15.0); //主标题字号
        CGFloat detailFontSize = NUMBER(16.0, 15.0, 14.0, 14.0);//副标题字号
        
    
        Baller_InfoItemView * ballParkNameItem = [[Baller_InfoItemView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, PersonInfoCell_Height) title:@"球场名字" placeHolder:@"输入球场名字"];
        ballParkNameItem.infoTextField.userInteractionEnabled = YES;
        [ballParkNameItem.infoTextField addTarget:self action:@selector(ballParkNameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:ballParkNameItem];
        
        CGRect titleFrame = ballParkNameItem.titleLabel.frame;
        titleFrame.origin.x = titleFrame.origin.x-25.0;
        ballParkNameItem.titleLabel.frame = titleFrame;
        
        
        
        Baller_InfoItemView * ballParkImageItem = [[Baller_InfoItemView alloc]initWithFrame:CGRectMake(0.0, PersonInfoCell_Height, frame.size.width, PersonInfoCell_Height*1.5) title:@"上传球场实拍" placeHolder:nil];
        ballParkImageItem.backgroundColor = BALLER_CORLOR_CELL;
        
        CGFloat origin_y = CGRectGetMidY(ballParkImageItem.bounds)-titleFrame.size.height/2.0;
        ballParkImageItem.titleLabel.frame = CGRectMake(titleFrame.origin.x, origin_y, ballParkImageItem.titleLabel.frame.size.width, titleFrame.size.height);
        [ballParkImageItem.infoTextField removeFromSuperview];
        [self addSubview:ballParkImageItem];
        
        ballParkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ballParkImageItem.frame.size.width/2.0-20.0, ballParkImageItem.frame.size.height/2.0-NUMBER(90.0, 80.0, 70.0, 70.0)/2.0, NUMBER(90.0, 80.0, 70.0, 70.0), NUMBER(90.0, 80.0, 70.0, 70.0))];
        ballParkImageView.image = [UIImage imageNamed:@"ballPark_default"];
        ballParkImageView.layer.cornerRadius = TABLE_CORNERRADIUS;
        ballParkImageView.clipsToBounds = YES;
        [ballParkImageItem addSubview:ballParkImageView];
        
        UIButton * updateImageButton = [ViewFactory getAButtonWithFrame:CGRectMake(frame.size.width-86.0, ballParkImageItem.frame.size.height/2.0-17.0, 71.0, 37.0) nomalTitle:@"上传" hlTitle:@"上传" titleColor:BALLER_CORLOR_696969 bgColor:nil nImage:nil hImage:nil action:@selector(updateImage) target:self buttonTpye:UIButtonTypeCustom];
        updateImageButton.layer.cornerRadius = 5.0;
        updateImageButton.layer.borderWidth = 0.5;
        updateImageButton.layer.borderColor = BALLER_CORLOR_696969.CGColor;
        [ballParkImageItem addSubview:updateImageButton];
        
        
        UIImageView * dingweiImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingwei"]];
        dingweiImageView.frame = CGRectMake(titleFrame.origin.x, 0.0, 33.0, 33.0);
        dingweiImageView.center = CGPointMake(dingweiImageView.center.x, frame.size.height-1.5*PersonInfoCell_Height);
        [self addSubview:dingweiImageView];
        
        

        [[ViewFactory addAlabelForAView:self withText:@"自动定位球场位置" frame:CGRectMake(CGRectGetMaxX(dingweiImageView.frame)+NUMBER(31.0, 26, 20, 20),dingweiImageView.center.y-9.5,200,titleFontSize) font:SYSTEM_FONT_S(titleFontSize) textColor:[UIColor blackColor]] setTextAlignment:NSTextAlignmentLeft];
        
        [[ViewFactory addAlabelForAView:self withText:@"需要您在球场使用" frame:CGRectMake(CGRectGetMaxX(dingweiImageView.frame)+NUMBER(31.0, 26, 20, 20),dingweiImageView.center.y+10.5,200,detailFontSize) font:SYSTEM_FONT_S(detailFontSize) textColor:UIColorFromRGB(0x707070)] setTextAlignment:NSTextAlignmentLeft];
        UIImageView * rightArrow1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mycenter_jiantou"]];
        rightArrow1.frame = CGRectMake(frame.size.width-27.0, frame.size.height-1.5*PersonInfoCell_Height-10.5, 12, 21);
        [self addSubview:rightArrow1];
        
        UIButton * autoAnnotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        autoAnnotionButton.frame = CGRectMake(0.0, dingweiImageView.center.y-PersonInfoCell_Height/2.0, self.frame.size.width, PersonInfoCell_Height);
        [autoAnnotionButton addTarget:self action:@selector(autoAnnotionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:autoAnnotionButton];
        
        CALayer * bottomLayer = [CALayer layer];
        bottomLayer.backgroundColor = BALLER_CORLOR_CELL.CGColor;
        bottomLayer.frame = CGRectMake(0.0, frame.size.height-PersonInfoCell_Height, frame.size.width, PersonInfoCell_Height);
        
        [self.layer addSublayer:bottomLayer];
        UIImageView * pinImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"biaozhu"]];
        pinImageView.frame = CGRectMake(titleFrame.origin.x, 0.0, 33.0, 33.0);
        pinImageView.center = CGPointMake(pinImageView.center.x, frame.size.height-0.5*PersonInfoCell_Height);
        [self addSubview:pinImageView];
        
        [[ViewFactory addAlabelForAView:self withText:@"手动标注球场位置" frame:CGRectMake(CGRectGetMaxX(pinImageView.frame)+NUMBER(31.0, 26, 20, 20),pinImageView.center.y-9.5,200,titleFontSize) font:SYSTEM_FONT_S(titleFontSize) textColor:[UIColor blackColor]] setTextAlignment:NSTextAlignmentLeft];
        UIImageView * rightArrow2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mycenter_jiantou"]];
        rightArrow2.frame = CGRectMake(rightArrow1.frame.origin.x, rightArrow1.frame.origin.y+PersonInfoCell_Height, 12, 21);
        [self addSubview:rightArrow2];
        
        UIButton * haderAnnotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        haderAnnotionButton.frame = CGRectMake(0.0, pinImageView.center.y-PersonInfoCell_Height/2.0, self.frame.size.width, PersonInfoCell_Height);
        [haderAnnotionButton addTarget:self action:@selector(haderAnnotionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:haderAnnotionButton];
        
    }
    return self;
}

- (Baller_ImagePicker *)baller_ImagePicker
{
    if (!_baller_ImagePicker) {
        Baller_ImagePicker * baller_ImagePicker = [[Baller_ImagePicker alloc]init];
        _baller_ImagePicker = baller_ImagePicker;
        __BLOCKOBJ(blockImageView, ballParkImageView);
        
        _baller_ImagePicker.baller_ImagePicker_ImageChosenBlock = (^(UIImage * image){
            blockImageView.image = image;
        });
    }
    return _baller_ImagePicker;
}


#pragma mark 方法
- (void)ballParkNameTextFieldChanged:(UITextField *)textField{
    
}

- (void)updateImage{
    [[self baller_ImagePicker] showImageChoseAlertView];
}

- (void)autoAnnotionButtonAction{
    if (_autoAnnotion) {
        self.autoAnnotion(YES);
    }
}

- (void)haderAnnotionButtonAction{
    if (_autoAnnotion) {
        self.autoAnnotion(NO);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
