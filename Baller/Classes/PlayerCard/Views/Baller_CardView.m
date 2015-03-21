//
//  Baller_PlayerCardView.m
//  Baller
//
//  Created by malong on 15/1/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#define PCV_SegmentHeightRatio 0.138
#define PCV_BottomSegHeightRatio (258.0/1113.0)

#define ShareButtonWidth 63.0

#import "Baller_CardView.h"
#import "Baller_MyBallParkViewController.h"
#import "Baller_MyBasketballTeamViewController.h"
#import "Baller_AbilityView.h"
#import "Baller_AbilityEditorView.h"

#import "LShareSheetView.h"

@implementation Baller_CardView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = NO;
        self.scrollEnabled = YES;
        [self headImageButton];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
     playerCardType:(BallerCardType)ballerCardType{
    self = [self initWithFrame:frame];
    if (self) {
        if (ballerCardType <= kBallerCardType_MyPlayerCard ) {
            self.contentSize =CGSizeMake(frame.size.width, NUMBER(750.0, 680.0, 610, 610));
            [self pcv_SetupBackLayerWith:CGRectMake(0.0, 0.0, frame.size.width,  NUMBER(610, 580, 540,540))];
        }else if(ballerCardType == kBallerCardType_CreateBallPark){
            self.contentSize =CGSizeMake(frame.size.width, NUMBER(750.0, 680.0, 610, 610));
            [self pcv_SetupBackLayerWith:CGRectMake(0.0, 0.0, frame.size.width,  NUMBER(615, 550, 510,510))];
        }else if (ballerCardType == kBallerCardType_CreateBasketBallTeam){
            self.contentSize =CGSizeMake(frame.size.width, NUMBER(750.0, 680.0, 620, 620));
            [self pcv_SetupBackLayerWith:CGRectMake(0.0, 0.0, frame.size.width,  NUMBER(550, 525, 500,500))];

        }

        
        self.ballerCardType = ballerCardType;
        
        _nickNameLabel = [ViewFactory addAlabelForAView:self withText:[USER_DEFAULT valueForKey:Baller_UserInfo_Username] frame:CGRectMake(10.0, CGRectGetMaxY(_headImageButton.bounds)+TextFontSize/2.0, pathRect.size.width-20.0, 3*TextFontSize)font:SYSTEM_FONT_S(TextFontSize) textColor:[UIColor whiteColor]];
        
        whiteBottomlayer = [CALayer layer];
        [self.layer addSublayer:whiteBottomlayer];
        
        switch (ballerCardType) {
            case kBallerCardType_FirstBorn:
            case kBallerCardType_MyPlayerCard:

                [self addShareButton];
                whiteBottomlayer.frame = CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), pathRect.size.width, CGRectGetMaxY(backLayer.frame)-pathRect.size.width*PCV_BottomSegHeightRatio-CGRectGetMaxY(_nickNameLabel.frame));

                whiteBottomlayer.backgroundColor = BALLER_CORLOR_CELL.CGColor;
                [self addSubview: self.ballParkButton];
                [self addSubview: self.ballTeamButton];
                [self addLineAndAbility];
                [self addBottomSegments];
                
                break;
            case kBallerCardType_CreateBallPark:
            {
                self.createBallParkView = [[Baller_CreateBallParkView alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), self.frame.size.width, 4.5*PersonInfoCell_Height)];
                _nickNameLabel.text = [NSString stringWithFormat:@"由 %@ 创建",[USER_DEFAULT valueForKey:Baller_UserInfo_Username]];

                [self.bottomButton setTitle:@"创建球场" forState:UIControlStateNormal];
                [self addSubview:_createBallParkView];
            }
                break;
            case kBallerCardType_CreateBasketBallTeam:
            {
                _nickNameLabel.text = [NSString stringWithFormat:@"由 %@ 创建",[USER_DEFAULT valueForKey:Baller_UserInfo_Username]];

                self.createTeamView = [[[NSBundle mainBundle]loadNibNamed:@"Baller_CreateBasketBallTeamView" owner:self options:nil] lastObject];
                _createTeamView.frame = CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), self.frame.size.width, 285);
                [self.bottomButton setTitle:@"创建球队" forState:UIControlStateNormal];
                [self addSubview:_createTeamView];


            }
                break;
  
        }
        
    }
    return self;
}


