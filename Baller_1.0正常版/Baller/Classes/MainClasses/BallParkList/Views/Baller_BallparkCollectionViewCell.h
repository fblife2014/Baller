//
//  Baller_BallparkCollectionViewCell.h
//  Baller
//
//  Created by malong on 15/1/19.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Baller_BallParkListModel;

@interface Baller_BallparkCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView * ballParkImageView;

@property (nonatomic,strong)UILabel * ballParkNameLabel;

@property (nonatomic,strong)Baller_BallParkListModel * ballPark;

@end
