//
//  GroupChatViewCell.m
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "GroupChatViewCell.h"
#import "SetModelZFJ.h"
#import "MyChannelViewController.h"
#import "drawHeadIcon.h"
#import "ChannelHeadSettingView.h"


@interface GroupChatViewCell()
/**
 *  是否是三方 1是0不是
 */
@property(nonatomic,copy)NSString *isthirdModel;
@end

@implementation GroupChatViewCell{
    
    NSArray *_classArray;
}

-(NSString *)isthirdModel{
    _isthirdModel=[UserDefaults objectForKey:@"isThirdModel"];
    return _isthirdModel;
}
- (void)awakeFromNib
{
    self.GCJoinButton.layer.masksToBounds = YES;
    self.GCJoinButton.layer.cornerRadius = 5;
    self.GCJoinButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.GCJoinButton.layer.borderWidth = 1.0;
    
}

//频道设置数据配置函数（重构）
- (void)setGroupChatOneValueNew:(NSArray *)array{
    if([self.isthirdModel isEqualToString:@"0"]){
        [self weMeThirdModelShow:@"" arr:array];
    }else{
        [self isThirdModelShow:array];
    }
}


/**
 *  根据model获得detailTXT icon图文字
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary*)getDetailAndDrawTxt:(SetModelZFJ*)model{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if ([model.actionType isEqualToString:@"4"]) {
        if ([model.talkStatus isEqualToNumber:[NSNumber numberWithInt:4]]) {
            [dic setObject:[NSString stringWithFormat:@"%@(%@)(等待验证)",model.parameterName,model.customParameter] forKey:@"detailTxtLeft"];
        }else{
            [dic setObject:[NSString stringWithFormat:@"%@(%@)",model.parameterName,model.customParameter] forKey:@"detailTxtLeft"];
        }
        [dic setObject:[Tool subStringByRange:model.parameterName] forKey:@"drawTxtLeft"];
    }else if([model.actionType isEqualToString:@"5"]){
        if ([model.talkStatus isEqualToNumber:[NSNumber numberWithInt:4]]) {
            [dic setObject:[NSString stringWithFormat:@"%@(%@)(等待验证)",model.parameterName,model.customParameter] forKey:@"detailTxtRight"];
        }else{
            [dic setObject:[NSString stringWithFormat:@"%@(%@)",model.parameterName,model.customParameter] forKey:@"detailTxtRight"];
        }
        [dic setObject:[Tool subStringByRange:model.parameterName] forKey:@"drawTxtRight"];
        
    }
    return dic;
}

/**
 *  三方终端数据设置
 *
 *  @param arr <#arr description#>
 */
