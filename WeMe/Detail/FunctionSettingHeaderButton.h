//
//  FunctionSettingHeaderButton.h
//  微密
//
//  Created by longlz on 14-8-4.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FunctionSettingHeaderButtonDelegate <NSObject>

- (void)functionValueChanage:(int)section isSeleted:(BOOL)isSeleted;

@end



@interface FunctionSettingHeaderButton : UIButton


@property (strong, nonatomic) IBOutlet UILabel *actualLabel;

@property (strong, nonatomic) IBOutlet UILabel *allLabel;

@property (strong, nonatomic) IBOutlet UISwitch *allOrderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *tishiLable;
@property (weak, nonatomic) IBOutlet UILabel *xiegangLable;

- (IBAction)allOrderValueChanage:(id)sender;



@property(assign,nonatomic)BOOL  isSelected;

@property(assign,nonatomic)int   section;


@property(assign,nonatomic)id<FunctionSettingHeaderButtonDelegate> delegate;

@end
