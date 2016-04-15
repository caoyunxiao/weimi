//
//  ChannelHeadSettingView.h
//  微密
//
//  Created by weme on 15/10/12.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelHeadSettingView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

+(instancetype)initWithNib;
@end
