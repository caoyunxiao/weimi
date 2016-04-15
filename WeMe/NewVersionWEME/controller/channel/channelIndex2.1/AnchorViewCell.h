//
//  AnchorViewCell.h
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectAnchorCellDelgate <NSObject>

@optional

- (void)selectAnchorCellClassButton:(NewChannelModel *)model;
- (void)selectAnchorDetailInfor:(NewChannelModel *)model;

@end

@interface AnchorViewCell : UITableViewCell<UIScrollViewDelegate>{
    
    NSArray *_arrayAll;
    NSArray *_anchorArr;
}

@property (nonatomic,assign) id<selectAnchorCellDelgate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *AnchorOneScrollView;
@property (weak, nonatomic) IBOutlet UIView *AnchorOneView;
@property (weak, nonatomic) IBOutlet UIPageControl *AnchorPageControl;

@property (weak, nonatomic) IBOutlet UIView *AnchorViewTwo;



//设置分类标签
- (void)setAnchorViewOneWithArray:(NSArray *)array;

//设置主播
- (void)setAnchorViewTwoWithArray:(NSArray *)array;



@end
