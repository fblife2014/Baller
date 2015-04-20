//
//  Baller_BallParkCollectionViewLayout.m
//  Baller
//
//  Created by malong on 15/1/19.
//  Copyright (c) 2015年 malong. All rights reserved.
//


#import "Baller_BallParkCollectionViewLayout.h"

@implementation Baller_BallParkCollectionViewLayout

- (id)init{
    self = [super init];
    if (self) {
        
        self.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
        self.sectionInset = UIEdgeInsetsMake(5, BallPark_ItemSpacing, 0, BallPark_ItemSpacing);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;

        CGFloat width = (ScreenWidth-3*BallPark_ItemSpacing)/2.0;
        CGFloat height =(ScreenWidth-BallPark_ItemSpacing)/2.0;
        
        self.itemSize = CGSizeMake(width, height);
        self.minimumLineSpacing = 0;
    }
    return self;
}

//- (CGSize)collectionViewContentSize{
//    return CGSizeMake((ScreenWidth-3*14)/2.0, (ScreenWidth-3*14)/2.0);
//}
//
//#pragma mark - UICollectionViewLayout
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    
//    attributes.size = CGSizeMake((ScreenWidth-3*14)/2.0, (ScreenWidth-3*14)/2.0);
//    
//    return attributes;
//}
//
//-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
//    if ([arr count] > 0) {
//        return arr;
//    }
//    NSMutableArray *attributes = [NSMutableArray array];
//    for (NSInteger i = 0 ; i < [self.collectionView numberOfItemsInSection:0 ]; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    }
//    return attributes;
//}
//
@end
