//
//  Baller_ChatListViewController.m
//  Baller
//
//  Created by 王龙 on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ChatListViewController.h"
#import "RCChatViewController.h"
@implementation Baller_ChatListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
