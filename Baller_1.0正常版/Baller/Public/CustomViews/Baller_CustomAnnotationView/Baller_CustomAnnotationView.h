//
//  Baller_CustomAnnotationView.h
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//

//自定义地图标注

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "Baller_CustomCalloutView.h"

@interface Baller_CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) Baller_CustomCalloutView * calloutView;

@end
