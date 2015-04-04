//
//  Baller_ChatListViewController.m
//  Baller
//
//  Created by 王龙 on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ChatListViewController.h"
#import "RCChatViewController.h"
#import "Baller_PlayerCardViewController.h"
#import "RCIM.h"

@implementation Baller_ChatListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    [self userHeadClicked];
    // Do any additional setup after loading the view.
}


/**
 *  会话列表选中调用
 *
 *  @param conversation 选中单元的会话信息；
 */
-(void)onSelectedTableRow:(RCConversation*)conversation{
    
    
    // 该方法目的延长会话聊天 UI 的生命周期
    RCChatViewController* chat = [self getChatController:conversation.targetId conversationType:conversation.conversationType];
    if (nil == chat) {
        chat =[[RCChatViewController alloc]init];
        [self addChatController:chat];
    }
    
    chat.currentTarget = conversation.targetId;
    chat.conversationType = conversation.conversationType;
    chat.currentTargetName = conversation.conversationTitle;
    chat.portraitStyle = RCUserAvatarCycle;
    chat.enableVoIP = NO;
    
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)userHeadClicked
{
    [[RCIM sharedRCIM] setUserPortraitClickEvent:^(UIViewController *viewController, RCUserInfo *userInfo) {
        DLog(@"%@,%@",viewController,userInfo);
        
        
        Baller_PlayerCardViewController *temp = [[Baller_PlayerCardViewController alloc]init];
        temp.uid = userInfo.userId;
        temp.userName = userInfo.name;
        
        
        if ([userInfo.userId isEqualToString:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"]]) {
            temp.uid = userInfo.userId;
            temp.userName = userInfo.name;
            temp.photoUrl = userInfo.portraitUri;
            temp.ballerCardType = kBallerCardType_MyPlayerCard;
        }else{
            temp.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
        }
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:temp];
        
        //导航和的配色保持一直
        UIImage *image= [viewController.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        
        [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [viewController presentViewController:nav animated:YES completion:NULL];
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
