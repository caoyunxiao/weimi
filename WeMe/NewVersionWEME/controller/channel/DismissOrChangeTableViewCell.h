//
//  DismissOrChangeTableViewCell.h
//  微密
//
//  Created by weme on 15/9/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DismissOrChangeTableViewCellDelegate <NSObject>
@optional

/**
 *  解散频道
 */
-(void)dismissChannel;

/**
 *  转移频道
 */
-(void)changeChannel;

@end
@interface DismissOrChangeTableViewCell : UITableViewCell
/**
 *  初始化cell xib
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)initWithTableView:(UITableView*)tableView;

@property(nonatomic,weak)id<DismissOrChangeTableViewCellDelegate> delegate;
@end