#pragma mark  添加子视图
- (UIButton *)headImageButton
{
    if (!_headImageButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, HeadLayer_BorderWidth, 2*HeadLayer_CircleRadius-2*HeadLayer_BorderWidth, 2*HeadLayer_CircleRadius-2*HeadLayer_BorderWidth);
        button.center = CGPointMake(CGRectGetMidX(self.bounds), HeadLayer_CircleRadius);
        [button addTarget:self action:@selector(pcv_headImageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = HeadLayer_CircleRadius-HeadLayer_BorderWidth;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = CYAN_COLOR.CGColor;
        button.layer.borderWidth = 4.0;
       [self addSubview: _headImageButton = button];
    }
    return _headImageButton;
}

/*!
 *  @brief  背景
*/
- (void)pcv_SetupBackLayerWith:(CGRect)frame{
    
    pathRect = CGRectMake(0.0,HeadLayer_CircleRadius,frame.size.width,
                                 frame.size.height-HeadLayer_CircleRadius);
    
    
    CGPoint leftTop = CGPointMake(0.0,HeadLayer_CircleRadius+BackLayer_CornerRadius);
    CGPoint topLeft = CGPointMake(BackLayer_CornerRadius,HeadLayer_CircleRadius);
    CGPoint topRight = CGPointMake(frame.size.width-BackLayer_CornerRadius, HeadLayer_CircleRadius);
    CGPoint rightTop = CGPointMake(frame.size.width, HeadLayer_CircleRadius+BackLayer_CornerRadius);
    CGPoint rightBottom = CGPointMake(frame.size.width, frame.size.height-BackLayer_CornerRadius);
    CGPoint bottomRight = CGPointMake(frame.size.width-BackLayer_CornerRadius, frame.size.height);
    CGPoint bottomLeft = CGPointMake(BackLayer_CornerRadius,frame.size.height);
    CGPoint leftBottom = CGPointMake(0, frame.size.height-BackLayer_CornerRadius);
    CGPoint topCenter = CGPointMake(frame.size.width/2.0,HeadLayer_CircleRadius);
    
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:leftTop];
    [path addQuadCurveToPoint:topLeft controlPoint:CGPointMake(0.0, HeadLayer_CircleRadius)];
    [path addArcWithCenter:topCenter radius:HeadLayer_CircleRadius startAngle:M_PI endAngle:0 clockwise:NO];
    [path addLineToPoint:topRight];
    [path addQuadCurveToPoint:rightTop controlPoint:CGPointMake(frame.size.width, HeadLayer_CircleRadius)];
    [path addLineToPoint:rightBottom];
    [path addQuadCurveToPoint:bottomRight controlPoint:CGPointMake(frame.size.width, frame.size.height)];
    [path addLineToPoint:bottomLeft];
    [path addQuadCurveToPoint:leftBottom controlPoint:CGPointMake(0, frame.size.height)];
    [path addLineToPoint:leftTop];
    
    backLayer = [CAShapeLayer layer];
    backLayer.bounds = pathRect;
    backLayer.frame = CGRectMake(0.0, HeadLayer_CircleRadius, frame.size.width, frame.size.height-HeadLayer_CircleRadius);
    backLayer.path = path.CGPath;
    backLayer.fillColor = CYAN_COLOR.CGColor;
    backLayer.shadowColor = CYAN_COLOR.CGColor;
    backLayer.shadowOpacity = 0.5;
    backLayer.shadowOffset = CGSizeMake(0.5, 0.0);
    [self.layer addSublayer:backLayer];
    [self layoutIfNeeded];
}

- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, CGRectGetMaxY(pathRect)-PersonInfoCell_Height, self.frame.size.width, PersonInfoCell_Height);
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = DEFAULT_BOLDFONT(17.0);
        [button addTarget:self action:@selector(bottomButtonClicked) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview: _bottomButton = button];
    }
    return _bottomButton;
}


