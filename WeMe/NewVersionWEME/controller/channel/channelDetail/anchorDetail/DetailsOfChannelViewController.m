//
//  DetailsOfChannelViewController.m
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailsOfChannelViewController.h"
#import "MemberViewController.h"
#import "MobClick.h"
#import "ZhuTableViewCell.h"
#import "ZhuThreeCell.h"
#import "QRCodeGenerator.h"
#import "ShowBigErWeiMaViewController.h"
#import "ComplaintFriendViewController.h"

@implementation DetailsOfChannelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uiConfig];
}

#pragma mark - 设置UI界面
- (void)uiConfig
{
    self.title = @"频道详情";
    [self getChannelData:self.channelNumber];
    self.DetailsTableView.frame = CGRectMake(0, -15, ScreenWidth, ScreenHeight+15);
    self.DetailsTableView.delegate = self;
    self.DetailsTableView.dataSource = self;
    //self.DetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _QRCode = [[UIButton alloc]init];
    _crowdTitleArr = @[@[@"头像"],@[@"频道号",@"频道名",@"分类",@"关键字",@"二维码"],@[@"频道简介",@"粉丝"],@[@"主播",@"主播简介"],@[@"举报"]];
    _DetailsArray = [[NSMutableArray alloc]init];
    _DetailsTableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark --获取主播频道详情--
- (void)getChannelData:(NSString *)channelNumber
{
    [self refreshWithStatus:YES];
    [RequestEngine getDetailsOfChannelInfors:channelNumber completed:^(NSString *errorCode,NSArray *resultArr) {
        [self refreshWithStatus:NO];
        if([errorCode isEqualToString:@"0"])
        {
            _model = [[NewChannelModel alloc]init];
            _model.channelNumber = _channelNumber;
            [_model setValuesForKeysWithDictionary:[resultArr firstObject]];
            [self.DetailsTableView reloadData];
            _validity = [NSString stringWithFormat:@"%@",_model.validity];
            
            if([_validity isEqualToString:@"1"])
            {
                [self.guanZhuButton setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            else if ([_validity isEqualToString:@"0"])
            {
                [self.guanZhuButton setTitle:@"关注频道" forState:UIControlStateNormal];
            }
            
//            NSString *JiaJiaName = [PersonInfo sharePersonInfo].JiaJiaKeyNumber;//++键名称
//            NSString *JiaName = [PersonInfo sharePersonInfo].JiaKeyNumber;//+键名称
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,获取频道详情失败,请稍后再试吧" delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
            alert.tag = 1911;
            [alert show];
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1911)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark-设置分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _crowdTitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = ((NSArray*)[_crowdTitleArr objectAtIndex:section]).count ;
    return count;
}
#pragma mark-设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 72;
    }
    else if(indexPath.section == 1)
    {
        return 45;
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            NSString *channelIntro = @"";
            if(_model.introduction != nil)
            {
                channelIntro = _model.introduction;
            }
            else
            {
                channelIntro = @"该频道没有简介";
            }
            CGRect rect = [self dynamicHeight:channelIntro];
            if(rect.size.height>45)
            {
                return rect.size.height;
            }
            else
            {
                return 45;
            }
        }
        else
        {
            return 45;
        }
    }
    else if(indexPath.section == 3)
    {
        if(indexPath.row == 1)
        {
            NSString *chiefAnnouncerIntr = @"";
            if(_model.chiefAnnouncerIntr != nil)
            {
                chiefAnnouncerIntr = _model.chiefAnnouncerIntr;
            }
            else
            {
                chiefAnnouncerIntr = @"该主播很懒,没有简介";
            }
            CGRect rect = [self dynamicHeight:chiefAnnouncerIntr];
            if(rect.size.height>45)
            {
                return rect.size.height;
            }
            else
            {
                return 45;
            }
        }
        else
        {
            return 45;
        }
    }
    else
    {
        return 45;
    }
}
#pragma mark-设置tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString * indentifer = @"cell1";
        ZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ZhuTableViewCell" owner:nil options:nil][0];
        }
        if(_model!=nil)
        {
            [cell fileDataWithModel:_model];
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.font = kLevelTwoFont;
            cell.textLabel.textColor = kLevelTwoColor;
        }
        [self setUITableViewCellOfDetailTextLabelWith:cell cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = [[_crowdTitleArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)setUITableViewCellOfDetailTextLabelWith:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *view in cell.subviews)
    {
        if([view isKindOfClass:[UILabel class]]||[view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-208, 0, 200, cell.frame.size.height)];
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 0;
    label.font = kLevelThreeFont;
    label.textColor = kLevelThreeColor;
    [cell addSubview:label];
    if(indexPath.section==1)
    {
        if(indexPath.row==0||indexPath.row==1||indexPath.row==2||indexPath.row==3)
        {
            if(indexPath.row==0)
            {
                label.text = _model.channelNumber.length==0?@"":_model.channelNumber;
            }
            else if(indexPath.row==1)
            {
                label.text = _model.name.length==0?@"":_model.name;
            }
            else if(indexPath.row==2)
            {
                label.text = _model.catalogName.length==0?@"":_model.catalogName;
            }
            else if(indexPath.row==3)
            {
                label.text = _model.keyWords.length==0?@"":_model.keyWords;
            }
        }
        else if (indexPath.row==4)
        {
            //二维码
            label.hidden = YES;
            UIImageView *erweimaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-45-8, 0, 45, 45)];
            erweimaImageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@%@",_channelNumber,@"|3"] imageSize:erweimaImageView.bounds.size.width];
            [cell addSubview:erweimaImageView];
        }
    }
    if(indexPath.section==2)
    {
        
        if(indexPath.row==0)
        {
            label.text = _model.introduction.length==0?@"该频道没有简介":_model.introduction;
            if(_model.introduction.length>15)
            {
                label.textAlignment = NSTextAlignmentLeft;
            }
        }
        else if(indexPath.row==1)
        {
            label.text = [NSString stringWithFormat:@"粉丝: %@/%@",_model.onlineCount,_model.userCount];
        }
    }
    if(indexPath.section==3)
    {
        if(indexPath.row==0)
        {
            label.text = _model.chiefAnnouncerName.length==0?@"":_model.chiefAnnouncerName;
        }
        else if(indexPath.row==1)
        {
            label.text = _model.chiefAnnouncerIntr.length==0?@"该主播很懒,没有简介":_model.chiefAnnouncerIntr;
            if(_model.chiefAnnouncerIntr.length>15)
            {
                label.textAlignment = NSTextAlignmentLeft;
            }

        }
    }
    CGRect rect = [self dynamicHeight:label.text];
    CGRect labelfram = label.frame;
    if(rect.size.height>45)
    {
        labelfram.size.height = rect.size.height;
    }
    label.frame = labelfram;
}
#pragma mark-tableView选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1)
    {
        if(indexPath.row == 4)
        {
            ShowBigErWeiMaViewController *svc = [[ShowBigErWeiMaViewController alloc]init];
            svc.type = @"|3";
            svc.isZhubo = YES;
            svc.model = _model;
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
    else if (indexPath.section == 4)
    {
        if(indexPath.row == 0)
        {
            UIStoryboard *stord = [UIStoryboard storyboardWithName:@"ComplaintFriendViewController" bundle:nil];
            ComplaintFriendViewController *complain = [stord instantiateInitialViewController];
            complain.reportChannel = YES;
            complain.reportObject = _model.channelNumber;
            [self.navigationController pushViewController:complain animated:YES];
        }
    }
}
#pragma mark-关注频道
- (IBAction)guanZhuButton:(UIButton *)sender
{
    if (!_isGenduo)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
    }
    NSString *followType = @"";
    if([_validity isEqualToString:@"1"])//已经关注
    {
        followType = @"2";//取消关注
        _validity = @"0";
    }
    else if([_validity isEqualToString:@"0"])//没有关注
    {
        followType = @"1";//开始关注
        _validity = @"1";
    }
    [self refreshWithStatus:YES];
    [RequestEngine followMicroChannelWithChannelNum:self.channelNumber uniqueCode:_model.InviteUniqueCode type:followType completed:^(NSString *errorCode) {
        [self refreshWithStatus:NO];
        if([errorCode isEqualToString:@"0"])
        {
            if([followType isEqualToString:@"1"])
            {
                Alert(@"主人,你成功关注了该频道哦");
                [sender setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            else if ([followType isEqualToString:@"2"])
            {
                Alert(@"主人,你成功取消了对该频道的关注哦");
                [sender setTitle:@"关注频道" forState:UIControlStateNormal];
            }
        }
    }];
}

-(CGRect)dynamicHeight:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
    if ([_validity isEqualToString:@"1"]) {
        [self.guanZhuButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }else{
        [self.guanZhuButton setTitle:@"关注频道" forState:UIControlStateNormal];
    }
//    if([_model.isJoined isEqualToString:@"1"]){
//        [self.guanZhuButton setTitle:@"取消关注" forState:UIControlStateNormal];
//    }else{
//        [self.guanZhuButton setTitle:@"关注频道" forState:UIControlStateNormal];
//    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
    _isGenduo = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end