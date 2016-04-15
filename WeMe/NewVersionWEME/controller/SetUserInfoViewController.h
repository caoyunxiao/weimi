//
//  SetUserInfoViewController.h
//  微密
//
//  Created by APP on 15/5/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUserInfoViewController : UIViewController{
    UIImage *_userImage;
    ModelView *_modelView;
}
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;

@property (nonatomic,copy) NSString *pressType;

@end
