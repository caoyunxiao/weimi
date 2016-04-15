//
//  NewRegisterViewController.h
//  微密
//
//  Created by APP on 15/5/12.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRegisterViewController : UIViewController{
    NSString *_oldNum;
}
@property(nonatomic,copy)NSString * keyCode;//验证码
@property (nonatomic,copy) NSString *typeStr;


- (IBAction)phoneNumberTextFeild:(UITextField *)sender;


@end
