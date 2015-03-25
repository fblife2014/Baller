//
//  Baller_MyBasketballTeamTableViewHeaderView.m
//  Baller
//
//  Created by Tongtong Xu on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBasketballTeamTableViewHeaderView.h"
#import "UIView+ML_BlurView.h"

@interface Baller_MyBasketballTeamTableViewHeaderView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberCountWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthFromMemeberNumberToCourtName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthFromCourtNameToCaptainName;
@end

@implementation Baller_MyBasketballTeamTableViewHeaderView

- (void)awakeFromNib {
    self.memberCountView.layer.cornerRadius = 5;
    self.memberCountView.clipsToBounds = YES;
    [self configInDiffVersion];
    [self.headImageView showBlurWithDuration:0 blurStyle:kUIBlurEffectStyleLight belowView:nil];
}

- (void)configInDiffVersion {
    if ([[UIScreen mainScreen] bounds].size.width < 374) {
        self.memberCountWidth.constant = 40;
        self.widthFromCourtNameToCaptainName.constant = self.widthFromMemeberNumberToCourtName.constant = 31;
    } else if ([[UIScreen mainScreen] bounds].size.width < 413) {
        self.memberCountWidth.constant = 50;
        self.widthFromCourtNameToCaptainName.constant = self.widthFromMemeberNumberToCourtName.constant = 35;
    } else if ([[UIScreen mainScreen] bounds].size.width < 500) {
        self.memberCountWidth.constant = 60;
        self.widthFromCourtNameToCaptainName.constant = self.widthFromMemeberNumberToCourtName.constant = 39;
    }
}

@end
