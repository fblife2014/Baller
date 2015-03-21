//
//  Baller_AnnotationMapViewController.h
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef void (^BallerAnnotionCallBack)(NSDictionary * positionInfo);

#import "BaseViewController.h"

@interface Baller_AnnotationMapViewController : BaseViewController{



}

@property (nonatomic)BOOL autoAnnotion; //自动标注，即获取当前位置

@property (nonatomic,copy) BallerAnnotionCallBack posionCallBack;

@end
