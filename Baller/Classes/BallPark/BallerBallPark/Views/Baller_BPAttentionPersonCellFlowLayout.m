//
//  Baller_BPAttentionPersonCellFlowLayout.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//
//首页item的间隔
#define BallPark_ItemSpacing NUMBER(14.0, 12.0, 10., 10.0)


#import "Baller_BPAttentionPersonCellFlowLayout.h"

@implementation Baller_BPAttentionPersonCellFlowLayout
- (id)init{
    self = [super init];
    if (self) {
        
        float width = MAX(80.0, ScreenWidth/NUMBER(5.0, 4.0, 4.0, 4.0));
        
        float herizonalInset = 10+NUMBER(9.0, 15.0, 8.0, 7.0);
        self.sectionInset = UIEdgeInsetsMake(15.0,herizonalInset, 15.0, herizonalInset);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.itemSize = CGSizeMake(width, 117.0);
        self.minimumLineSpacing = Baller_BPAttention_ItemVerSpacing;
        self.minimumInteritemSpacing = NUMBER(13.0, 12.0, 10.0, 10.0);

    }
    return self;
}
@end
