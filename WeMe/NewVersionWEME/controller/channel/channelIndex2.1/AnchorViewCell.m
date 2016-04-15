//
//  AnchorViewCell.m
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "AnchorViewCell.h"
#import "NewChannelModel.h"

@implementation AnchorViewCell

- (void)awakeFromNib
{
    self.clipsToBounds = YES;
    
    _AnchorOneScrollView.pagingEnabled = YES;
    _AnchorOneScrollView.delegate = self;
    self.AnchorOneScrollView.showsHorizontalScrollIndicator = NO;
    self.AnchorOneScrollView.showsVerticalScrollIndicator = NO;
}

//设置分类标签
- (void)setAnchorViewOneWithArray:(NSArray *)array
{
    NSMutableArray *oldArr = [[NSMutableArray alloc]initWithArray:array];
    NSInteger num = array.count/6;
    if(array.count%6 != 0)
    {
        num ++;
    }
    
    CGFloat width = _AnchorOneScrollView.frame.size.width;
    CGFloat height = _AnchorOneScrollView.frame.size.height;
  
    _AnchorOneScrollView.contentSize = CGSizeMake(width*num, height);
   
    self.AnchorPageControl.numberOfPages = num;
    self.AnchorPageControl.currentPage = 0;
    
    NSMutableArray *arrayAll = [[NSMutableArray alloc]init];
    
    for(int i=0;i<num;i++)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        if(oldArr.count>=6)
        {
            for (int i = 0; i<6; i++)
            {
                [arr addObject:[oldArr objectAtIndex:i]];
            }
        }
        else if (oldArr.count<6&&oldArr.count>0)
        {
            for (int i = 0; i<oldArr.count; i++)
            {
                [arr addObject:[oldArr objectAtIndex:i]];
            }
            for (int i = 0; i<oldArr.count; i++)
            {
                [oldArr removeObjectAtIndex:i];
            }
        }
        [oldArr removeObjectsInArray:arr];
        [arrayAll addObject:arr];
    }
    _arrayAll = arrayAll;
    //NSLog(@"============%ld",arrayAll.count);
    
    for (int a = 0; a < arrayAll.count; a++)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_AnchorOneScrollView.frame.size.width*a, 0, _AnchorOneScrollView.frame.size.width, _AnchorOneScrollView.frame.size.height)];
        view.backgroundColor = [UIColor whiteColor];
        [_AnchorOneScrollView addSubview:view];
 
        NSArray *arrayB = arrayAll[a];
        for (int b = 0; b < arrayB.count; b++)
        {
//            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(8+(104+30)*j, (10+30)*i, 40, 20)];
//            imgView.image=[UIImage imageNamed:imgArray[a]];
//            [view addSubview:imgView];
//

            NewChannelModel *model = [arrayB objectAtIndex:b];
            UIButton *button = [[UIButton alloc]init];
            button.tag = 600 + a*10 + b;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(8+104*(b%3), 35+(15+35)*(b/3), 96, 15);
            [button setTitle:model.name forState:UIControlStateNormal];
            [button addTarget:self action:@selector(anchorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            //.........
            NSArray *imgArray=@[@"jiaotongchuxing",@"cheyouhui",@"hangyejiaoliu",@"tongshi",@"tongchengjiaoyou",@"xingquaihao",@"yingjijiuyuan",@"chihewanle",@"pinpairemai",@"diqupindao",@"xianxiafuwu",@"iconfont-qiaheqian",@"dashuyefengkuang",@"meinvyaobuyao",@"meishi",@"lvxing",@"liangxingqinggan",@"gaojiziyou",@"meinv"];
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(8+104*(b%3)+30,35+(15+35)*(b/3)-32, 32, 32)];
            imgView.image=[UIImage imageNamed:imgArray[6*a+b]];
            imgView.tag= 600 + a*10 + b;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRedirect:)];
            tap.delegate=self;
            tap.numberOfTapsRequired=1;
            tap.numberOfTouchesRequired=1;
            [imgView addGestureRecognizer:tap];
            imgView.userInteractionEnabled=YES;
            [view addSubview:imgView];
        }
    }
    
    
}
/**
 *  图片点击
 *
 *  @param tap <#tap description#>
 */
