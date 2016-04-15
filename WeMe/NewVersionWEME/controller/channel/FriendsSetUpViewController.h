//
//  FriendsSetUpViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
@interface FriendsSetUpViewController : UITableViewController{
    
    NSString *_accountID;
    NSString *_isAllowedOpinion;
    NSString *_isReceiveNotifyOpinion;
    NSString *_isVerifyOpinion;
}
@property (weak, nonatomic) IBOutlet UISwitch *switchAddFriend;
@property (weak, nonatomic) IBOutlet UISwitch *switchNeedFriend;

- (IBAction)switchValueChanged:(UISwitch *)sender;

@end