#pragma mark 首次生成我的球员卡状态视图
/*!
 *  @brief  分享按钮
 */
- (void)addShareButton{
    
    UIButton * shareButton = [ViewFactory getAButtonWithFrame:CGRectMake(pathRect.size.width-BackLayer_CornerRadius-ShareButtonWidth, pathRect.origin.y, ShareButtonWidth, ShareButtonWidth) nomalTitle:@"分享" hlTitle:@"分享" titleColor:[UIColor whiteColor] bgColor:CLEARCOLOR nImage:@"playerCard_share" hImage:@"playerCard_share" action:@selector(shareButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    shareButton.titleLabel.font = SYSTEM_FONT_S(13.0);
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10.0);
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 10, -1.0, -8.0);
    [self addSubview:shareButton];
    
}

- (UIButton *)ballParkButton
{
    if (!_ballParkButton) {
        NSLog(@"USER_DEFAULT = %@",[USER_DEFAULT valueForKey:@"court_id"]);
        NSString * ballParkString = [[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"court_id"] integerValue]?@"我的球场":@"未加入球场";
        ballParkButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), pathRect.size.width/2.0, pathRect.size.width*PCV_SegmentHeightRatio) nomalTitle:ballParkString hlTitle:ballParkString titleColor:BALLER_CORLOR_696969 bgColor:nil nImage:@"homeCourt" hImage:@"homeCourt" action:@selector(ballParkButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        ballParkButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -10, 0.0, 10.0);
        ballParkButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, -1.0, 0.0);

        ballParkButton.titleLabel.font = SYSTEM_FONT_S(15.0);
        _ballParkButton = ballParkButton;
    }
    return _ballParkButton;
}


/*!
 *  @brief 我的球队
*/
- (UIButton *)ballTeamButton
{
    if (!_ballTeamButton) {
        NSLog(@"ddd = %@",[USER_DEFAULT valueForKey:Baller_UserInfo]);
        
        NSString * ballTeamString = [[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"team_id"] integerValue]?@"我的球队":@"未加入球队";
        UIButton * ballTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(pathRect.size.width/2.0, CGRectGetMaxY(_nickNameLabel.frame), pathRect.size.width/2.0, pathRect.size.width*PCV_SegmentHeightRatio) nomalTitle:ballTeamString hlTitle:ballTeamString titleColor:BALLER_CORLOR_696969 bgColor:nil nImage:@"ballTeam" hImage:@"ballTeam" action:@selector(ballTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        ballTeamButton.titleLabel.font = SYSTEM_FONT_S(15.0);
        ballTeamButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 10.0, -1.0, -10.0);

        _ballTeamButton = ballTeamButton;
        
    }
    return _ballTeamButton;
}

/*!
 *  @brief  添加分割线
 */
- (void)addLineAndAbility{
    
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(CGRectGetMidX(pathRect)-1, CGRectGetMidY(_ballParkButton.frame)-19.0/2.0, 0.5, 19.0) layerColor:UIColorFromRGB(0Xc6cacd)];
    
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(CGRectGetMidX(pathRect)+1, CGRectGetMidY(_ballParkButton.frame)-27.0/2.0, 0.5, 27.0) layerColor:[UIColor whiteColor]];
    
   CALayer * line = [ViewFactory addLayerToView:self.layer frame:CGRectMake(0.0, CGRectGetMaxY(_ballParkButton.frame)-0.5,pathRect.size.width, 0.5) layerColor:UIColorFromRGB(0Xc6cacd)];
    
    abilityView = [[[NSBundle mainBundle] loadNibNamed:@"AbilityView" owner:self options:nil] lastObject];
    abilityView.frame = CGRectMake(0.0, CGRectGetMaxY(line.frame), self.frame.size.width,288.0);
    [self addSubview:abilityView];

    
}

