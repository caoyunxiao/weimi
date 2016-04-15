//
//  AddFriendViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/25.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessagePushModel;
@interface AddFriendViewController : UIViewController
@property (nonatomic,strong) MessagePushModel *pushModel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *addRess;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@property (weak, nonatomic) IBOutlet UIButton *resultButton;

- (IBAction)agreeButton:(UIButton *)sender;
- (IBAction)refuse:(UIButton *)sender;
@end
