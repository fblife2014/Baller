//
//  Baller_PersonalInfoView.m
//  Baller
//
//  Created by malong on 15/1/16.
//  Copyright (c) 2015年 malong. All rights reserved.
//

# define ItemView_TagOrigin 1000 //输入框起始tag值

#import "Baller_PersonalInfoView.h"
#import "Baller_WhitePlaceholder.h"
#import "Baller_InfoItemView.h"
#import "Baller_ImagePicker.h"
#import "Baller_PickView.h"
#import "UIButton+AFNetworking.h"

@interface Baller_PersonalInfoView()<UITextFieldDelegate>
{
    CAShapeLayer * backLayer; //背景层
    Baller_WhitePlaceholder * _nikeNameTextField;
    Baller_ImagePicker * _baller_ImagePicker;
    
    NSMutableArray * _infoItemViews;         //信息条目数组
    
    NSMutableArray * heights;  //身高
    NSMutableArray * weidghts; //体重
    NSMutableArray * positions;//位置
    NSMutableArray * sexs;     //性别
    
}

@property (nonatomic,strong)Baller_PickView * ballerPickerView; //个人信息选择视图

@end

@implementation Baller_PersonalInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.exclusiveTouch = YES;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height+NUMBER(20.0, 20.0, 30.0, 60.0));
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = NO;
        [self setupBackLayerWith:frame];
        [self headImageButton];
        [self nikeNameTextField];
        [self doneButton];
    }
    return self;
}

- (UIButton *)headImageButton
{
    if (!_headImageButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, HeadLayer_BorderWidth, 2*HeadLayer_CircleRadius-2*HeadLayer_BorderWidth, 2*HeadLayer_CircleRadius-2*HeadLayer_BorderWidth);
        button.center = CGPointMake(CGRectGetMidX(self.bounds), HeadLayer_CircleRadius);
        [button setTitleColor:BALLER_CORLOR_696969 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(headImageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = DEFAULT_BOLDFONT(17.0);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = HeadLayer_CircleRadius-HeadLayer_BorderWidth;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = CYAN_COLOR.CGColor;
        button.layer.borderWidth = 4.0;
        
        
        //加载头像
        if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]) {
            [button setImage:[UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]] forState:UIControlStateNormal];
        }else{
            __WEAKOBJ(weakButton, button)
            [button setImageForState:UIControlStateNormal withURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImage]]] placeholderImage:[UIImage imageNamed:@"manHead"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                [USER_DEFAULT setValue:UIImageJPEGRepresentation(image, 1) forKey:Baller_UserInfo_HeadImageData];
                
            } failure:^(NSError *error) {
                [weakButton setTitle:NSLocalizedString(@"SubmitHeadImage", nil) forState:UIControlStateNormal];
                
            }];
            
        }
        


       [self addSubview: _headImageButton = button];
    }
    return _headImageButton;
}

- (Baller_WhitePlaceholder *)nikeNameTextField
{
    if (!_nikeNameTextField) {
        _nikeNameTextField = [Baller_WhitePlaceholder new];
        _nikeNameTextField.frame = CGRectMake(0.0, CGRectGetMaxY(_headImageButton.bounds)+TextFontSize, 2*CGRectGetWidth(_headImageButton.bounds), 31.0);
        _nikeNameTextField.center = CGPointMake(_headImageButton.center.x,  CGRectGetMaxY(_headImageButton.bounds)+2*TextFontSize);
        _nikeNameTextField.backgroundColor = CLEARCOLOR;
        _nikeNameTextField.placeholder = NSLocalizedString(@"ClickInputNickname", nil);
        _nikeNameTextField.textColor = [UIColor whiteColor];
        _nikeNameTextField.font = SYSTEM_FONT_S(TextFontSize);
        _nikeNameTextField.textAlignment = NSTextAlignmentCenter;
        _nikeNameTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _nikeNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_nikeNameTextField];
        _nikeNameTextField.text = [USER_DEFAULT valueForKey:Baller_UserInfo_Username];
    }
    return _nikeNameTextField;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString * title = [USER_DEFAULT valueForKey:Baller_UserInfo_Username];
        [button setTitle:NSLocalizedString(title?@"Save":@"Done", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doneButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, self.frame.size.height-PersonInfoCell_Height,self.frame.size.width, PersonInfoCell_Height);
        button.titleLabel.font = DEFAULT_BOLDFONT(17.0);
       [self addSubview:_doneButton = button];
    }
    return _doneButton;
}


