//
//  MoreTopCell.m
//  微密
//
//  Created by wemeDev on 15/5/27.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MoreTopCell.h"
#import "SDCycleScrollView.h"
#import "MoreModely.h"

@implementation MoreTopCell

- (void)awakeFromNib
{
    self.clipsToBounds = YES;
}
#pragma mark - 给UIScrollView添加多个图片
- (void)showUIViewWithNSArray:(NSArray *)array
{
    _modelArray = array;
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    for (MoreModely *model in array)
    {
        [imagesURLStrings addObject:model.picUrl];
        [titles addObject:model.appName];
    }
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView2.showPageControl = YES;
    cycleScrollView2.autoScrollTimeInterval = 5.0;
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.delegate = self;
    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"moreimage.png"];
    [self addSubview:cycleScrollView2];
    
    //模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    MoreModely *model = [_modelArray objectAtIndex:index];
    if([self.delegate respondsToSelector:@selector(selectMoreOneImageByClick:)])
    {
        [self.delegate selectMoreOneImageByClick:model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