- (void)setAbilityDetails:(NSArray *)abilityDetails{
    if (_abilityDetails == abilityDetails) {
        return;
    }
    _abilityDetails = abilityDetails;
    Baller_AbilityEditorView * abilityEditorView = [[Baller_AbilityEditorView alloc]initWithFrame:CGRectMake(0.0, 0.0, 154.0, 158.0)];
    abilityEditorView.center = CGPointMake(abilityView.frame.size.width/2.0, abilityView.frame.size.height/2.0-5.0);
    abilityEditorView.abilities = abilityDetails;
    [abilityView addSubview:abilityEditorView];
}



/*!
 *  @brief  底部三个参数选项
 */
- (void)addBottomSegments{
    NSArray * images = @[[UIImage imageNamed:@"playerCard_height"],[UIImage imageNamed:@"playerCard_weight"],[UIImage imageNamed:@"position"]];
    

    NSArray * parameters = @[$str(@"%@ cm",[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"height"]),$str(@"%@ kg",[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"weight"]),$str(@"%@",[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"position"])];
    
    for (int i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:images[i]];
        imageView.frame = CGRectMake(pathRect.origin.x+i*1.0/3.0*pathRect.size.width, CGRectGetMaxY(whiteBottomlayer.frame)+TextFontSize, pathRect.size.width/3.0, imageView.image.size.height);
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
        [ViewFactory addAlabelForAView:self withText:parameters[i] frame:CGRectMake(pathRect.origin.x+i*1.0/3.0*pathRect.size.width, CGRectGetMaxY(imageView.frame), pathRect.size.width/3.0, BackLayer_CornerRadius) font:SYSTEM_FONT_S(TextFontSize) textColor:[UIColor whiteColor]];
    }
    
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(pathRect.origin.x + pathRect.size.width/3.0-0.5, CGRectGetMaxY(whiteBottomlayer.frame)+TextFontSize+2.0, 0.5, pathRect.size.width*PCV_SegmentHeightRatio) layerColor:UIColorFromRGB(0X8c949f)];
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(pathRect.origin.x = 2*pathRect.size.width/3.0-0.5, CGRectGetMaxY(whiteBottomlayer.frame)+TextFontSize+2.0, 0.5, pathRect.size.width*PCV_SegmentHeightRatio) layerColor:UIColorFromRGB(0X8c949f)];



}

#pragma mark 点击方法
/*!
 *  @brief 头像点击方法
 */
- (void)pcv_headImageButtonClicked{
    switch (_ballerCardType) {
        case kBallerCardType_FirstBorn:
            
            break;
        case kBallerCardType_MyPlayerCard:
            
            break;
        case kBallerCardType_CreateBallPark:
            
            break;
        case kBallerCardType_CreateBasketBallTeam:
            break;
    }
    
}

/*!
 *  @brief  分享按钮方法
 */
- (void)shareButtonAction{
    
    NSString *share_content = @"baller分享内容";
    NSString *share_title = @"baller分享的标题";
    NSString *share_link_url = @"http://www.baidu.com";
    UIImage *share_image = [ImageFactory saveImageFromView:self];
    
    [[LShareSheetView shareInstance] showShareContent:share_content title:share_title shareUrl:share_link_url shareImage:share_image targetViewController:nil];
    [[LShareSheetView shareInstance]actionBlock:^(NSInteger buttonIndex, Share_Type shareType) {
        
        if (shareType == Share_QQ) {
            
            NSLog(@"Share_QQ");
            
        }else if (shareType == Share_QQZone){
            
            NSLog(@"Share_QQZone");
            
        }else if (shareType == Share_WeiBo){
            
            NSLog(@"Share_WeiBo");
            
        }else if (shareType == Share_WX_HaoYou){
            
            NSLog(@"Share_WX_HaoYou");
            
        }else if (shareType == Share_WX_PengYouQuan){
            
            NSLog(@"Share_WX_PengYouQuan");
            
        }
                
    }];
    
    [[LShareSheetView shareInstance]shareResult:^(Share_Result result, Share_Type type) {
        
        if (result == Share_Success) {
            
           [LTools showMBProgressWithText:@"分享成功" addToView:self];
        }else
        {
            NSLog(@"分享失败");
        }
        
    }];
}

/*!
 *  @brief  我的球场按钮方法
 */
