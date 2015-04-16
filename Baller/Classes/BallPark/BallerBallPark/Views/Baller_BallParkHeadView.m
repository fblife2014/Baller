//
//  Baller_BallParkHeadImageView.m
//  Baller
//
//  Created by malong on 15/1/23.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkHeadView.h"
#import "Baller_BallParkListModel.h"
#import "Baller_ImagePicker.h"
#import "UIImage+APLBlurEffect.h"

@implementation Baller_BallParkHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [ViewFactory addLayerToView:self.layer frame:CGRectMake(0.0, frame.size.height-0.5, frame.size.width, 0.5) layerColor:UIColorFromRGB(0xcfcfcf)];
        
    }
    
    return self;
}

- (void)setBallParkInfo:(NSDictionary *)ballParkInfo{
    if (_ballParkInfo == ballParkInfo) {
        return;
    }
    _ballParkInfo = ballParkInfo;
    
    [self.ballParkImageView sd_setImageWithURL:[NSURL URLWithString:[ballParkInfo valueForKey:@"court_img"]] placeholderImage:[UIImage imageNamed:@"weishangchuan"]];
    self.hasIdentified = ([[ballParkInfo valueForKey:@"status"] intValue] == 2);
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    if (_currentDate == currentDate) {
        return;
    }
    _currentDate = currentDate;
    self.dateString = [TimeManager dateStringWithMonthAndDay:currentDate];

}

- (void)setDateString:(NSString *)dateString{
    if ([_dateString isEqualToString:dateString]) {
        return;
    }
    _dateString = dateString;
    [calendarButton setTitle:dateString forState:UIControlStateNormal];
}

- (UIImageView *)ballParkImageView
{
    if (!_ballParkImageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height-50.0)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = UIColorFromRGB(0xe7e7e7);
        imageView.clipsToBounds = YES;
       [self addSubview: _ballParkImageView = imageView ];
        //若没有图片
        if (!([[_ballParkInfo valueForKey:@"court_img"] length]>10)) {
            [self addUpdateImageButton];
        }
        
    }
    return _ballParkImageView;
}

- (UIImageView *)ballParkBlurImageView
{
    if (!_ballParkBlurImageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.ballParkImageView.frame];
        imageView.autoresizingMask = self.ballParkImageView.autoresizingMask;
        imageView.alpha = 0.0f;
        [self addSubview:imageView];
        _ballParkBlurImageView = imageView;
        
    }
    return _ballParkBlurImageView;
}



