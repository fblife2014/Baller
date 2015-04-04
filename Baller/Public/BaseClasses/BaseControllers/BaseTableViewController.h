//
//  BaseTableViewController.h
//  LightApp
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "TableViewDataSource.h"

@interface BaseTableViewController : UITableViewController

@property (nonatomic, weak) UIImageView * blurBackImageView;
@property (nonatomic)NSInteger page; //列表页码
@property (nonatomic)NSInteger total_num;
@property (nonatomic, strong)TableViewDataSource * tableViewDataSource; //当前tableview的data source
@property (nonatomic, strong)NSMutableArray * items; //列表信息数据源

@property (nonatomic)BOOL isCloseMJRefresh; //是否关闭下拉刷新

- (void)PopToLastViewController;    //返回上级控制器

- (void)PopToRootViewController;    //返回根控制器




- (void)headerRereshing;

- (void)footerRereshing;

@end
