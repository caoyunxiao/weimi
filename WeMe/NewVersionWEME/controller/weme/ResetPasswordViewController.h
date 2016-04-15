//
//  ResetPasswordViewController.h
//  微密
//
//  Created by wemeDev on 15/5/27.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface ResetPasswordViewController : BasesViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *myNewPassWord;
@property (weak, nonatomic) IBOutlet UITextField *surePassWord;

@property (weak, nonatomic) IBOutlet UIButton *upDataButton;
- (IBAction)upDataButton:(UIButton *)sender;




@end
