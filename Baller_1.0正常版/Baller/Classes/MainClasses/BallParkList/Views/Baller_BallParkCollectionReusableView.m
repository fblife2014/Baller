//
//  Baller_BallParkCollectionReusableView.m
//  Baller
//
//  Created by malong on 15/1/20.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkCollectionReusableView.h"

@implementation Baller_BallParkCollectionReusableView


- (void)awakeFromNib {
    
}
- (IBAction)nearButtonClicked:(id)sender {
    [sender setTitleColor:UIColorFromRGB(0x1e8ad3) forState:UIControlStateNormal];
    [self.authButton setTitleColor:UIColorFromRGB(0x767676) forState:UIControlStateNormal];
    self.topButtonClickBlock(BallParkTypeIdentifyed);


}
- (IBAction)authenButtonClicked:(id)sender {
    [self.nearButton setTitleColor:UIColorFromRGB(0x767676) forState:UIControlStateNormal];
    [sender setTitleColor:UIColorFromRGB(0x1e8ad3) forState:UIControlStateNormal];

    self.topButtonClickBlock(BallParkTypeIdentifing);

}

@end
