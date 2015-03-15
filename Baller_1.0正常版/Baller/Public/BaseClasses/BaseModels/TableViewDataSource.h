//
//  TableViewDataSource.h
//  Kr_Demo
//
//  Created by malong on 15/1/27.
//  Copyright (c) 2015年 LanOu3g. All rights reserved.
//

typedef void (^TableViewCellConfigureBlock)(id cell, id item); //cell的设置block

#import <Foundation/Foundation.h>

@interface TableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy)NSString * cellIdentifier; //cell的标示

@property (nonatomic, strong)NSArray * items;

@property (nonatomic, copy)TableViewCellConfigureBlock  tableViewCellConfigureBlock;

/*!
 *  @brief  根据相关属性值初始化
 *
 *  @param items          数据源
 *  @param cellIdentifier cell重用标示
 *  @param block          cell的设置block
 *
 *  @return 当前类的一个实例对象
 */
- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
tableViewConfigureBlock:(TableViewCellConfigureBlock)block;

/*!
 *  @brief 返回indexpath处所对应的数据
 *
 *  @param indexPath cell的坐标
 *
 *  @return 
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
