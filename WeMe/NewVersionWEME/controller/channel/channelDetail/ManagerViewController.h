//
//  ManagerViewController.h
//  微密
//
//  Created by MacDev on 15/4/17.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface ManagerViewController : BasesViewController{
    
    NSString *_openType;
    NSString *_isVerify;
    NSInteger _cellAtIndexRow_Open;
    NSInteger _atSection_Open;
    NSInteger _cellAtIndexRow;
    NSInteger _atSection;
    NSString *_isJoined;
    NSString *_bindKey;
    NSString *_accountIDString;
}
@property(nonatomic,copy)NSString * channelNumber;
- (IBAction)zhuanyiButtonClick:(UIButton *)sender;//转移
- (IBAction)jiesanButtonClick:(UIButton *)sender;

@end
