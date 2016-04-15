//
//  MyViewController.h
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "BasesViewController.h"

#pragma mark --
#pragma mark --  微密设置(绑定/解绑)


typedef void(^MyViewBlock)(BOOL isEnd);

@interface MyViewController : BasesViewController<UITextFieldDelegate,UIAlertViewDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}


@property (strong, nonatomic) IBOutlet UIImageView *codeImageView;//二维码

@property(strong,nonatomic)UIImageView *line;

@property (strong, nonatomic) IBOutlet UIButton *boundButton;//绑定或者解除绑定

@property (strong, nonatomic) IBOutlet UITextField *imeiTexeFeild;
@property (strong, nonatomic) IBOutlet UIButton *twoDimensionBtn;

- (IBAction)imeiTextFeild:(id)sender;

- (IBAction)twoDimensionBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *meTitleLabel;


@property(copy,nonatomic)NSString *IMEIString;

@property(assign,nonatomic)BOOL  isBound;

@property(assign,nonatomic)MyViewBlock endBlock;
@property(nonatomic,copy)NSString * imeiStr;//bindWMViewController传过来的imei号
- (IBAction)boundButtonClick:(id)sender;//绑定或者解除绑定

@end
