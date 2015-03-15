//
//  BaseViewController.h
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,strong) id pushInfo;    //推到下级界面时携带的数据
@property (nonatomic)NSInteger page;         //页码
@property (nonatomic, weak) UIImageView * blurBackImageView;
@property (nonatomic, weak) UIScrollView * bottomScrollView; //底部可滑动视图


/*!
 *  @brief  显示模糊背景
 *
 *  @param image 模糊背景视图
 */
- (void)showBlurBackImageViewWithImage:(UIImage *)image;


/*!
 *  @brief  移除模糊视图
 */
- (void)removeOldBlurView;

/*!
 *  @brief  返回上级控制器
 */
- (void)PopToLastViewController;


/*!
 *  @brief  返回根控制器
 */
- (void)PopToRootViewController;

@end
