//
//  BindWMViewController.h
//  微密
//
//  Created by MacDev on 15/3/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindWMViewController : UIViewController
- (IBAction)jumpClick:(UIButton *)sender;
- (IBAction)bindClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *imeiField;
@property (weak, nonatomic) IBOutlet UIButton *whatIMEIButton;//什么是IMEI?
- (IBAction)whatIMEIButton:(UIButton *)sender;

@end