- (void)setHasIdentified:(BOOL)hasIdentified{
    _hasIdentified = hasIdentified;
    CGRect frame = self.frame;
    //已验证了的视图
    if (hasIdentified && !userButton) {
        if (goRightButton) {
            [goRightButton removeFromSuperview];
        }
        
        CGFloat HSpace = 17.0;     //水平距右侧的间隙
        CGFloat VSpace = 13.0;     //垂直距下侧的间隙
        CGFloat imageWidth = 40.0;
    
        userButton = [ViewFactory getAButtonWithFrame:CGRectMake(frame.size.width-HSpace-imageWidth, frame.size.height-3*(imageWidth+VSpace)-50.0, imageWidth, imageWidth) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:@"players" hImage:@"players" action:@selector(userButtonClicked) target:self buttonTpye:UIButtonTypeCustom];
        [self addSubview:userButton];
        
        mapButton = [ViewFactory getAButtonWithFrame:CGRectMake(frame.size.width-HSpace-imageWidth, frame.size.height-2*(imageWidth+VSpace)-50.0, imageWidth, imageWidth) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:@"map" hImage:@"map" action:@selector(mapButtonClicked) target:self buttonTpye:UIButtonTypeCustom];
        [self addSubview:mapButton];
        
        chatButton = [ViewFactory getAButtonWithFrame:CGRectMake(frame.size.width-HSpace-imageWidth, frame.size.height-(imageWidth+VSpace)-50.0, imageWidth, imageWidth) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:@"chat" hImage:@"chat" action:@selector(chatButtonClicked) target:self buttonTpye:UIButtonTypeCustom];
        [self addSubview:chatButton];
        
        UIImage *calendarImage = [UIImage imageNamed:@"date"];
        CALayer * dateLayer = [CALayer layer];
        dateLayer.contents = (__bridge id)(calendarImage.CGImage);
        dateLayer.anchorPoint = CGPointZero;
        dateLayer.frame = CGRectMake(33.0, frame.size.height-34.0, 16.0, 16.0);
        [self.layer addSublayer:dateLayer];
                
        calendarButton = [ViewFactory getAButtonWithFrame:CGRectMake(56.0, frame.size.height-45.0, 80, 40.0) nomalTitle:nil hlTitle:nil titleColor:BALLER_CORLOR_696969 bgColor:nil nImage:nil hImage:nil action:@selector(calendarButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        calendarButton.titleLabel.font = DEFAULT_BOLDFONT(16.0);
        self.currentDate = [NSDate date];
        [self addSubview:calendarButton];
        
        activitieButton = [ViewFactory getAButtonWithFrame:CGRectMake(frame.size.width-NUMBER(117.0, 107, 90, 80)-15.0, frame.size.height-40.0, NUMBER(117.0, 107, 90, 80), 30.0) nomalTitle:@"发起活动" hlTitle:@"发起活动" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGB(0x51d3b7) nImage:nil hImage:nil action:@selector(activitieButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        activitieButton.layer.cornerRadius = 7.0;
        activitieButton.titleLabel.font = DEFAULT_BOLDFONT(16.0);
        [self addSubview:activitieButton];
    }else{
        
        goRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        goRightButton.backgroundColor = CLEARCOLOR;
        goRightButton.frame = CGRectMake(0.0, frame.size.height-50.0, ScreenWidth, 50.0);
        [goRightButton addTarget:self action:@selector(goRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goRightButton];
        
        UIImage *weizhiImage = [UIImage imageNamed:@"location_small"];
        CALayer * weizhiLayer = [CALayer layer];
        weizhiLayer.contents = (__bridge id)(weizhiImage.CGImage);
        weizhiLayer.anchorPoint = CGPointZero;
        weizhiLayer.frame = CGRectMake(15.0, 15.0, 14.0, 20.0);
        [goRightButton.layer addSublayer:weizhiLayer];
        
       UILabel * locationLabel = [ViewFactory addAlabelForAView:self withText:[_ballParkInfo valueForKey:@"address"] frame:CGRectMake(CGRectGetMaxX(weizhiLayer.frame)+10.0, 10, ScreenWidth-CGRectGetMaxX(weizhiLayer.frame)-45.0, 30.0) font:SYSTEM_FONT_S(15.0) textColor:UIColorFromRGB(0x6a6a6a)];
       [goRightButton addSubview:locationLabel];
        [locationLabel sizeToFit];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        
       UIImageView *  goRightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mycenter_jiantou"]];
        goRightArrow.frame = CGRectMake(ScreenWidth-27, 14.5, 12, 21);
        [goRightButton addSubview:goRightArrow];
        
    }
}

- (Baller_ImagePicker *)baller_ImagePicker
{
    if (!_baller_ImagePicker) {
        Baller_ImagePicker * baller_ImagePicker = [[Baller_ImagePicker alloc]init];
        _baller_ImagePicker = baller_ImagePicker;
        __BLOCKOBJ(blockSelf, self);
        __WEAKOBJ(weakSelf, self);
        __BLOCKOBJ(blockUpdateImageButton, updateImageButton)
        _baller_ImagePicker.baller_ImagePicker_ImageChosenBlock = (^(UIImage * image){
            
            [AFNHttpRequestOPManager postImageWithSubUrl:Baller_update_court_img parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"court_id":[weakSelf.ballParkInfo valueForKey:@"city_id"]} fileName:@"pic" fileData:UIImageJPEGRepresentation(image, 0.5) fileType:@"image/png" responseBlock:^(id result, NSError *error) {
                if (error) {
                    [Baller_HUDView bhud_showWithTitle:@"图片上传失败！"];
                    return ;
                }else if ([[result valueForKey:@"errorcode"] integerValue] == 0){
                    blockSelf.ballParkImageView.image = image;
                    if (NO == blockUpdateImageButton.hidden) {
                        blockUpdateImageButton.hidden = YES;
                    }
                }
            }];
            
        });
    }
    return _baller_ImagePicker;
}


/*!
 *  @brief  添加上传图片按钮
 */
- (void)addUpdateImageButton{
    updateImageButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth/4.0, self.frame.size.height-50-ScreenWidth/4.0, ScreenWidth/2.0, ScreenWidth/4.0) nomalTitle:@"点击上传" hlTitle:@"点击上传" titleColor:BALLER_CORLOR_696969 bgColor:nil nImage:nil hImage:nil action:@selector(updateImageButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    [self addSubview:updateImageButton];
    
    self.ballParkImageView.contentMode = UIViewContentModeCenter;
    updateImageButton.titleLabel.font = SYSTEM_FONT_S(NUMBER(35.0, 30.0, 25.0, 25.0));
    [self bringSubviewToFront:updateImageButton];
    updateImageButton.hidden = NO;
}


#pragma mark 按钮方法
/*!
 *  @brief  上传图片方法
 */
- (void)updateImageButtonAction{
    [[self baller_ImagePicker] showImageChoseAlertView];
}


- (void)goRightButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ballParkHeadView:mapButtonSelected:)]) {
        [self.delegate performSelector:@selector(ballParkHeadView:mapButtonSelected:) withObject:self withObject:nil];
    }
}

