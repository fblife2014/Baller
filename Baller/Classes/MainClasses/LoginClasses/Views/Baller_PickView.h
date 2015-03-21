//
//  Baller_PickView.h
//  Baller
//
//  Created by malong on 15/2/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

//信息选择器视图

typedef void (^BallerPickedSelectedBlock)(NSObject * callBackString); //pickview选中后的回调

#import <UIKit/UIKit.h>

@interface Baller_PickView : UIView

@property (nonatomic,copy)NSArray * components; //数据源，数组的元素是数组

@property (nonatomic,copy)BallerPickedSelectedBlock selectedCallBack;

@property (nonatomic,strong)UIView * fatherView;  //当前视图的父视图

- (void)reloadData;

@end
