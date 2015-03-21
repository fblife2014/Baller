//
//  AppDelegate.h
//  Baller
//
//  Created by malong on 14/11/23.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)CLLocationCoordinate2D currentLocation;

+ (instancetype)sharedDelegate;

-(void)getTokenFromRC;

- (void)connectRC;

@end

