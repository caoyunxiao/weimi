//
//  FunctionTableViewCell.h
//  微密
//
//  Created by longlz on 14-8-5.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FunctionInfo.h"
@protocol FunctionTableViewCellDelegate <NSObject>

- (void)functionCallback:(int)section  row:(int)row isSelected:(BOOL)isSelected;

@end


@interface FunctionTableViewCell : UITableViewCell


@property(weak,nonatomic)id<FunctionTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) IBOutlet UISwitch *orderSwitch;

@property(nonatomic,strong)FunctionInfo * info;
- (IBAction)orderValueChange:(id)sender;


//- (void)fillDataWith:(FunctionInfo *)info;
@property (assign ,nonatomic)int section;

@property (assign ,nonatomic)int row;


@end
