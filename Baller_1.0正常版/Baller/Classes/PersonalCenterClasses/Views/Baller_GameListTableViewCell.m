//
//  Baller_GameListTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_GameListTableViewCell.h"

@implementation Baller_GameListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGameStadus:(GameStadus)gameStadus{
    if (_gameStadus == gameStadus) {
        return;
    }
    
    _gameStadus = gameStadus;
    switch (gameStadus) {
        case GameStadusDone:
            [self.gameStadusButton setTitle:@"已结束" forState:UIControlStateNormal];
            self.line.hidden = YES;
            self.gameStadusButton.userInteractionEnabled = NO;
            self.gameStadusButton.layer.borderColor = CLEARCOLOR.CGColor;
            self.gameStadusButton.layer.cornerRadius = 0.0;
            self.gameStadusButton.layer.borderWidth = 0.0;
            break;
        case GameStadusProgressing:
            [self.gameStadusButton setTitle:@"进行中" forState:UIControlStateNormal];
            self.line.hidden = NO;
            self.gameStadusButton.userInteractionEnabled = NO;
            self.gameStadusButton.layer.borderColor = CLEARCOLOR.CGColor;
            self.gameStadusButton.layer.cornerRadius = 0.0;
            self.gameStadusButton.layer.borderWidth = 0.0;
            break;
        case GameStadusCanJoin:
            [self.gameStadusButton setTitle:@"＋加入" forState:UIControlStateNormal];
            self.line.hidden = YES;
            self.gameStadusButton.userInteractionEnabled = YES;
            self.gameStadusButton.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
            self.gameStadusButton.layer.cornerRadius = 5.0;
            self.gameStadusButton.layer.borderWidth = 0.5;
            break;
        default:
            break;
    }
    [self setNeedsDisplay];
}

- (IBAction)gameStadusButtonAction:(id)sender {
    
    
}

- (CALayer *)line{
    if (!_line) {
        _line = [CALayer layer];
        _line.frame = CGRectMake(0.0, self.gameStadusButton.frame.size.height-0.5, self.gameStadusButton.frame.size.width, 0.5);
        _line.backgroundColor = BALLER_CORLOR_696969.CGColor;
        [self.gameStadusButton.layer addSublayer:_line];
    }
    return _line;
}




- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(33.0, 18.0, 60.0, 60.0);
    self.imageView.layer.cornerRadius = 7.0;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.image = [UIImage imageNamed:@"ballPark_default"];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;

    self.textLabel.frame = CGRectMake(25.0, 86.0, 76.0, 12.0);
    self.textLabel.font = SYSTEM_FONT_S(12.0);
    self.textLabel.textColor = BALLER_CORLOR_696969;
    self.textLabel.text = @"Brad Pitt";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

@end
