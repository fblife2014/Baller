//
//  Baller_AbilityEditorView.h
//  Baller
//
//  Created by malong on 15/2/26.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef void (^DetailButtonClicked)();

#import <UIKit/UIKit.h>

@interface Baller_AbilityEditorView : UIView
{
    NSArray * layerColors;
}

/*!
 *  @brief 能力参数比例数组,按顺时针依次为投篮、助攻、篮板、抢断、封盖、突破
 */
@property (nonatomic,copy)NSArray * abilities;

@property (nonatomic,strong)UIButton * detailButton; //展示说明按钮

@property (nonatomic,strong)CAShapeLayer * abilityDetailLayer; //能力详情层

@end
