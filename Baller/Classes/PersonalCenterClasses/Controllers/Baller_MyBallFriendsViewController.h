//
//  Baller_MyBallFriendsViewController.h
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

/*!
 *  @brief  球友列表状态
 */
typedef NS_ENUM(NSInteger, BallFriendsListType){
    BallFriendsListTypeTable = 1,           //列表状态
    BallFriendsListTypeCollection,      //网格状态
    BallFriendsListTypeChosing,         //正在选择的状态
    BallFriendsListTypeSearching        //正在搜索的状态
    
};

typedef void (^MyBallFriendsEndChoseBallFriendsBlock)(NSArray * ballFriends);

#import "BaseTableViewController.h"

@interface Baller_MyBallFriendsViewController : BaseTableViewController

@property (nonatomic)BallFriendsListType ballFriendsListType;
@property (nonatomic, copy)MyBallFriendsEndChoseBallFriendsBlock myBallFriendsEndChoseBallFriendsBlock;

- (void)searchWithKeyWord:(NSString *)keyWord;
@end


@interface BallFriendsSearchBar : UISearchBar

@end

