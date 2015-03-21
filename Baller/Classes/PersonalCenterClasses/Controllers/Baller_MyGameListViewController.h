//
//  Baller_MyJoinedViewController.h
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef NS_ENUM(NSInteger, GameListType) { //比赛列表类型
    GameListType_MyOriginate = 0,     //我发起的
    GameListType_MyCollected = 1,     //我收藏的
    GameListType_MyJoined = 2,        //我参加的
    GameListType_MyEvaluated = 3,     //我评价过的
    GameListType_WaitEvaluated = 4    //待评价的

};

#import "BaseViewController.h"

@interface Baller_MyGameListViewController : BaseViewController

@property (nonatomic)GameListType gameListType;

@end
