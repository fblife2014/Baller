//
//  Baller_PersonInfoItemView.h
//  Baller
//
//  Created by malong on 15/1/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//

/*!
 *  @brief  信息条目图
 */

#import <UIKit/UIKit.h>

@interface Baller_InfoItemView : UIView
{
    __weak CALayer * _grayCircleLayer;          //灰圆
    
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        placeHolder:(NSString *)placeHolder;


@property (nonatomic) CGFloat grayCircleLayerRadius;  //左边灰圆半径
@property (nonatomic) BOOL infoCanEdited;             //信息是否可被编辑
@property (nonatomic, strong)UILabel * titleLabel; //左侧标题标签
@property (nonatomic) CGFloat titleLabelHorizontalScale; //左侧标签水平方向占当前视图宽度的比例

@property (nonatomic, strong)UITextField * infoTextField;        //信息编辑框
@property (nonatomic) CGFloat infoTextFieldHorizontalScale; //输入框水平方向占当前视图宽度的比例

@end