-(void)isThirdModelShow:(NSArray*)arr{
    for (UIView *view in self.groupChatOne.subviews)
    {
        [view removeFromSuperview];
    }
    float width = (self.frame.size.width - 1) / 2;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    if(arr.count==0){
        ChannelHeadSettingView *headViewCenter=[ChannelHeadSettingView initWithNib];
        headViewCenter.frame=CGRectMake(width-width/2, 0, width, width);
        headViewCenter.titleLbl.text=@"主聊频道";
        headViewCenter.detailLbl.text=@"暂未关联";
        headViewCenter.tag=5;
        [self.groupChatOne addSubview:headViewCenter];
        headIcon *icon=[headIcon initWithHeadNib];
        icon.centerWordLbl.text=@"空";
        icon.frame=CGRectMake(headViewCenter.bgImgView.frame.origin.x, headViewCenter.bgImgView.frame.origin.y,80, 80);
        [headViewCenter addSubview:icon];
        [headViewCenter addGestureRecognizer:tap];
    }else{
        SetModelZFJ *model=[SetModelZFJ new];
        for (SetModelZFJ *item in arr) {
            if ([item.actionType isEqualToString:@"5"]) {
                model=item;
            }
        }
        NSString *detailStr=@"暂未关联";
        NSString *drawTxt=@"空";
        if(model){
            if ([model.talkStatus isEqualToNumber:[NSNumber numberWithInt:4]]) {
                detailStr=[NSString stringWithFormat:@"%@(%@)(等待验证)",model.parameterName,model.customParameter];
            }else{
                detailStr=[NSString stringWithFormat:@"%@(%@)",model.parameterName,model.customParameter];
            }
            drawTxt=[Tool subStringByRange:model.parameterName];
        }
        ChannelHeadSettingView *headViewCenter=[ChannelHeadSettingView initWithNib];
        headViewCenter.frame=CGRectMake(width-width/2, 0, width, width);
        headViewCenter.titleLbl.text=@"主聊频道";
        headViewCenter.detailLbl.text=detailStr;
        headViewCenter.tag=5;
        [self.groupChatOne addSubview:headViewCenter];
        if (model.logo.length<10) {
            headIcon *icon=[headIcon initWithHeadNib];
            icon.centerWordLbl.text=drawTxt;
            icon.frame=CGRectMake(headViewCenter.bgImgView.frame.origin.x, headViewCenter.bgImgView.frame.origin.y,80, 80);
            [headViewCenter addSubview:icon];
        }else{
            [headViewCenter.bgImgView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
        }
        [headViewCenter addGestureRecognizer:tap];
    }
}
/**
 *  WEME终端数据设置
 *
 *
 */
-(void)weMeThirdModelShow:(NSString*)title arr:(NSArray*)arr{
    for (UIView *view in self.groupChatOne.subviews)
    {
        [view removeFromSuperview];
    }
    float width = (self.frame.size.width - 1) / 2;
    NSString *detailTxtLeft=@"暂未关联";
    NSString *detailTxtRight=@"暂未关联";
    NSString *drawTxtLeft=@"空";
    NSString *drawTxtRight=@"空";
    SetModelZFJ *model=[SetModelZFJ new];
    SetModelZFJ *modelActionTypeFour=[SetModelZFJ new];
    SetModelZFJ *modelActionTypeFive=[SetModelZFJ new];
    if (arr.count==1) {
        model=[arr firstObject];
        NSDictionary *dic=[self getDetailAndDrawTxt:model];
        if ([dic objectForKey:@"detailTxtLeft"]) {
            detailTxtLeft=[dic objectForKey:@"detailTxtLeft"];
        };
        if ([dic objectForKey:@"detailTxtRight"]) {
            detailTxtRight=[dic objectForKey:@"detailTxtRight"];
        }
        if ([dic objectForKey:@"drawTxtLeft"]) {
            drawTxtLeft=[dic objectForKey:@"drawTxtLeft"];
        }
        if ([dic objectForKey:@"drawTxtRight"]) {
            drawTxtRight=[dic objectForKey:@"drawTxtRight"];
        }
    }else if(arr.count>=2){
        for (SetModelZFJ *item in arr) {
            if ([item.actionType isEqualToString:@"4"]) {
                modelActionTypeFour=item;
            }else if([item.actionType isEqualToString:@"5"]){
                modelActionTypeFive=item;
            }
            NSDictionary *dic=[self getDetailAndDrawTxt:item];
            if ([dic objectForKey:@"detailTxtLeft"]) {
                detailTxtLeft=[dic objectForKey:@"detailTxtLeft"];
            };
            if ([dic objectForKey:@"detailTxtRight"]) {
                detailTxtRight=[dic objectForKey:@"detailTxtRight"];
            }
            if ([dic objectForKey:@"drawTxtLeft"]) {
                drawTxtLeft=[dic objectForKey:@"drawTxtLeft"];
            }
            if ([dic objectForKey:@"drawTxtRight"]) {
                drawTxtRight=[dic objectForKey:@"drawTxtRight"];
            }
        }
    }
    UITapGestureRecognizer *tapLeft=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
    tapLeft.delegate=self;
    tapLeft.numberOfTapsRequired=1;
    tapLeft.numberOfTouchesRequired=1;
    
    ChannelHeadSettingView *headViewLeft=[ChannelHeadSettingView initWithNib];
    headViewLeft.frame=CGRectMake(0, 0, width, width);
    headViewLeft.titleLbl.text=@"+键设置";
    headViewLeft.detailLbl.text=detailTxtLeft;
    headViewLeft.tag=4;
    [self.groupChatOne addSubview:headViewLeft];
    if(modelActionTypeFour.logo.length<10){
        headIcon *icon=[headIcon initWithHeadNib];
        icon.centerWordLbl.text=drawTxtLeft;
        icon.frame=CGRectMake(headViewLeft.bgImgView.frame.origin.x, headViewLeft.bgImgView.frame.origin.y,80, 80);
        [headViewLeft addSubview:icon];
    }else{
        [headViewLeft.bgImgView sd_setImageWithURL:[NSURL URLWithString:modelActionTypeFour.logo] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
    }
    [headViewLeft addGestureRecognizer:tapLeft];
    
    UITapGestureRecognizer *tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
    tapRight.delegate=self;
    tapRight.numberOfTapsRequired=1;
    tapRight.numberOfTouchesRequired=1;
    
    ChannelHeadSettingView *headViewRight=[ChannelHeadSettingView initWithNib];
    headViewRight.frame=CGRectMake(width+1, 0, width, width);
    headViewRight.titleLbl.text=@"++键设置";
    headViewRight.detailLbl.text=detailTxtRight;
    headViewRight.tag=5;
    [self.groupChatOne addSubview:headViewRight];
    if (modelActionTypeFive.logo.length<10) {
        headIcon *iconRight=[headIcon initWithHeadNib];
        iconRight.centerWordLbl.text=drawTxtRight;
        iconRight.frame=CGRectMake(headViewRight.bgImgView.frame.origin.x, headViewLeft.bgImgView.frame.origin.y,80, 80);
        [headViewRight addSubview:iconRight];
    }else{
        [headViewRight.bgImgView sd_setImageWithURL:[NSURL URLWithString:modelActionTypeFive.logo] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[headIcon class]]) {
                [view removeFromSuperview];
            }
        }
    }
    [headViewRight addGestureRecognizer:tapRight];

}


