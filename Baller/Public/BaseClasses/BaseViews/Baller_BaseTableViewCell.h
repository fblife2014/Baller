//
//  Baller_BaseTableViewCell.h
//  Baller
//
//  Created by malong on 15/3/4.
//  Copyright (c) 2015年 malong. All rights reserved.
//

//cell的背景类型
typedef NS_ENUM(NSUInteger, BaseCellBackgroundType)
{
    BaseCellBackgroundTypeUpGrey = 0,       //顶部灰
    BaseCellBackgroundTypeUpWhite = 1,      //顶部白
    BaseCellBackgroundTypeMiddleGrey = 2,   //中间灰
    BaseCellBackgroundTypeMiddleWhite = 3,  //中间白
    BaseCellBackgroundTypeDownGrey = 4,     //底部灰
    BaseCellBackgroundTypeDownWhite = 5,    //底部白
    BaseCellBackgroundTypeOnlyOne = 6       //只有一个cell


};

#import <UIKit/UIKit.h>

@interface Baller_BaseTableViewCell : UITableViewCell

/*!
 *  @brief  cell的背景图片，用来区分灰、白背景。在不同行铺设不同的背景图，以让整个tableview看起来是条纹样式的
 */
@property (nonatomic,strong)UIImageView * backgroundImageView;

@property (nonatomic,assign)BaseCellBackgroundType backgroundType;

@end
