//
//  NewRootViewController.h
//  微密
//
//  Created by wemeDev on 15/3/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewRootViewController : UIViewController{
    
    NSMutableArray * _addressBookTemp;
    NSMutableArray * _personArray;//联系人数组
    NSString *_updateUrl;//更新链接
}



@property (nonatomic,copy) NSString * imeiString;
@property(nonatomic,assign)BOOL hasRegister;
+(id)shareRootViewController;


#pragma mark -- 解绑IMEI ;

- (void)popToRootView;


//版本跟新
- (void)GetEditionOfApp;



@end