//频道设置数据配置函数
- (void)setGroupChatOneValue:(NSArray *)array
{
//    NSLog(@"array:%@",array);
    BOOL isHasAddKey=NO;
    NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
    float width = (self.frame.size.width - 1) / 2;
    for (UIView *view in self.groupChatOne.subviews)
    {
        [view removeFromSuperview];
    }
    if(array.count==1)
    {
        SetModelZFJ *model = [array firstObject];
        
        UIView *view = [[UIView alloc]init];
        if ([self.isthirdModel isEqualToString:@"0"]) {
            view.frame=CGRectMake(width+1, 0, width, width);
        }else{
            view.frame=CGRectMake((self.frame.size.width-width)/2, (self.frame.size.height-width)/2, width, width);
        }
        [self.groupChatOne addSubview:view];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
        tap.delegate=self;
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired=1;
        [view addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
       
        
        if([model.actionType isEqualToString:@"4"])
        {
            label.text = @"+键设置";
            [PersonInfo sharePersonInfo].JiaKeyNumber = model.parameterName;
        }
        else if ([model.actionType isEqualToString:@"5"])
        {
            label.text = @"++键设置";
            [PersonInfo sharePersonInfo].JiaJiaKeyNumber = model.parameterName;
        }
        [view addSubview:label];
        
        if(model.logo.length>0){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
            
            [image setImageWithURLOfZFJ:model.logo placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
            [view addSubview:image];
        }else{
            drawHeadIcon *headIcon=[[drawHeadIcon alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
            if ([self.isthirdModel isEqualToString:@"0"]) {
                headIcon.isBoldBottomAndRight=YES;
            }
            if (model.parameterName.length>0) {
                headIcon.drawTxt=[Tool subStringByRange:model.parameterName];
            }
            
            [view addSubview:headIcon];
            
            if ([self.isthirdModel isEqualToString:@"0"]) {
                UIView *view = [[UIView alloc]init];
                view.tag=4;
                view.frame=CGRectMake((self.frame.size.width-width)/20, (self.frame.size.height-width)/2, width, width);
                [self.groupChatOne addSubview:view];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.text=@"+键设置";
                [view addSubview:label];
                
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
                tap.delegate=self;
                tap.numberOfTapsRequired=1;
                tap.numberOfTouchesRequired=1;
                [view addGestureRecognizer:tap];
                if (model.logo.length>0) {
                    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                    [image setImageWithURLOfZFJ:@"" placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
                    [view addSubview:image];
                }else{
                    drawHeadIcon *headIcon=[[drawHeadIcon alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                    //headIcon.isBoldBottomAndRight=YES;
                    headIcon.drawTxt=@"空";
                    [view addSubview:headIcon];
                }
                
                
                UILabel *parameterName = [[UILabel alloc]initWithFrame:CGRectMake(10, width-20-20, width, 40)];
                parameterName.text = @"暂未关联任何频道";
                parameterName.textAlignment = NSTextAlignmentCenter;
                parameterName.numberOfLines=0;
                parameterName.font = [UIFont systemFontOfSize:14];
                [view addSubview:parameterName];
            }
        }
        
        UILabel *parameterName = [[UILabel alloc]initWithFrame:CGRectMake(10, width-20-20, width, 40)];
        //审核未通过
        if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
            parameterName.text =[NSString stringWithFormat:@"%@(%@)(等待验证)",model.parameterName,model.customParameter];
        }else{
            parameterName.text=[NSString stringWithFormat:@"%@(%@)",model.parameterName,model.customParameter];
            
        }
        parameterName.numberOfLines=0;
        parameterName.font = [UIFont systemFontOfSize:14];
        parameterName.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:parameterName];
    }
    else
    {
        
        
        for (SetModelZFJ *model in array)
        {
            
            NSString *actionType = [NSString stringWithFormat:@"%@",model.actionType];
            if ([self.isthirdModel isEqualToString:@"0"]) {
                if([actionType isEqualToString:@"4"]||[actionType isEqualToString:@"5"])
                {
                    UIView *view = [[UIView alloc]init];
                    view.tag=[model.actionType integerValue];
                    [self.groupChatOne addSubview:view];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 20)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:12];
                    [view addSubview:label];
                    
                    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
                    tap.delegate=self;
                    tap.numberOfTapsRequired=1;
                    tap.numberOfTouchesRequired=1;
                    [view addGestureRecognizer:tap];
                    
                    if (model.logo.length>0) {
                        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                        [image setImageWithURLOfZFJ:model.logo placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
                        [view addSubview:image];
                    }else{
                        
                        drawHeadIcon *headIcon=[[drawHeadIcon alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                        if (model.parameterName.length>0) {
                            headIcon.drawTxt=[Tool subStringByRange:model.parameterName];
                        }
                        headIcon.isBoldBottomAndRight=YES;
                        [view addSubview:headIcon];
                    }
                    
                    
                    UILabel *parameterName = [[UILabel alloc]initWithFrame:CGRectMake(0, width-20-20, width, 40)];
                    //审核未通过
                    if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
                        //                        parameterName.text =[NSString stringWithFormat:@"%@(等待验证)",model.parameterName];
                        parameterName.text =[NSString stringWithFormat:@"%@(%@)(等待验证)",model.parameterName,model.customParameter];
                    }else{
                        //                        parameterName.text = model.parameterName;
                        parameterName.text=[NSString stringWithFormat:@"%@(%@)",model.parameterName,model.customParameter];
                    }
                    parameterName.numberOfLines=0;
                    parameterName.font = [UIFont systemFontOfSize:14];
                    parameterName.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:parameterName];
//                    NSLog(@"================%@=---",actionType);
                    if([actionType isEqualToString:@"4"])
                    {
                        isHasAddKey=YES;
                        view.frame = CGRectMake(0, 0, width, width);
                        label.text = @"+键设置";
                        [PersonInfo sharePersonInfo].JiaKeyNumber = model.parameterName;
                    }
                    else if ([actionType isEqualToString:@"5"])
                    {
                        view.frame = CGRectMake(width+1, 0, width, width);
                        label.text = @"++键设置";
                        [PersonInfo sharePersonInfo].JiaJiaKeyNumber = model.parameterName;
                    }
                    
                    if ([isThirdModel isEqualToString:@"1"]) {
                        view.frame=CGRectMake((self.frame.size.width-width)/2, (self.frame.size.height-width)/2, width, width);
                        label.text=@"主聊频道";
                    }
                }
                else
                {
                    [PersonInfo sharePersonInfo].makeComplaintsJKeyNumber = model.customType;
                }
                
            }else{
                if([actionType isEqualToString:@"5"])
                {
                    UIView *view = [[UIView alloc]init];
                    view.tag=[model.actionType integerValue];
                    [self.groupChatOne addSubview:view];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 20)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:12];
                    [view addSubview:label];
                    
                    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
                    tap.delegate=self;
                    tap.numberOfTapsRequired=1;
                    tap.numberOfTouchesRequired=1;
                    [view addGestureRecognizer:tap];
                    
                    if (model.logo.length>0) {
                        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                        [image setImageWithURLOfZFJ:model.logo placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
                        [view addSubview:image];
                    }else{
                        drawHeadIcon *headIcon=[[drawHeadIcon alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                        //                        、、、、、、、
                        if (model.parameterName.length>0) {
                            headIcon.drawTxt=[Tool subStringByRange:model.parameterName];
                        }
                        [view addSubview:headIcon];
                    }
                    
                    
                    UILabel *parameterName = [[UILabel alloc]initWithFrame:CGRectMake(10, width-20-20, width, 40)];
                    //审核未通过
                    if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
                        //                        parameterName.text =[NSString stringWithFormat:@"%@(等待验证)",model.parameterName];
                        parameterName.text =[NSString stringWithFormat:@"%@(%@)(等待验证)",model.parameterName,model.customParameter];
                    }else{
                        //                        parameterName.text = model.parameterName;
                        parameterName.text=[NSString stringWithFormat:@"%@(%@)",model.parameterName,model.customParameter];
                    }
                    parameterName.textAlignment = NSTextAlignmentCenter;
                    parameterName.numberOfLines=0;
                    parameterName.font = [UIFont systemFontOfSize:14];
                    [view addSubview:parameterName];
                    
                    if([actionType isEqualToString:@"4"])
                    {
                        isHasAddKey=YES;
                        view.frame = CGRectMake(0, 0, width, width);
                        label.text = @"+键设置";
                        [PersonInfo sharePersonInfo].JiaKeyNumber = model.parameterName;
                    }
                    else if ([actionType isEqualToString:@"5"])
                    {
                        view.frame = CGRectMake(width+1, 0, width, width);
                        label.text = @"++键设置";
                        [PersonInfo sharePersonInfo].JiaJiaKeyNumber = model.parameterName;
                    }
                    
                    if ([isThirdModel isEqualToString:@"1"]) {
                        view.frame=CGRectMake((self.frame.size.width-width)/2, (self.frame.size.height-width)/2, width, width);
                        label.text=@"主聊频道";
                    }
                }
                else
                {
                    [PersonInfo sharePersonInfo].makeComplaintsJKeyNumber = model.customType;
                }
            }
            /**
             *  当没有设置+键关联的时候 开始===============
             */
            

            if (array.count==2&&[self.isthirdModel isEqualToString:@"0"]&&!isHasAddKey) {
                UIView *view = [[UIView alloc]init];
                view.tag=4;
                view.frame=CGRectMake((self.frame.size.width-width)/20, (self.frame.size.height-width)/2, width, width);
                [self.groupChatOne addSubview:view];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.text=@"+键设置";
                [view addSubview:label];
                
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopRedirect:)];
                tap.delegate=self;
                tap.numberOfTapsRequired=1;
                tap.numberOfTouchesRequired=1;
                [view addGestureRecognizer:tap];
                if (model.logo.length>0) {
                    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                    [image setImageWithURLOfZFJ:@"" placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
                    [view addSubview:image];
                }else{
                    drawHeadIcon *headIcon=[[drawHeadIcon alloc]initWithFrame:CGRectMake((width-100)/2+20, (width-100)/2, 80, 80)];
                    //headIcon.isBoldBottomAndRight=NO;
                    headIcon.drawTxt=@"空";
                    [view addSubview:headIcon];
                }
                
                
                UILabel *parameterName = [[UILabel alloc]initWithFrame:CGRectMake(10, width-20-20, width, 40)];
                parameterName.text = @"暂未关联任何频道";
                parameterName.textAlignment = NSTextAlignmentCenter;
                parameterName.numberOfLines=0;
                parameterName.font = [UIFont systemFontOfSize:14];
                [view addSubview:parameterName];
                
            }
            /**
             *  当没有设置+键关联的时候 结束===============
             */
            
        }
    }
    
}

#pragma 敲击top cell跳转到 我的新建频道
/**
 *  敲击top cell跳转到 我的新建频道
 */
-(void)tapTopRedirect:(UIGestureRecognizer*)recognizer{
    NSLog(@"tag:%ld",(long)recognizer.view.tag);
    if ([self.delegate respondsToSelector:@selector(topCellRedict:)]) {
        [self.delegate topCellRedict:recognizer];
    }
    
}



//热门推荐数据配置
- (void)setGroupChatThreeValue:(NewChannelModel *)model classArray:(NSArray *)classArray
{
    
    if ([PersonInfo sharePersonInfo].isThirdModel){
        NSMutableArray *numberArr = [[NSMutableArray alloc]init];
        
        if(classArray.count>0)
        {
            for (int i=0; i<classArray.count; i++)
            {
                SetModelZFJ *modelClass = [classArray objectAtIndex:i];
                NSString *number = modelClass.customParameter;
                [numberArr addObject:number];
            }
        }
        if ([numberArr indexOfObject:model.number] != NSNotFound)
        {
            NSInteger arrIndex=[numberArr indexOfObject:model.number];//关联键的数组下标
            SetModelZFJ *model=[classArray objectAtIndex:arrIndex];//得到关联键的信息
//             NSLog(@"-------------%@",model.actionType);
            if ([self.isthirdModel isEqualToString:@"1"]) {
                if ([model.actionType isEqualToString:@"5"]) {
                [self.GCJoinButton setTitle:@"主聊频道" forState:UIControlStateNormal];
                }else{
                [self.GCJoinButton setTitle:@"开始聊天" forState:UIControlStateNormal];
                }
            }else{
                if ([model.actionType isEqualToString:@"0"]) {
                    [self.GCJoinButton setTitle:@"开始聊天" forState:UIControlStateNormal];
                }else if([model.actionType isEqualToString:@"4"]){
                    [self.GCJoinButton setTitle:@"关联+键中" forState:UIControlStateNormal];
                }else if ([model.actionType isEqualToString:@"5"]){
                    [self.GCJoinButton setTitle:@"关联++键中" forState:UIControlStateNormal];
                }
            }
            
//            if ([model.actionType isEqualToString:@"0"]) {
//                [self.GCJoinButton setTitle:@"开始聊天" forState:UIControlStateNormal];
//            }else if([model.actionType isEqualToString:@"4"]){
//                [self.GCJoinButton setTitle:@"关联+键中" forState:UIControlStateNormal];
//            }else if([model.actionType isEqualToString:@"5"]){
//                if ([self.isthirdModel isEqualToString:@"1"]) {
//                    [self.GCJoinButton setTitle:@"主聊频道" forState:UIControlStateNormal];
//                }else{
//                    [self.GCJoinButton setTitle:@"关联++键中" forState:UIControlStateNormal];
//                }
//            }
            //        self.GCJoinButton.hidden = YES;
        }
        else
        {
            self.GCJoinButton.hidden = NO;
        }
    }
    
    //[self.GCImageView sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
    if(model.logoURL.length>0){
        [self.GCImageView sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];

        //*************************回收cell的时候，需要把原先的remove掉//
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[drawHeadIcon class]]) {
                [view removeFromSuperview];
            }
        }
        
    }else{
        drawHeadIcon *headIconImg=[[drawHeadIcon alloc]initWithFrame:CGRectMake(8, 8, 50, 50)];
        if (model.name.length>0) {
            headIconImg.drawTxt=[Tool subStringByRange:model.name];
        }
        [self addSubview:headIconImg];
    }
    
    self.GCName.text = model.name;
    self.channelNumber.text = [NSString stringWithFormat:@"频道号:%@",model.number];
    self.GCNumber.text = [NSString stringWithFormat:@"成员:%@",model.userCount];
    self.GCClass.text = [NSString stringWithFormat:@"分类:%@",model.catalogName];
}

