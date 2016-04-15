//
//  CreatTableViewCell.h
//  微密
//
//  Created by MacDev on 15/4/17.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;//频道头像
@property (weak, nonatomic) IBOutlet UILabel *twoTitleLable;//2,标题
//@property (weak, nonatomic) IBOutlet UITextField *twoTextField;//2,输入框
@property (weak, nonatomic) IBOutlet UILabel *twoTextField;//提示框

@property (weak, nonatomic) IBOutlet UILabel *bigTitleLable;//3,大标题
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLable;//3,小标题
@property (weak, nonatomic) IBOutlet UISwitch *channleSwitch;//3,开关
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;





@end
