//
//  ModifictionViewController.h
//  微密
//
//  Created by longlz on 14-7-15.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark --
#pragma mark --  修改密码


@interface ModifictionViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    NSArray *_textFieldArray;
}

@property (strong, nonatomic) IBOutlet UITextField *oldTextField;
@property (strong, nonatomic) IBOutlet UITextField *nowTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPwdTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *modifyButton;

- (IBAction)modification:(id)sender;

@end
