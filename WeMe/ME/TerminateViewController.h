//
//  TerminateViewController.h
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark --  解约


@interface TerminateViewController : UIViewController<UITextFieldDelegate>{
    
    NSArray *_textFieldArray;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *terminateScrollView;

@property (strong, nonatomic) IBOutlet UITextField *passworldTextFeild;

@property (strong, nonatomic) IBOutlet UITextField *complanyTextFeild;

@property (strong, nonatomic) IBOutlet UITextField *oldNumberTextFeild;

- (IBAction)cashPwdChange:(id)sender;

- (IBAction)companyChange:(id)sender;

- (IBAction)expressageChange:(id)sender;

- (IBAction)myButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *myButton;





@end
