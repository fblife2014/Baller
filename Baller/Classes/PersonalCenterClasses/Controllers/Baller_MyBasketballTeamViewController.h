//
//  Baller_MyBasketballTeamViewController.h
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "BaseTableViewController.h"

@interface Baller_MyBasketballTeamViewController : BaseTableViewController

@end


/*!
 已经加入球队后，顶部的三项所用标签
 */
@interface TopLebel : UIView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title detail:(NSString *)detail;

@end