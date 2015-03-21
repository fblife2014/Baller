//
//  Baller_CreateBallParkView.h
//  Baller
//
//  Created by malong on 15/1/24.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef void (^Baller_CreateBallParkViewAnnotionButtonClicked)(BOOL autoAnnotion); //自动或手动获取球场位置按钮选中哪个。yes为自动，no为手动
/*!
 *  @brief  创建球场的内容视图
 */
#import <UIKit/UIKit.h>
@class Baller_ImagePicker;

@interface Baller_CreateBallParkView : UIView
{
    UIImageView * ballParkImageView;
    NSMutableDictionary * ballParkInfos; //球场信息字典
    Baller_ImagePicker * _baller_ImagePicker;
}

@property (nonatomic,copy)Baller_CreateBallParkViewAnnotionButtonClicked autoAnnotion;

@end
