//
//  PublicAndJoinTableViewCell.h
//  WeMe
//
//  Created by weme on 15/10/23.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublicAndJoinTableViewCellDelegate <NSObject>
@optional
-(void)publicSwitchValueChanged:(UISwitch*)sw;
-(void)isverfySwitchValueChanged:(UISwitch*)sw;


@end
@interface PublicAndJoinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *testSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;
@property(weak,nonatomic)id<PublicAndJoinTableViewCellDelegate> delegate;

@end
