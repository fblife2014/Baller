//
//  UIView+ML_BlurView.m
//  BlurImageView
//
//  Created by malong on 15/1/13.
//  Copyright (c) 2015年 LanOu3g. All rights reserved.
//

/*!
 *  @brief  显示模糊效果
 *
 *  在iOS8以下，使用UIImageBlurEffectCategory这个类目
 *  iOS8开始，使用UIVisualEffect类簇
 *
 *  优缺点：1、UIImageBlurEffectCategory类簇相较于UIVisualEffect能实现的效果更多。可以通过设置高斯半径、渲染颜色、饱和度和遮罩图片来自定义效果，但耗用的内存要比UIVisualEffect多，且内存释放不如UIVisualEffect彻底。
 2、UIVisualEffect虽然实现的模糊效果有限，但算法和内存优化更好
 *
 */


#import "UIView+ML_BlurView.h"
#import "UIImageBlurEffectCategory.h"
#import <objc/runtime.h>

@interface UIView()

@end

@implementation UIView (ML_BlurView)

static char ML_BlurView_blurViewKey;

- (void)setBlurView:(UIView *)blurView{
    [self willChangeValueForKey:@"ML_BlurView_blurViewKey"];
    objc_setAssociatedObject(self, &ML_BlurView_blurViewKey, blurView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)blurView{
    return  objc_getAssociatedObject(self, &ML_BlurView_blurViewKey);
}

- (void)showBlurWithDuration:(NSTimeInterval)duration
                   blurStyle:(BlurStyle)blurStyle
                   belowView:(UIView *)belowView
{
    
    [self removeOldBlurEffectView];

    if (IOS8) {
        //创建模糊效果对象
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:(blurStyle == kUIBlurEffectStyleExtraLight)?UIBlurEffectStyleExtraLight:((blurStyle == kUIBlurEffectStyleLight)?UIBlurEffectStyleLight:UIBlurEffectStyleDark)];
        
        //根据模糊效果对象创建模糊视图
        UIVisualEffectView * blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        
        /*!
         *  @brief 设置模糊视图的frame，如果要添加约束，则注掉如下代码
         */
        //    blurEffectView.frame = self.bounds;
        
        //将模糊视图添加到当前视图上
        if (belowView) {
            [self insertSubview:blurEffectView belowSubview:belowView];

        }else{
            [self addSubview:blurEffectView];
        }
        self.blurView = blurEffectView;
        
        //创建活力效果
        UIVibrancyEffect * vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        //根据活力效果创建视觉效果图
        UIVisualEffectView * visualEffectView  = [[UIVisualEffectView alloc]initWithEffect:vibrancyEffect];
        //    visualEffectView.frame = blurEffectView.frame;
        
        //将视觉效果图添加到上一个模糊效果上，让模糊效果更有活力
        [blurEffectView.contentView addSubview:visualEffectView];
        
        /*!
         *  @brief  如果用约束来布局，而不设置frame,需做如下处理
         */
        [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];//加Autolayout
        [visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO]; //加Autolayout
        
        NSMutableArray * constraints = [NSMutableArray array];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [self addConstraints:constraints];
        
        
        /*!
         *  @brief  当duration不为零时，可让模糊视图在duration的时间内消失
         */
        if (duration > 0.000000) {
            blurEffectView.alpha = 0.0;
            [UIView animateWithDuration:duration animations:^{
                blurEffectView.alpha = 1.0;
            }completion:NULL];
        }

    }else if (IOS7){
        //如果系统为iOS8以下，使用UIImageBlurEffectCategory
        
        /*!
         根据当前视图内容，创建一个模糊视图，并添加到当前当前视图上。注意，当需要某些界面隐藏时，要先隐藏这些界面
         */
        
        UIImageView * aBlurImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.blurView = aBlurImageView;
        
        if (![self isKindOfClass:[UIImageView class]]) {
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
            [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
            UIImage * screenShot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            switch (blurStyle) {
                case kUIBlurEffectStyleExtraLight:
                    aBlurImageView.image = [UIImage imageByApplyingExtraLightEffectToImage:screenShot];
                    
                    break;
                case kUIBlurEffectStyleLight:
                    aBlurImageView.image = [UIImage imageByApplyingLightEffectToImage:screenShot];
                    
                    break;
                case kUIBlurEffectStyleDark:
                    aBlurImageView.image = [UIImage imageByApplyingDarkEffectToImage:screenShot];
                    
                    break;
                    
                default:
                    break;
            }
            
        }else{
            NSLog(@"image = %@",[self valueForKey:@"image"]);
            
            switch (blurStyle) {
                case kUIBlurEffectStyleExtraLight:
                    aBlurImageView.image = [UIImage imageByApplyingExtraLightEffectToImage:[self valueForKey:@"image"]];
                    
                    break;
                case kUIBlurEffectStyleLight:
                    aBlurImageView.image = [UIImage imageByApplyingLightEffectToImage:[self valueForKey:@"image"]];
                    
                    break;
                case kUIBlurEffectStyleDark:
                    aBlurImageView.image = [UIImage imageByApplyingDarkEffectToImage:[self valueForKey:@"image"]];
                    
                    break;
                    
                default:
                    break;
            }
            
        }
        
        [self addSubview:aBlurImageView];
        
        
        /*!
         *  @brief  当duration不为零时，可让模糊视图在duration的时间内消失
         */
        if (duration > 0.000000) {
            aBlurImageView.alpha = 0.0;
            [UIView transitionWithView:aBlurImageView duration:4.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                aBlurImageView.alpha = 1.0;
                
            } completion:NULL];
        }
        

    }
    

}

- (void)removeOldBlurEffectView{
    
    if (self.blurView) {
        [self.blurView removeFromSuperview];
    }
}

- (void)dismissOldBlurEffectViewWithDuration:(NSTimeInterval)duration{
    
    __WEAKOBJ(weakSelf, self);
    [UIView animateWithDuration:duration animations:^{
        weakSelf.blurView.alpha = 0.0;
    }completion:^(BOOL finished) {
        [weakSelf.blurView removeFromSuperview];
    }];
    
}

@end