- (void)ballParkButtonAction{
    Baller_MyBallParkViewController * ballParkVC = [[Baller_MyBallParkViewController alloc]init];
    ballParkVC ->soureVC = @"2";
    [[[MLViewConrollerManager sharedVCMInstance]rootViewController].navigationController pushViewController:ballParkVC animated:YES];
}

/*!
 *  @brief  我的球队按钮方法
 */
- (void)ballTeamButtonAction
{
    Baller_MyBasketballTeamViewController * ballTeamVC = [[Baller_MyBasketballTeamViewController alloc]init];
    [[[MLViewConrollerManager sharedVCMInstance]rootViewController].navigationController pushViewController:ballTeamVC animated:YES];

}

/*!
 *  @brief   底部按钮点击回调方法
 */
- (void)bottomButtonClicked{
    
    if (_bottomButtonClickedBlock) {
        self.bottomButtonClickedBlock(_ballerCardType);
    }
}

#pragma  mark 计算

/*!
 *  @brief  获取能力区分图六边形顶点坐标
 *
 *  @param abilityLayer 能力底图
 *
 *  @return 存放点值的数组
 */
- (NSMutableArray * )sixPointsOfAbilityLayer:(CALayer *)abilityLayer{
    
    NSMutableArray * points = $marrnew;
    
    CGPoint topPoint = CGPointMake(CGRectGetMidX(pathRect)-NUMBER(19.0, 19.0, 12.0, 19.0), CGRectGetMinY(abilityLayer.frame)-NUMBER(38.0, 38.0, 28.0, 38.0));
    [points addObject:[NSValue valueWithCGPoint:topPoint]];
    
    CGPoint rightTopPoint = CGPointMake(CGRectGetMaxX(abilityLayer.frame)-NUMBER(13.0, 10.0, 10.0, 10.0), CGRectGetMinY(abilityLayer.frame)+CGRectGetHeight(abilityLayer.bounds)/6.0-NUMBER(10.0, 10.0, 10.0, 10.0));
    [points addObject:[NSValue valueWithCGPoint:rightTopPoint]];
    
    CGPoint rightBottomPoint = CGPointMake(CGRectGetMaxX(abilityLayer.frame)-NUMBER(10.0, 10.0, 10.0, 10.0), CGRectGetMinY(abilityLayer.frame)+2*CGRectGetHeight(abilityLayer.bounds)/3.0);
    [points addObject:[NSValue valueWithCGPoint:rightBottomPoint]];
    
    CGPoint bottomPoint = CGPointMake(CGRectGetMidX(pathRect)-NUMBER(10.0, 10.0, 10.0, 10.0), CGRectGetMaxY(abilityLayer.frame)-NUMBER(2.0, 2.0, 2.0, 2.0));
    [points addObject:[NSValue valueWithCGPoint:bottomPoint]];
    
    CGPoint leftBottomPoint = CGPointMake(CGRectGetMinX(abilityLayer.frame)-NUMBER(28.0, 28.0, 20.0, 28.0), CGRectGetMinY(abilityLayer.frame)+2*CGRectGetHeight(abilityLayer.bounds)/3.0-NUMBER(3.0, 3.0, 3.0, 3.0));
    [points addObject:[NSValue valueWithCGPoint:leftBottomPoint]];
    
    CGPoint leftTopPoint = CGPointMake(CGRectGetMinX(abilityLayer.frame)-NUMBER(28.0, 28.0, 20.0, 28.0), CGRectGetMinY(abilityLayer.frame)+CGRectGetHeight(abilityLayer.bounds)/6.0-NUMBER(15.0, 15.0, 8.0, 15.0));
    [points addObject:[NSValue valueWithCGPoint:leftTopPoint]];
    
    return points;
}

- (NSMutableArray * )sixPointsOfAbilityContentLayer:(CALayer *)abilityLayer contentRatios:(NSArray *)ratios{
 
    NSMutableArray * abilityContenLayerPoints = $marrnew;

    return abilityContenLayerPoints;
}


#pragma mark 创建球场模式状态视图

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

@end
