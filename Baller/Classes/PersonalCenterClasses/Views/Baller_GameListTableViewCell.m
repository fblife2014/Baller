//
//  Baller_GameListTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_GameListTableViewCell.h"
#import "Baller_BallParkActivityListModel.h"

@implementation Baller_GameListTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.backgroundColor = CLEARCOLOR;
    self.imageView.layer.cornerRadius = 7.0;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.image = [UIImage imageNamed:@"ballPark_default"];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
    
    self.textLabel.font = SYSTEM_FONT_S(12.0);
    self.textLabel.textColor = BALLER_CORLOR_696969;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setActivityModel:(Baller_BallParkActivityListModel *)activityModel{
    if (_activityModel == activityModel) {
        return;
    }
    _activityModel = activityModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:activityModel.user_photo] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
    self.textLabel.text = activityModel.user_name;
    _dateLabel.text = [TimeManager getPointStringOfTimeInterval:activityModel.start_time];
    _timeLabel.text = [TimeManager getHourAndMiniteStringOfTimeInterval:activityModel.start_time];
    
    _joinedNumberLabel.text = $str(@"%ld人已加入",activityModel.join_num);
    
    self.line.hidden = YES;
    self.gameStadusButton.userInteractionEnabled = NO;
    self.gameStadusButton.layer.borderColor = CLEARCOLOR.CGColor;
    self.gameStadusButton.layer.cornerRadius = 0.0;
    self.gameStadusButton.layer.borderWidth = 0.0;
    
    switch (activityModel.status) {
        case 1:
        {
            [self.gameStadusButton setTitleShadowColor:BALLER_CORLOR_696969 forState:UIControlStateNormal];
            if ([TimeManager theSuccessivelyWithCurrentTimeFrom:activityModel.start_time]) {
                
                [self.gameStadusButton setTitle:@"未开始" forState:UIControlStateNormal];
                
            }else if ([TimeManager theSuccessivelyWithCurrentTimeFrom:activityModel.end_time]){
                [self.gameStadusButton setTitle:@"进行中" forState:UIControlStateNormal];
                self.line.hidden = NO;

            }else{
                [self.gameStadusButton setTitle:@"已结束" forState:UIControlStateNormal];
            }
            
        }
            break;
        case 2:
            [self.gameStadusButton setTitle:@"已解散" forState:UIControlStateNormal];
            [self.gameStadusButton setTitleColor:BALLER_CORLOR_RED forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

//- (void)setGameStadus:(GameStadus)gameStadus{
//    if (_gameStadus == gameStadus) {
//        return;
//    }
//    
//    _gameStadus = gameStadus;
//    switch (gameStadus) {
//        case GameStadusDone:
//            [self.gameStadusButton setTitle:@"已结束" forState:UIControlStateNormal];
//            self.line.hidden = YES;
//            self.gameStadusButton.userInteractionEnabled = NO;
//            self.gameStadusButton.layer.borderColor = CLEARCOLOR.CGColor;
//            self.gameStadusButton.layer.cornerRadius = 0.0;
//            self.gameStadusButton.layer.borderWidth = 0.0;
//            break;
//        case GameStadusProgressing:
//            [self.gameStadusButton setTitle:@"进行中" forState:UIControlStateNormal];
//            self.line.hidden = NO;
//            self.gameStadusButton.userInteractionEnabled = NO;
//            self.gameStadusButton.layer.borderColor = CLEARCOLOR.CGColor;
//            self.gameStadusButton.layer.cornerRadius = 0.0;
//            self.gameStadusButton.layer.borderWidth = 0.0;
//            break;
//        case GameStadusCanJoin:
//            [self.gameStadusButton setTitle:@"＋加入" forState:UIControlStateNormal];
//            self.line.hidden = YES;
//            self.gameStadusButton.userInteractionEnabled = YES;
//            self.gameStadusButton.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
//            self.gameStadusButton.layer.cornerRadius = 5.0;
//            self.gameStadusButton.layer.borderWidth = 0.5;
//            break;
//        default:
//            break;
//    }
//    [self setNeedsDisplay];
//}

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
    self.textLabel.frame = CGRectMake(25.0, 86.0, 76.0, 12.0);
}

@end
