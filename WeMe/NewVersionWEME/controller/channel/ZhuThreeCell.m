//
//  ZhuThreeCell.m
//  微密
//
//  Created by wkl-mac-4 on 15/5/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ZhuThreeCell.h"
@interface ZhuThreeCell ()

/**
 *  频道简介正文
 */
@property(nonatomic,weak)UILabel *introtion;
/**
 *  粉丝
 */
@property(nonatomic,weak)UILabel *fansLabel;
/**
 *  粉丝数
 */
@property(nonatomic,weak)UILabel *numOfFans;
@end
@implementation ZhuThreeCell

+ (instancetype)zhuThreeCellWithTableview:(UITableView *)tableView {
    ZhuThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreeCell"];
    if (!cell) {
        cell = [[ZhuThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ThreeCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *channelIntro = [[UILabel alloc]init];
        channelIntro.font = kLevelTwoFont;
        [self.contentView addSubview:channelIntro];
        self.channelIntro = channelIntro;
        
        UILabel *introtion = [[UILabel alloc]init];
        introtion.font = kLevelTwoFont;
        [self.contentView addSubview:introtion];
        self.introtion = introtion;
        
        UILabel *fansLabel = [[UILabel alloc]init];
        fansLabel.font = kLevelTwoFont;
        [self.contentView addSubview:fansLabel];
        self.fansLabel = fansLabel;
        
        UILabel *numOfFans = [[UILabel alloc]init];
        numOfFans.font = kLevelTwoFont;
        [self.contentView addSubview:numOfFans];
        self.numOfFans = numOfFans;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.textLabel.text = @"频道简介";
//    self.textLabel.font = kLevelTwoFont;
    
    self.channelIntro.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 44);
    self.channelIntro.numberOfLines = 0;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
