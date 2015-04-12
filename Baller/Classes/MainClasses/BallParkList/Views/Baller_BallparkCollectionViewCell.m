//
//  Baller_BallparkCollectionViewCell.m
//  Baller
//
//  Created by malong on 15/1/19.
//  Copyright (c) 2015年 malong. All rights reserved.
//


#import "Baller_BallparkCollectionViewCell.h"

#import "Baller_ImageUtil.h"
#import "Baller_ColorMatrix.h"

#import "UIImageView+AFNetworking.h"

#import "Baller_BallParkListModel.h"

@implementation Baller_BallparkCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 4.0;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = CLEARCOLOR;
        
        _ballParkImageView = [[UIImageView alloc]init];
        _ballParkImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.ballParkImageView];
        
        whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        [self.contentView addSubview:whiteView];
        _ballParkNameLabel = [ViewFactory addAlabelForAView:whiteView withText:nil frame:CGRectZero font:SYSTEM_FONT_S(13.0) textColor:BALLER_CORLOR_767676];
    }
    return self;
}

- (void)setBallPark:(Baller_BallParkListModel *)ballPark{
    if (_ballPark == ballPark) {
        return;
    }
    self.ballParkNameLabel.text = ballPark.court_name;
    self.ballParkImageView.image = nil;
    //加载视图
    __WEAKOBJ(weakSelf, self);
    [self.ballParkImageView sd_setImageWithURL:[NSURL URLWithString:ballPark.court_img] placeholderImage:[UIImage imageNamed:@"ballPark_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //如果未验证通过，图片置灰
        if (1 == ballPark.status) {
            weakSelf.ballParkImageView.image = [Baller_ImageUtil imageWithImage:image withColorMatrix:Baller_Colormatrix_huajiu scaledToSize:CGSizeMake(weakSelf.contentView.frame.size.width, 435.0/561.0*weakSelf.contentView.frame.size.width)];
        }
    }];

}


- (void)layoutSubviews{
    
    self.contentView.frame = CGRectMake(0.0, BallPark_ItemSpacing/2.0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    self.ballParkImageView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, 435.0/561.0*self.contentView.frame.size.width);
    whiteView.frame = CGRectMake(0.0, 435.0/561.0*self.contentView.frame.size.width-15, self.contentView.frame.size.width, 129.0/561.0*self.contentView.frame.size.width+5);

    self.ballParkNameLabel.frame = CGRectMake(7.5, 2.5, whiteView.frame.size.width-15, whiteView.frame.size.height-5);
    
}



@end