-(void)tapRedirect:(UITapGestureRecognizer*)tap{
    NSString *tagStr = [NSString stringWithFormat:@"%ld",tap.view.tag - 600];
    NSInteger tag = tap.view.tag - 600;
    NSInteger shi;
    NSInteger ge;
    if([tagStr isEqualToString:@"0"])
    {
        shi = 0;
        ge = 0;
    }
    else if (tag>=1&&tag<=5)
    {
        shi = 0;
        ge = [[tagStr substringWithRange:NSMakeRange(0, 1)] integerValue];
    }
    else
    {
        shi = [[tagStr substringWithRange:NSMakeRange(0, 1)] integerValue];
        ge = [[tagStr substringWithRange:NSMakeRange(1, 1)] integerValue];
    }
    
    NSArray *arrayB = _arrayAll[shi];
    if(_arrayAll.count>0)
    {
        NewChannelModel *model = [arrayB objectAtIndex:ge];
        if([self.delegate respondsToSelector:@selector(selectAnchorCellClassButton:)])
        {
            [self.delegate selectAnchorCellClassButton:model];
        }
    }

}
//分类点击事件
- (void)anchorButtonClick:(UIButton *)button
{
    NSString *tagStr = [NSString stringWithFormat:@"%ld",button.tag - 600];
    NSInteger tag = button.tag - 600;
    NSInteger shi;
    NSInteger ge;
    if([tagStr isEqualToString:@"0"])
    {
        shi = 0;
        ge = 0;
    }
    else if (tag>=1&&tag<=5)
    {
        shi = 0;
        ge = [[tagStr substringWithRange:NSMakeRange(0, 1)] integerValue];
    }
    else
    {
        shi = [[tagStr substringWithRange:NSMakeRange(0, 1)] integerValue];
        ge = [[tagStr substringWithRange:NSMakeRange(1, 1)] integerValue];
    }
    
    NSArray *arrayB = _arrayAll[shi];
    if(_arrayAll.count>0)
    {
        NewChannelModel *model = [arrayB objectAtIndex:ge];
        if([self.delegate respondsToSelector:@selector(selectAnchorCellClassButton:)])
        {
            [self.delegate selectAnchorCellClassButton:model];
        }
    }
}

#pragma mark -ScrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.AnchorPageControl.currentPage = _AnchorOneScrollView.contentOffset.x/_AnchorOneScrollView.frame.size.width;
}
//设置主播
- (void)setAnchorViewTwoWithArray:(NSArray *)array
{
    float width = (self.frame.size.width - 1) / 2;
    if(array.count>0)
    {
        _anchorArr = array;
        for (UIView *view in self.AnchorViewTwo.subviews)
        {
            [view removeFromSuperview];
        }
        for (int i=0; i<array.count; i++)
        {
            NewChannelModel *model = [array objectAtIndex:i];
            
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake((width + 1)*(i%2), (width+1)*(i/2), width, width);
            [self.AnchorViewTwo addSubview:view];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
//            [imageView setImageWithURLOfZFJ:model.logoURL placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:model.logoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                imageView.image=[image scaleToSize:CGSizeMake(ANCHORIMGWIDTH, ANCHORIMGWIDTH)];
//            }];
            [view addSubview:imageView];
            
            
            //频道名
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, width-45, width, 15)];
            name.text = [NSString stringWithFormat:@" %@",model.name];
            name.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:240/255.0 alpha:0.6];
            name.font = [UIFont systemFontOfSize:12];
            [view addSubview:name];
            
            //主播名
            UILabel *anchorLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, width-30, width, 15)];
            anchorLabel.text=[NSString stringWithFormat:@" 主播: %@",model.chiefAnnouncerName];
            anchorLabel.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:240/255.0 alpha:0.6];
            anchorLabel.font = [UIFont systemFontOfSize:12];
            [view addSubview:anchorLabel];
            //粉丝
            UILabel *fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, width-15, width, 15)];
            fansLabel.text = [NSString stringWithFormat:@" 粉丝: %@",model.userCount];
            fansLabel.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:240/255.0 alpha:0.6];
            fansLabel.font = [UIFont systemFontOfSize:12];
            [view addSubview:fansLabel];
            
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake((width + 1)*(i%2), (width+1)*(i/2), width, width);
            button.tag = 8000+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.AnchorViewTwo addSubview:button];
            [self.AnchorViewTwo bringSubviewToFront:button];
        }
    }
}

//分类点击事件
- (void)buttonClick:(UIButton *)button
{
    if(_anchorArr.count>0)
    {
        NSInteger index = button.tag-8000;
        NewChannelModel *model = [_anchorArr objectAtIndex:index];
        if([self.delegate respondsToSelector:@selector(selectAnchorDetailInfor:)])
        {
            [self.delegate selectAnchorDetailInfor:model];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

















@end