- (void)setupBackLayerWith:(CGRect)frame{
    
    CGRect pathRect = CGRectMake(0.0,HeadLayer_CircleRadius,frame.size.width,
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
}

- (NSMutableArray *)infoItemViews
{
    if (!_infoItemViews) {
        _infoItemViews = [NSMutableArray new];
    }
    return _infoItemViews;
}

/*!
 *  @brief  添加表格
 *
 *  @param titles       标题
 *  @param placeHolders 输入框占位标签
 *  @param infoDetails  输入框内容
 *  @param canEdited    输入框是否可编辑
 *  @param originY      起始Y坐标
 */
- (void)addPersonInfoViewWithTitles:(NSArray *)titles
                       placeHolders:(NSArray *)placeHolders
                        infoDetails:(NSArray *)infoDetails
                          canEdited:(BOOL)canEdited
                            originY:(CGFloat)originY
                       circleRadius:(CGFloat)circleRadius;

{
    [self infoItemViews];
    for (int i = 0; i < titles.count; i++)
    {
        @autoreleasepool {
            Baller_InfoItemView * itemView = [[Baller_InfoItemView alloc]initWithFrame:CGRectMake(0.0, originY+PersonInfoCell_Height*i, self.frame.size.width, PersonInfoCell_Height) title:(titles.count>i)?titles[i]:nil placeHolder:(placeHolders.count>i)?placeHolders[i]:nil];
            
            itemView.infoTextField.text = (infoDetails.count>i)?infoDetails[i]:nil;
            itemView.infoCanEdited = canEdited;
            itemView.grayCircleLayerRadius = circleRadius;
            itemView.infoTextField.tag = ItemView_TagOrigin+i;
            [itemView.infoTextField addTarget:self action:@selector(editingDicBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
            itemView.infoTextField.delegate = self;
            if (i%2)
            {
                itemView.backgroundColor = BALLER_CORLOR_CELL;
            }
            [_infoItemViews addObject:itemView];
            [self addSubview:itemView];
        }
    }
}

- (Baller_ImagePicker *)baller_ImagePicker
{
    if (!_baller_ImagePicker) {
        Baller_ImagePicker * baller_ImagePicker = [[Baller_ImagePicker alloc]init];
        _baller_ImagePicker = baller_ImagePicker;
        __BLOCKOBJ(blockHeadImageButton, _headImageButton);

        _baller_ImagePicker.baller_ImagePicker_ImageChosenBlock = (^(UIImage * headImage){
            [blockHeadImageButton setImage:headImage forState:UIControlStateNormal];
            [(BaseViewController *)[[MLViewConrollerManager sharedVCMInstance] rootViewController] showBlurBackImageViewWithImage:headImage belowView:nil];

            [AFNHttpRequestOPManager postImageWithSubUrl:Baller_update_user_photo parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]} fileName:nil fileData:UIImageJPEGRepresentation(headImage, 0.5) fileType:nil responseBlock:^(id result, NSError *error) {
                if (error) {
                    
                }else{
                    if([[result valueForKey:@"errorcode"] intValue] == 0){
                        [USER_DEFAULT setValue:[result valueForKey:@"photo"] forKey:Baller_UserInfo_HeadImage];
                        [USER_DEFAULT setValue:UIImageJPEGRepresentation(headImage, 0.5) forKey:Baller_UserInfo_HeadImageData];
                        [USER_DEFAULT synchronize];

                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:BallerUpdateHeadImageNotification object:nil];
                }
            }];
        });
    }
    return _baller_ImagePicker;
}

- (Baller_PickView *)ballerPickerView
{
    if (!_ballerPickerView) {
        _ballerPickerView = [[Baller_PickView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight)];
        heights = [NSMutableArray array];
        for (int i = 155; i < 210; i++) {
            [heights addObject:[NSString stringWithFormat:@"%d cm",i]];
        }
        
        weidghts = [NSMutableArray array];
        for (int i = 50; i < 100; i++) {
            [weidghts addObject:[NSString stringWithFormat:@"%d kg",i]];
        }
        
        positions = [NSMutableArray arrayWithObjects:@"C",@"PG",@"PF",@"SF",@"SG", nil];
        sexs = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
      
    }
    return _ballerPickerView;
}


#pragma mark selectors
/*!
 *  @brief 头像点击方法
*/
- (void)headImageButtonClicked
{
    [self.baller_ImagePicker showImageChoseAlertView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.4 animations:^{
        self.contentOffset = CGPointMake(0.0,0.0);
    }];
    
    [self endEditing:YES];
}

- (void)doneButtonClickedAction{
    [self endEditing:YES];
    self.doneButtonClickedBlock([self savePersonalInfo]);
}

- (NSDictionary *)savePersonalInfo
{
    NSMutableDictionary * personInfoDic = [NSMutableDictionary dictionaryWithCapacity:6];
    [personInfoDic setValue:_nikeNameTextField.text forKey:@"user_name"];
    [personInfoDic setValue:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode] forKey:@"authcode"];
    [USER_DEFAULT setValue:_nikeNameTextField.text forKey:Baller_UserInfo_Username];
    
    for (int i = 0; i < _infoItemViews.count; i++) {
        Baller_InfoItemView * infoItemView = (Baller_InfoItemView*)_infoItemViews[i];
        NSString * info = infoItemView.infoTextField.text?:@"";
        switch (infoItemView.infoTextField.tag) {
            case 1000:
                [USER_DEFAULT setValue:info forKey:Baller_UserInfo_Height];
                [personInfoDic setValue:info forKey:@"height"];

                break;
            case 1001:
                [USER_DEFAULT setValue:info forKey:Baller_UserInfo_Weight];
                [personInfoDic setValue:info forKey:@"weight"];

                break;
            case 1002:
                [USER_DEFAULT setValue:info forKey:Baller_UserInfo_Position];
                [personInfoDic setValue:info forKey:@"position"];
                break;
            case 1003:
                [USER_DEFAULT setValue:info forKey:Baller_UserInfo_Sex];
                [personInfoDic setValue:[info isEqualToString:@"男"]?@"1":@"2" forKey:@"gender"];

                break;
            default:
                break;
        }

    }
    [USER_DEFAULT synchronize];
    
    return personInfoDic;
}


