//
//  QunTableViewCell.m
//  微密
//
//  Created by mirrtalk on 15/5/7.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "QunTableViewCell.h"
#import "QRCodeGenerator.h"
#import "drawHeadIcon.h"
@implementation QunTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)fileDataWithModel:(NewChannelModel *)model andType:(NSString *)type
{
    self.erweimaImageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@%@",model.channelNumber,type] imageSize:self.erweimaImageView.bounds.size.width];
    if (model.logoURL.length>0) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
    }else{
        drawHeadIcon *icon=[[drawHeadIcon alloc]initWithFrame:CGRectMake(self.headerImageView.frame.origin.x, self.headerImageView.frame.origin.y, self.headerImageView.frame.size.width, self.headerImageView.frame.size.height)];
        icon.drawTxt=[Tool subStringByRange:model.name];
        [self addSubview:icon];
        
    }

    self.titleLable.text = model.name.length==0?@"":model.name;
    self.placeLblae.text = model.cityName.length==0?@"":[NSString stringWithFormat:@"%@",model.cityName];
    NSString *onlineCount = [NSString stringWithFormat:@"%@",model.onlineCount];
    NSString *userCount = [NSString stringWithFormat:@"%@",model.userCount];
    if(onlineCount==nil||onlineCount.length==0)
    {
        onlineCount = @"0";
    }
    if(userCount==nil||userCount.length==0)
    {
        userCount = @"0";
    }
    self.channelNumber.text = model.channelNumber.length==0?@"":model.channelNumber;
    self.membreNumberLable.text = [NSString stringWithFormat:@"频道好友: %@/%@",onlineCount,userCount];
    self.pinDaoNumLable.text = model.name;
    self.fenLeiLable.text = model.catalogName.length==0?@"":model.catalogName;//分类
    self.quyuLable.text = model.cityName.length==0?@"":model.cityName;
    self.chengyuanLable.text = [NSString stringWithFormat:@"频道好友: %@/%@",onlineCount,userCount];
    self.guanliyuanLable.text = model.adminName.length==0?@"":model.adminName;
    self.gongkaiSwitch.on = [[NSString stringWithFormat:@"%@",model.openType] isEqualToString:@"1"]?YES:NO;
    self.yanzhenSwitch.on = [[NSString stringWithFormat:@"%@",model.isVerity] isEqualToString:@"1"]?YES:NO;
    //......
//    self.openSwitch.on = [[NSString stringWithFormat:@"%@",model.openType] isEqualToString:@"1"]?YES:NO;
//    self.testSwitch.on = [[NSString stringWithFormat:@"%@",model.isVerify] isEqualToString:@"1"]?YES:NO;
//    NSLog(@"----------%@     %@-----------",model.openType,model.isVerify);
//    NSLog(@"==========%d    %d======",self.openSwitch.on,self.testSwitch.on);
    
    self.jianjieLalble.text = model.introduction.length==0?@"该频道没有简介":model.introduction;
    self.guanjianziLable.text = model.keyWords.length==0?@"":model.keyWords;//关键字
    if (model.introduction.length<14) {
        self.jianjieLalble.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        self.jianjieLalble.textAlignment = NSTextAlignmentLeft;
    }
    if([[NSString stringWithFormat:@"%@",model.bindKey] isEqualToString:@"4"])
    {
        self.JiaKeySwitch.on = YES;
        self.JiaJiaKeySwitch.on = NO;
    }
    else if([[NSString stringWithFormat:@"%@",model.bindKey] isEqualToString:@"4"])
    {
        self.JiaKeySwitch.on = NO;
        self.JiaJiaKeySwitch.on = YES;
    }
}

#pragma mark - 验证公开代理


- (IBAction)openSwitchClick:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(openDetailSwitchClick:)]&&sender.tag==99) {
        [self.delegate openDetailSwitchClick:sender];
    }

}

- (IBAction)testSwitchClick:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(testDetailSwitchClick:)]&&sender.tag==999) {
        [self.delegate testDetailSwitchClick:sender];
    }
}

-(void)dealloc{
    
}

@end
