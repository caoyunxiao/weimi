//
//  CASHPSDViewController.h
//  微密
//
//  Created by longlz on 14-7-19.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark --
#pragma mark --  设置押金密码



typedef void(^PreBlock)();

@interface CASHPSDViewController : UIViewController<UITextFieldDelegate>


@property(copy,nonatomic)PreBlock preBlock;

@property(assign,nonatomic)BOOL   isCashPwd;


@property (strong, nonatomic) IBOutlet UITextField *oldTextFeild;


@property (strong, nonatomic) IBOutlet UITextField *nowTextFeild;


@property (strong, nonatomic) IBOutlet UITextField *conformTextFeild;

@property (strong, nonatomic) IBOutlet UIButton *modiyButton;


- (IBAction)modifyButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;





@end