/*!
 *  @brief  输入框已开始编辑
 *
 *  @param textField 当前编辑的输入框
 */
- (void)editingDicBeginAction:(UITextField *)textField{
    NSLog(@"location = %@",[NSValue valueWithCGPoint:textField.superview.center]);
    CGPoint superViewCenter = textField.superview.center;
    if (ScreenHeight - superViewCenter.y -self.frame.origin.y < 350.0) {
        [UIView animateWithDuration:0.4 animations:^{
        self.contentOffset = CGPointMake(0.0,350.0+superViewCenter.y+self.frame.origin.y-ScreenHeight);
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.contentOffset = CGPointMake(0.0,0.0);
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 1000:
            self.ballerPickerView.components = heights;
            break;
        case 1001:
            self.ballerPickerView.components = weidghts;
            break;
        case 1002:
            self.ballerPickerView.components = positions;

            break;
        case 1003:
            self.ballerPickerView.components = sexs;

            break;
        default:
            break;
    }
    [self.ballerPickerView reloadData];
    __BLOCKOBJ(blockTF, textField);
    _ballerPickerView.selectedCallBack = ^(NSObject * callBackObj){
        blockTF.text = (NSString *)callBackObj;
    };
    
    self.ballerPickerView.fatherView = MAINWINDOW;
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
