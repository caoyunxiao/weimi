//
//  FamilyViewController.h
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface FamilyViewController : UIViewController<UITextFieldDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}


@property(strong,nonatomic)UIImageView *line;

@property (strong, nonatomic) IBOutlet UITextField *accountIDTextFeild;

@property (strong, nonatomic) IBOutlet UIButton *applyButton;


@property (strong, nonatomic) IBOutlet UILabel *stationLabel;


@property (strong, nonatomic) IBOutlet UITextField *phoneTextFeild;


- (IBAction)applyFamilyButton:(id)sender;


- (IBAction)codeButtonClick:(id)sender;


@end
