//
//  MyCustomAlertView.h
//  微密
//
//  Created by weme on 15/10/16.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyCustomAlertViewDelegate<NSObject>
@optional
/**
 *  去应用商店
 */
-(void)goToAppStore;

@end
@interface MyCustomAlertView : UIView
/**
 *  数据源
 */
@property(nonatomic,strong)NSArray *dataSource;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak,nonatomic)id<MyCustomAlertViewDelegate> delegate;
-(instancetype)initWithXib;

@end
