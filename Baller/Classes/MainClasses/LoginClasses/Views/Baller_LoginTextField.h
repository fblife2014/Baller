//
//  Baller_LoginTextField.h
//  Baller
//
//  Created by malong on 15/2/26.
//  Copyright (c) 2015年 malong. All rights reserved.
//
/*!
 *  @brief  登录视图控件中的自定义输入框控件
 */
#import <UIKit/UIKit.h>

@interface Baller_LoginTextField : UITextField
@property (nonatomic,assign)BOOL rightButtonAllwaysShow; //是否一直显示
@property (nonatomic,assign)BOOL rightButtonAllwaysHide; //是否一直隐藏

/*!
 *  @brief  显示右侧按钮，并给按钮添加方法和标题
 *
 *  @param target
 *  @param selector
 *  @param buttonTitle
 */
- (void)showRightButtonWithTarget:(id)target
                           action:(SEL)selector
                            title:(NSString *)buttonTitle;

/*!
 *  @brief  启动倒计时，60秒开始
 */
- (void)showCountdown;

/*!
 *  @brief  停止倒计时
 */
- (void)stopTimer;


@end


