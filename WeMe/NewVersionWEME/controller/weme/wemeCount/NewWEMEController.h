//
//  NewWEMEController.h
//  微密
//
//  Created by wemeDev on 15/3/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewWEMEController : UITableViewController{
    
    NSInteger _isFirstPush;     //
    NSString *_imeiString;      //IMEI
    NSString *_phoneString;     //电话号码
    NSArray *_iconArr;          //图标数组
}

//- (void)addObserver;


@end
