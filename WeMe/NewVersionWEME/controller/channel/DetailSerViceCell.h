//
//  DetailSerViceCell.h
//  微密
//
//  Created by wemeDev on 15/5/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordsModel.h"

@protocol detailSerViceCellDelgate <NSObject>

//图文点击事件
- (void)oneNewsCellClick:(NSString *)title url:(NSString *)url;

@optional



@end

@interface DetailSerViceCell : UITableViewCell{
    
    NSArray *_articlesArray;
}

@property (weak, nonatomic) IBOutlet UILabel *SerViceOneLabel;

@property (weak, nonatomic) IBOutlet UIImageView *SerViceTwoImageView;

@property (weak, nonatomic) IBOutlet UILabel *SerViceThreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SerViceThreeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *SerViceFourView;
@property (weak, nonatomic) IBOutlet UILabel *SerViceFourTitle;


@property (weak, nonatomic) IBOutlet UILabel *SerViceFiveLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *SerViceFiveRightLabel;
@property (weak, nonatomic) IBOutlet UIButton *SerViceFiveStartButton;
@property (weak, nonatomic) IBOutlet UILabel *SerViceFiveStartTime;
@property (weak, nonatomic) IBOutlet UILabel *SerViceFiveEndTime;

@property (nonatomic,assign) id<detailSerViceCellDelgate> delegate;

- (void)ShowUIViewWithModel:(RecordsModel *)model;

@end
