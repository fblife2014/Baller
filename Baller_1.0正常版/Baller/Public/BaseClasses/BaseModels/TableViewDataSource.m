//
//  TableViewDataSource.m
//  Kr_Demo
//
//  Created by malong on 15/1/27.
//  Copyright (c) 2015年 LanOu3g. All rights reserved.
//

#import "TableViewDataSource.h"
#import "Baller_BaseTableViewCell.h"

@implementation TableViewDataSource

- (id)init{
    return nil;
}

- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier tableViewConfigureBlock:(TableViewCellConfigureBlock)block
{
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.tableViewCellConfigureBlock = [block copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return  self.items[(NSInteger)indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Baller_BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.backgroundType = BaseCellBackgroundTypeUpWhite;
    }else if (indexPath.row == (self.items.count-1)){
        cell.backgroundType = (indexPath.row%2)?BaseCellBackgroundTypeDownGrey:BaseCellBackgroundTypeDownWhite;
        
    }else{
        cell.backgroundType = indexPath.row%2?BaseCellBackgroundTypeMiddleGrey:BaseCellBackgroundTypeMiddleWhite;
        
    }
    
    self.tableViewCellConfigureBlock(cell, [self itemAtIndexPath:indexPath]);
    return cell;
}

@end
