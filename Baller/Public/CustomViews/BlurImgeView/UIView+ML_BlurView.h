//
//  UIView+ML_BlurView.h
//  BlurImageView
//
//  Created by malong on 15/1/13.
//  Copyright (c) 2015年 LanOu3g. All rights reserved.
//

/*!
 一、高斯模糊
 1、以高斯半径计算像素中心点的平均像素值，半径越大，模糊效果越突出，同时处理图像时算法消耗的CPU越大，内存消耗自然也越多，对程序运行的流畅性带来负面影响，所以要谨慎使用模糊效果。
 2、模糊效果活用了人的视觉焦点原理。为的是更方便用户找到交互上的焦点，但过度使用模糊效果除了影响App性能，还有可能给用户带来困扰，影响用户体验。所以不能单纯为了好看而使用模糊效果
 参见 iOS Human Interface Guidelines
 和延亮分享的iOS_8_by_Tutorials PDF第26章
 二、相关知识
 1、iOS7之后，苹果利用Accelerate.framework框架简化向量和矩阵计算，并对图像处理做优化。
 
 2、swift截屏代码
 func updateBlur(){
 //1 将不需要的视图隐藏
 optionsContainerView.hidden = true;
 
 //2 启动截屏上下文，并设置尺寸、是否透明和比例
 UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1);
 
 //3按某个视图的边框分层绘制，并等视图更新后操作
 self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true);
 
 //4获取当前上下文中绘制的图片
 let screenShot:UIImage = UIGraphicsGetImageFromCurrentImageContext();
 
 //5 结束当前绘图上下文
 UIGraphicsEndImageContext();
 
 }
 
 3、iOS8 ：UIBlurEffect UIVisualEffectView UIVibrancyEffect
 模糊效果；  视觉效果视图；  活力效果
 给一个UIVisualEffectView对象添加UIVibrancyEffect效果，必须在这个对象添加完UIBlurEffect之后，否者无效。
 UIView *optionsView = [[[UINib nibWithNibName:@"OptionsView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
 self.scrollView.scrollsToTop = NO;
 [self.view addSubview:optionsView];
 
 UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
 UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
 [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
 [self.view insertSubview:blurView atIndex:0];
 
 UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
 UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
 [vibrancyView setTranslatesAutoresizingMaskIntoConstraints:NO];
 [vibrancyView.contentView addSubview:optionsView];
 [blurView.contentView addSubview:vibrancyView];
 
 4、添加 UIVibrancyEffect后，page control 会失效，这是apple的bug
 5、手动模糊技术（manual blur technique ）依赖于静态图片库，所以不能做动画或实时有效的更新模糊效果。然而UIBlurEffect，可以实时更新模糊效果，所以你可以用这些效果实现各种新奇精彩的东西，如动画等
 
 */


/*!
 模糊效果选项
 */
typedef enum {
    kUIBlurEffectStyleExtraLight = 0,
    kUIBlurEffectStyleLight,
    kUIBlurEffectStyleDark
}BlurStyle;

#import <UIKit/UIKit.h>

@interface UIView (ML_BlurView)

@property(nonatomic,strong)UIView * blurView;

/*!
 *  @brief  显示模糊效果
 *
 *  @param duration  模糊消失时间，为0时不消失
 *  @param blurStyle 模糊效果类型
 *  @param hidenViews 需要隐藏的界面
 */
- (void)showBlurWithDuration:(NSTimeInterval)duration
                   blurStyle:(BlurStyle)blurStyle
                   belowView:(UIView *)belowView;

/*!
 *  @brief  直接移除上个模糊效果视图
 */
- (void)removeOldBlurEffectView;

/*!
 *  @brief  在一定时间内移除背景视图
 *
 *  @param duration 需要的时间
 */
- (void)dismissOldBlurEffectViewWithDuration:(NSTimeInterval)duration;

@end