- (void)userButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ballParkHeadView:userButtonSelected:)]) {
        [self.delegate performSelector:@selector(ballParkHeadView:userButtonSelected:) withObject:self withObject:userButton];
    }
}

- (void)mapButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ballParkHeadView:mapButtonSelected:)]) {
        [self.delegate performSelector:@selector(ballParkHeadView:mapButtonSelected:) withObject:self withObject:mapButton];
    }
}

- (void)chatButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ballParkHeadView:chatButtonSelected:)]) {
        [self.delegate performSelector:@selector(ballParkHeadView:chatButtonSelected:) withObject:self withObject:chatButton];
    }}

- (void)calendarButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ballParkHeadView:calendarButtonSelected:)]) {
        [self.delegate performSelector:@selector(ballParkHeadView:calendarButtonSelected:) withObject:self withObject:calendarButton];
    }}

- (void)activitieButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ballParkHeadView:activitieButtonSelected:)]) {
        [self.delegate performSelector:@selector(ballParkHeadView:activitieButtonSelected:) withObject:self withObject:activitieButton];
    }}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImage *)screenShotOfView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(self.ballParkImageView.frame.size, YES, 0.0);
    [self drawViewHierarchyInRect:self.ballParkImageView.frame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)refreshBlurViewForNewImage
{
    UIImage * blurImage = [UIImage imageByApplyingBlurToImage:self.ballParkImageView.image withRadius:5 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1 maskImage:nil];
    self.ballParkBlurImageView.image = blurImage;
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    
    if (offset.y > 0)
    {
        self.ballParkBlurImageView.alpha =  fabs(4*offset.y / self.ballParkImageView.frame.size.height);
        self.ballParkImageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height-50.0);

    }else{
        self.ballParkBlurImageView.alpha =   0;
        self.ballParkImageView.frame = CGRectMake(offset.y/2.0, offset.y, ScreenWidth-offset.y/2.0, self.frame.size.height-50.0-offset.y);

    }
 
}

@end
