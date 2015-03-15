//
//  Baller_PersonalInfoView.h
//  Baller
//
//  Created by malong on 15/1/16.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef void (^DoneButtonClickedBlock)(NSDictionary * personalInfo);

#import <UIKit/UIKit.h>
@class Baller_WhitePlaceholder;
@class Baller_ImagePicker;

@interface Baller_PersonalInfoView : UIScrollView

@property (nonatomic, strong)UIButton * headImageButton;
@property (nonatomic, strong)UIButton * doneButton;

@property (nonatomic, copy) DoneButtonClickedBlock  doneButtonClickedBlock;
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


@end
