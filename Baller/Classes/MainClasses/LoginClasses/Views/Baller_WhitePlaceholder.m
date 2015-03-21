//
//  Baller_WhitePlaceholder.m
//  Baller
//
//  Created by malong on 15/1/16.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_WhitePlaceholder.h"

@implementation Baller_WhitePlaceholder

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawPlaceholderInRect:(CGRect)rect{
    
    
    [self.placeholder drawWithRect:CGRectMake(rect.origin.x+rect.size.width/2.0-[NSStringManager sizeOfCurrentString:NSLocalizedString(@"ClickInputNickname", nil) font:TextFontSize contentSize:CGSizeMake(rect.size.width, TextFontSize)].width/2.0, rect.origin.y+4, rect.size.width, rect.size.height-4.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:TextFontSize],NSFontAttributeName,DEFAULT_BOLDFONT(TextFontSize), NSFontAttributeName, nil] context:NULL];

}

@end