//分类推荐数据配置
- (void)setGroupChatFourValue:(NSArray *)array
{
    NSArray *imageArray=@[@"areaChannel.jpg",@"taxiBro",@"carFriend.JPG",@"friends.JPG",@"carHome.jpg",@"chat.JPG"];
    float width = (self.frame.size.width - 1) / 2;
    if(array.count>0)
    {
        _classArray = array;
        for (UIView *view in self.GroupChatFourView.subviews)
        {
            [view removeFromSuperview];
        }
        for (int i=0; i<array.count; i++)
        {
            //            NSLog(@"-----------%ld",array.count);
            NewChannelModel *model = [array objectAtIndex:i];
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake((width + 1)*(i%2), (width+1)*(i/2), width, width);
            [self.GroupChatFourView addSubview:view];
            
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width-30)];
            image.tag = 700+i;
            //            image.image=[UIImage imageNamed:imageArray[i]];
            //            [image setImageWithURLOfZFJ:@"" placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
            [image sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:imageArray[i]]];
            
            [view addSubview:image];
            
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, width-30, width-20, 30)];
            name.text = model.name;
            //name.textAlignment = NSTextAlignmentCenter;
            name.font = [UIFont systemFontOfSize:16];
            [view addSubview:name];
            
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake((width + 1)*(i%2), (width+1)*(i/2), width, width);
            button.tag = 7000+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.GroupChatFourView addSubview:button];
            [self.GroupChatFourView bringSubviewToFront:button];
        }
    }
    
}
//分类点击事件
- (void)buttonClick:(UIButton *)button
{
    if(_classArray.count>0)
    {
        NSInteger index = button.tag-7000;
        NewChannelModel *model = [_classArray objectAtIndex:index];
        
        if([self.delegate respondsToSelector:@selector(selectClassChannelCell:)])
        {
            [self.delegate selectClassChannelCell:model];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)GCJoinButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickStartChat)]) {
        [self.delegate clickStartChat];
    }
}
@end
