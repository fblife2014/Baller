//
//  Baller_BallParkHeadImageView.h
//  Baller
//
//  Created by malong on 15/1/23.
//  Copyright (c) 2015年 malong. All rights reserved.
//

/*!
 *  @brief  篮球场主页顶部主页图
 */
@class Baller_BallParkListModel;
@class Baller_BallParkHeadView;

/*!
 *  @brief  当前视图中按钮点击后的代理方法
 */
@protocol Baller_BallParkHeadViewDelegate <NSObject>

@optional

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView userButtonSelected:(UIButton *)userButton;

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView mapButtonSelected:(UIButton *)mapButton;

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView dateButtonSelected:(UIButton *)dateButton;

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView chatButtonSelected:(UIButton *)chatButton;

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView calendarButtonSelected:(UIButton *)calendarButton;

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView activitieButtonSelected:(UIButton *)activitieButton;



@end

#import <UIKit/UIKit.h>
@class Baller_ImagePicker;

@interface Baller_BallParkHeadView : UIView
{
    
//未验证的系列视图
    UIButton * goRightButton; //底部位置按钮，点击进入地图详情
    
//球场尚无图片时，可上传图片
    Baller_ImagePicker * _baller_ImagePicker;
    UIButton * updateImageButton; //上传图片按钮
    
//通过验证了的系列视图
    UIButton * userButton;     //用户头像按钮
    UIButton * mapButton;      //地图按钮
    UIButton * chatButton;     //聊天按钮
    UIButton * calendarButton; //日历按钮
    UIButton * activitieButton;//发起活动按钮
    
}

@property (nonatomic,strong)NSDate * currentDate;

@property (nonatomic,copy)NSString * dateString;

@property (nonatomic,strong)NSDictionary * ballParkInfo;

@property (nonatomic,strong)UIImageView * ballParkImageView; //球场图片

@property (nonatomic)BOOL hasIdentified; //是否已经认证过

@property (nonatomic,assign)id <Baller_BallParkHeadViewDelegate> delegate;


@end
