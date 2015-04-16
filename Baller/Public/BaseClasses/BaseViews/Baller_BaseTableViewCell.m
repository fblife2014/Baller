//
//  Baller_BaseTableViewCell.m
//  Baller
//
//  Created by malong on 15/3/4.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BaseTableViewCell.h"

@interface Baller_BaseTableViewCell()

/*!
 *  @brief  设置六个图片属性，并用懒加载方式初始化，节省内存消耗
 */

@property (nonatomic,strong)UIImage * up_greyImage;
@property (nonatomic,strong)UIImage * up_whiteImage;
@property (nonatomic,strong)UIImage * middle_greyImage;
@property (nonatomic,strong)UIImage * middle_whiteImage;
@property (nonatomic,strong)UIImage * down_greyImage;
@property (nonatomic,strong)UIImage * down_whiteImage;
@property (nonatomic,strong)UIImage * whiteImage;

@end

@implementation Baller_BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = CLEARCOLOR;
        self.backgroundType = BaseCellBackgroundTypeMiddleWhite;
        self.backgroundImageView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)awakeFromNib {
    self.contentView.backgroundColor = CLEARCOLOR;
    self.backgroundType = BaseCellBackgroundTypeMiddleWhite;
    self.backgroundImageView.userInteractionEnabled = NO;
    // Initialization code
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
       _backgroundImageView = imageView;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            imageView.frame = CGRectMake(TABLE_SPACE_INSET, 0.0, ScreenWidth-2*TABLE_SPACE_INSET, CGRectGetHeight(self.contentView.bounds));
        });
        _backgroundImageView.clipsToBounds = YES;
        [self.contentView insertSubview:_backgroundImageView atIndex:0];
    }
    return _backgroundImageView;
}

- (void)setBackgroundType:(BaseCellBackgroundType)backgroundType{
    if (_backgroundType == backgroundType) {
        return;
    }
    _backgroundType = backgroundType;
    
    switch (backgroundType) {
        case BaseCellBackgroundTypeUpGrey:
            self.backgroundImageView.image = self.up_greyImage;
            break;
        case BaseCellBackgroundTypeUpWhite:
            self.backgroundImageView.image = self.up_whiteImage;

            break;
        case BaseCellBackgroundTypeMiddleGrey:
            self.backgroundImageView.image = self.middle_greyImage;

            break;
        case BaseCellBackgroundTypeMiddleWhite:
            self.backgroundImageView.image = self.middle_whiteImage;

            break;
        case BaseCellBackgroundTypeDownGrey:
            self.backgroundImageView.image = self.down_greyImage;

            break;
        case BaseCellBackgroundTypeDownWhite:
            self.backgroundImageView.image = self.down_whiteImage;
            break;
        case BaseCellBackgroundTypeOnlyOne:
            self.backgroundImageView.image = self.whiteImage;

            break;
            

    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *)up_greyImage
{
    if (!_up_greyImage) {
        _up_greyImage = [[UIImage imageNamed:@"up_grey"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 5.0, 10.0, 10.0)];
        
    }
    return _up_greyImage;
}

- (UIImage *)up_whiteImage
{
    if (!_up_whiteImage) {
        _up_whiteImage = [[UIImage imageNamed:@"up_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 5.0, 10.0, 10.0)];
    }
    return _up_whiteImage;
}

- (UIImage *)middle_greyImage
{
    if (!_middle_greyImage) {
        _middle_greyImage = [UIImage imageNamed:@"middle_grey"];
        
    }
    return _middle_greyImage;
}

- (UIImage *)middle_whiteImage
{
    if (!_middle_whiteImage) {
        _middle_whiteImage = [UIImage imageNamed:@"middle_white"];
        
    }
    return _middle_whiteImage;
}

- (UIImage *)down_greyImage
{
    if (!_down_greyImage) {
        _down_greyImage = [[UIImage imageNamed:@"down_grey"]resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 0.0, 10.0, 10.0)];
        
    }
    return _down_greyImage;
}

- (UIImage *)down_whiteImage
{
    if (!_down_whiteImage) {
        _down_whiteImage = [[UIImage imageNamed:@"down_white"]resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 0.0, 10.0, 10.0)];
        
    }
    return _down_whiteImage;
}

- (UIImage *)whiteImage{
    if (!_whiteImage) {
        _whiteImage = [[UIImage imageNamed:@"whitelist"]resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 0.0, 10.0, 10.0)];
        
    }
    return _whiteImage;
}

@end
