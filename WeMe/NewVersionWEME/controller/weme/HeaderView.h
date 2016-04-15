//
//  HeaderView.h
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *allCashLabel;


@property (strong, nonatomic) IBOutlet UILabel *freezeLabel;

@property (weak, nonatomic) IBOutlet UIView *uiViewBackView;
@property (weak, nonatomic) IBOutlet UIView *carveUpLine;


- (void)fillDataString:(NSString *)totalDepositAmountstring frozenDepositAmount:(NSString *)frozenDepositAmountString;


@end
