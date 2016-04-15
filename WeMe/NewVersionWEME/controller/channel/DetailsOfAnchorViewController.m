//
//  DetailsOfAnchorViewController.m
//  微密
//
//  Created by MacDev on 15/4/17.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailsOfAnchorViewController.h"
#import "QunTableViewCell.h"
#import "TestViewController.h"
#import "MemberViewController.h"
#import "ComplaintFriendViewController.h"
#import "ShowBigErWeiMaViewController.h"
#import "SetModelZFJ.h"
#import "Pin_Dao_SetViewController.h"
#import "MBProgressHUD+MJ.h"

@interface DetailsOfAnchorViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NewChannelModel * _model;
    UIAlertView    *_alert;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;//关注或者取消关注按钮

/**
 *  是否是第三方设备 1是  0不是
 */
@property(nonatomic,copy)NSString* isThirdDevice;

@end

@implementation DetailsOfAnchorViewController

-(NSString *)isThirdDevice{
    if (_isThirdDevice==nil) {
        _isThirdDevice=[UserDefaults objectForKey:@"isThirdModel"];
    }
    return _isThirdDevice;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isGenduo = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingChanged) name:@"AddSettingViewController" object:nil];
    
    self.title = @"频道详情";
    [self getChannelData];
    
    _accountIDString = [PersonInfo sharePersonInfo].accountIDString;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    if([_model.accountID isEqualToString:_accountIDString])
    {
        _isJoined = @"1";
    }
}
- (void)settingChanged
{
    //NSLog(@"接收到通知----");
    [self getChannelData];
}
#pragma mark - 判断用户权限
- (void)judgementIsShow:(NewChannelModel *)model

{
    if(model!=nil)
    {
        NSIndexPath *indexPath1 = nil;
        NSIndexPath *indexPath2 = nil;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        //判断是否加入频道
        if(![model.isJoined isEqualToString:@"1"])
        {
            indexPath1 = [NSIndexPath indexPathForRow:0 inSection:4];
            [array addObject:indexPath1];
        }
        //判断是否是管理员  不是
        if(![_model.accountID isEqualToString:_accountIDString])
        {
            indexPath2 = [NSIndexPath indexPathForRow:0 inSection:3];
            [array addObject:indexPath2];
        }
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
        _sectionsNum = 6 - array.count;
        [_tableView endUpdates];
    }
}
#pragma mark --获取群聊频道详情--
- (void)getChannelData
{
    __weak typeof(self) selfVc=self;
    _sectionsNum = 6;
    [self refreshWithStatus:YES];
    NSString * number = _getmodel.number.length==0?_channelNumber:_getmodel.number;
    [RequestEngine getSecretChannelInfoWithChannelNumber:number completed:^(NSString *errorCode, NewChannelModel *model) {
        [self refreshWithStatus:NO];
        
        if ([errorCode isEqualToString:@"0"]&&model!=nil)
        {
            if(_model==nil)
            {
                _model = [[NewChannelModel alloc]init];
            }
            _model = model;
            _model.channelNumber = _channelNumber;
            _accountID = model.accountID;
            _isJoined = [NSString stringWithFormat:@"%@",model.isJoined];
            _bindKey = [NSString stringWithFormat:@"%@",_model.bindKey];
            if([[NSString stringWithFormat:@"%@",model.isJoined] isEqualToString:@"1"])
            {
                
                //......获取关联键
                [RequestEngine getUserkeyInfo:@"" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
                    SetModelZFJ *setModel = [[SetModelZFJ alloc]init];
                    NSArray *array = resultDic[@"list"];
                    for (NSDictionary *dic in array) {
                        NSString *customParameter=dic[@"customParameter"];
                        if([customParameter isEqualToString:selfVc.channelNumber]){
                            [setModel setValuesForKeysWithDictionary:dic];
                        }
                    
                    }
                    NSString *talkStatus=[NSString stringWithFormat:@"%@",setModel.talkStatus];
                    if ([self.isThirdDevice isEqualToString:@"1"]) {
                        if ([_bindKey isEqualToString:@"5"]) {
                            
                            if ([talkStatus isEqualToString:@"4"]) {
                               [_guanzhuButton setTitle:@"等待验证" forState:UIControlStateNormal];
                            }else{
                                [_guanzhuButton setTitle:@"主聊频道" forState:UIControlStateNormal];
                            }
                        }else{
                            [_guanzhuButton setTitle:@"开始聊天" forState:UIControlStateNormal];
                        }
                    }else{
                        if ([_bindKey isEqualToString:@"4"]) {
                        if ([talkStatus isEqualToString:@"4"]) {
                            [_guanzhuButton setTitle:@"等待验证" forState:UIControlStateNormal];
                        }else{
                            [_guanzhuButton setTitle:@"关联+键中" forState:UIControlStateNormal];
                        }
                        }else if ([_bindKey isEqualToString:@"5"]){
                            if ([talkStatus isEqualToString:@"4"]) {
                                [_guanzhuButton setTitle:@"等待验证" forState:UIControlStateNormal];
                            }else{
                                [_guanzhuButton setTitle:@"关联++键中" forState:UIControlStateNormal];
                            }
                        }else{
                            [_guanzhuButton setTitle:@"开始聊天" forState:UIControlStateNormal];
                        }
                    }
                    
                }];
            
            }else{
                [_guanzhuButton setTitle:@"开始聊天" forState:UIControlStateNormal];
            }
            [_tableView reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,获取频道详情失败,请稍后再试吧" delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
            alert.tag = 190;
            [alert show];
        }
    }];
}
//#pragma mark - 提示更改关联键状态
//-(void)changeConnectionState
//{
//    if ([PersonInfo sharePersonInfo].isThirdModel) {
//                NSString *messageStr= @"主人,关联新的频道后之前的频道会被覆盖掉,你将在新的频道里聊天噢";
//            _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联++键", nil];
//                [_alert show];
//            }else{
//                NSString *messageStr= @"主人,关联新的频道后之前的频道会被覆盖掉,你将在新的频道里聊天噢";
//                _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联+键",@"关联++键", nil];
//                [_alert show];
//            }
//
//}


#pragma mark - tableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_model!=nil&&_isJoined!=nil)
    {
        //判断是否加入频道 不是
        if(![[NSString stringWithFormat:@"%@",_model.isJoined] isEqualToString:@"1"])
        {
            _sectionsNum--;
        }
        //判断是否是管理员  不是
        if(![_model.accountID isEqualToString:_accountIDString])
        {
            _sectionsNum--;
        }
    }
    if (_sectionsNum==6) {
        _sectionsNum--;
    }
    return _sectionsNum;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString * indentifer = @"cell1";
        QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        if(_model!=nil)
        {
            [cell fileDataWithModel:_model andType:@"|1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
            if (!cell)
            {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:1];
            }
            [cell.erWeiMaButton addTarget:self action:@selector(erWeiMaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(_model!=nil)
            {
                
                 [cell fileDataWithModel:_model andType:@"|1"];
            }
            return cell;
        }
        else
        {
            QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell)
            {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:4];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(_model!=nil)
            {
                 [cell fileDataWithModel:_model andType:@"|1"];
            }
            CGRect rect = cell.jianjieLalble.frame;
            float getheight = [self getheight];
            if(getheight>45)
            {
                rect.size.height = [self getheight];
            }
            cell.jianjieLalble.frame = rect;
            return cell;
        }
    }
    else if(indexPath.section == 2)
    {
        QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.memberButton addTarget:self action:@selector(checkOuntMembers:) forControlEvents:UIControlEventTouchUpInside];
        if(_model!=nil)
        {
             [cell fileDataWithModel:_model andType:@"|1"];
        }
        return cell;
    }
    else if(indexPath.section == 3)
    {
        if(_sectionsNum == 5)
        {
            QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell)
            {
                //判断是否加入频道
                if(![[NSString stringWithFormat:@"%@",_model.isJoined] isEqualToString:@"1"])
                {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:3];
                    //频道信息修改
                    [cell.gongkaiSwitch addTarget:self action:@selector(gongkaiSwitch:) forControlEvents:UIControlEventValueChanged];
                    [cell.yanzhenSwitch addTarget:self action:@selector(yanzhenSwitch:) forControlEvents:UIControlEventValueChanged];
                    _cellAtIndexRow_Open = indexPath.row;
                    _atSection_Open = indexPath.section;
                }
                else
                {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:3];
                    [cell.JiaKeySwitch addTarget:self action:@selector(JiaKeySwitch:) forControlEvents:UIControlEventValueChanged];
                    [cell.JiaJiaKeySwitch addTarget:self action:@selector(JiaJiaKeySwitch:) forControlEvents:UIControlEventValueChanged];
                    _cellAtIndexRow = indexPath.row;
                    _atSection = indexPath.section;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.memberButton addTarget:self action:@selector(checkOuntMembers:) forControlEvents:UIControlEventTouchUpInside];
            if(_model!=nil)
            {
                [cell fileDataWithModel:_model andType:@"|1"];
                _isVerify = [NSString stringWithFormat:@"%@",_model.isVerify];
                _openType = [NSString stringWithFormat:@"%@",_model.openType];
                if([_openType isEqualToString:@"1"])
                {
                    cell.gongkaiSwitch.on = YES;
                }
                else
                {
                    cell.gongkaiSwitch.on = NO;
                }
                if([_isVerify isEqualToString:@"1"])
                {
                    cell.yanzhenSwitch.on = YES;
                }
                else
                {
                    cell.yanzhenSwitch.on = NO;
                }
                if([_bindKey isEqualToString:@"4"])
                {
                    cell.JiaKeySwitch.on = YES;
                    cell.JiaJiaKeySwitch.on = NO;
                }
                else if([_bindKey isEqualToString:@"5"])
                {
                    cell.JiaKeySwitch.on = NO;
                    cell.JiaJiaKeySwitch.on = YES;
                }
                else
                {
                    cell.JiaKeySwitch.on = NO;
                    cell.JiaJiaKeySwitch.on = NO;
                }

            }
            return cell;
        }
        else
        {
            if(_sectionsNum >= 5)
            {
                QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
                if (!cell)
                {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:3];
                    //频道信息修改
                    [cell.gongkaiSwitch addTarget:self action:@selector(gongkaiSwitch:) forControlEvents:UIControlEventValueChanged];
                    [cell.yanzhenSwitch addTarget:self action:@selector(yanzhenSwitch:) forControlEvents:UIControlEventValueChanged];
                    _cellAtIndexRow_Open = indexPath.row;
                    _atSection_Open = indexPath.section;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.memberButton addTarget:self action:@selector(checkOuntMembers:) forControlEvents:UIControlEventTouchUpInside];
                if(_model!=nil)
                {
                    [cell fileDataWithModel:_model andType:@"|1"];
                    _isVerify = [NSString stringWithFormat:@"%@",_model.isVerify];
                    _openType = [NSString stringWithFormat:@"%@",_model.openType];
                    if([_openType isEqualToString:@"1"])
                    {
                        cell.gongkaiSwitch.on = YES;
                    }
                    else
                    {
                        cell.gongkaiSwitch.on = NO;
                    }
                    if([_isVerify isEqualToString:@"1"])
                    {
                        cell.yanzhenSwitch.on = YES;
                    }
                    else
                    {
                        cell.yanzhenSwitch.on = NO;
                    }

                }
                return cell;
            }
            else
            {
                QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
                if (!cell)
                {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:5];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                return cell;
            }
        }
    }   
//    else if(indexPath.section == 4)
//    {
//        QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
//        if (!cell)
//        {
//            if(_sectionsNum == 4||_sectionsNum == 5)
//            {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:5];
//            }
//            if(_sectionsNum == 6)
//            {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:6];
//                [cell.JiaKeySwitch addTarget:self action:@selector(JiaKeySwitch:) forControlEvents:UIControlEventValueChanged];
//                [cell.JiaJiaKeySwitch addTarget:self action:@selector(JiaJiaKeySwitch:) forControlEvents:UIControlEventValueChanged];
//                _cellAtIndexRow = indexPath.row;
//                _atSection = indexPath.section;
//            }
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.memberButton addTarget:self action:@selector(checkOuntMembers:) forControlEvents:UIControlEventTouchUpInside];
//        if(_model!=nil)
//        {
//            [cell fileDataWithModel:_model andType:@"|1"];
//            if([_bindKey isEqualToString:@"4"])
//            {
//                cell.JiaKeySwitch.on = YES;
//                cell.JiaJiaKeySwitch.on = NO;
//            }
//            else if([_bindKey isEqualToString:@"5"])
//            {
//                cell.JiaKeySwitch.on = NO;
//                cell.JiaJiaKeySwitch.on = YES;
//            }
//            else
//            {
//                cell.JiaKeySwitch.on = NO;
//                cell.JiaJiaKeySwitch.on = NO;
//            }
//        }
//        return cell;
    //}
    else
    {
        QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil] objectAtIndex:5];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}
#pragma mark - +键
- (void)JiaKeySwitch:(UISwitch *)sender
{
    if(sender.on)
    {
        sender.on = YES;
        //关闭+键 ++键是关闭状态
        //[self setOnlyOneUserkeyInfocustomType:@"4"];
        _typeInt = @"4";
    }
    else
    {
        sender.on = NO;
        //打开+键 ++键不管什么状态都要关闭
        _typeInt = @"10086+4";
    }
    [self alertShowWithIndexPathRow:4];//0  +键
}
#pragma mark - ++键
- (void)JiaJiaKeySwitch:(UISwitch *)sender
{
    if(sender.on)
    {
        sender.on = YES;
        //关闭++键 +键是关闭状态
        //[self setOnlyOneUserkeyInfocustomType:@"5"];
        _typeInt = @"5";
    }
    else
    {
        sender.on = NO;
        //打开++键 +键不管什么状态都要关闭
        _typeInt = @"10086+5";
    }
    [self alertShowWithIndexPathRow:5];//0  ++键
}
- (QunTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger) section
{
    QunTableViewCell * cell = (QunTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}
- (void)setOnlyOneUserkeyInfocustomType:(NSString *)actionType channelNumber:(NSString *)channelNumber
{
    if([_isJoined isEqualToString:@"1"])
    {
        QunTableViewCell *cell = [self cellAtIndexRow:_cellAtIndexRow andAtSection:_atSection];
        [self refreshWithStatus:YES];
        [RequestEngine setOnlyOneUserkeyInfocustomType:@"10" actionType:actionType customParameter:channelNumber completed:^(NSString *errorCode, NSDictionary *resultDic) {
            [self refreshWithStatus:NO];
            if([errorCode isEqualToString:@"0"])
            {
                if([actionType isEqualToString:@"4"])
                {
                    cell.JiaJiaKeySwitch.on = NO;
                }
                else if([actionType isEqualToString:@"5"])
                {
                    cell.JiaKeySwitch.on = NO;
                }
                else if([actionType isEqualToString:@"10086+4"])
                {
                    cell.JiaKeySwitch.on = NO;
                }
                else if([actionType isEqualToString:@"10086+5"])
                {
                    cell.JiaJiaKeySwitch.on = NO;
                }
                [self getChannelData];
                _model = nil;
            }
            else
            {
                Alert(@"主人,设置失败了");
                if([_typeInt isEqualToString:@"4"])
                {
                    cell.JiaKeySwitch.on = NO;
                }
                else if([_typeInt isEqualToString:@"5"])
                {
                    cell.JiaJiaKeySwitch.on = NO;
                }
                else if([actionType isEqualToString:@"10086+4"])
                {
                    cell.JiaKeySwitch.on = YES;
                }
                else if([actionType isEqualToString:@"10086+5"])
                {
                    cell.JiaJiaKeySwitch.on = YES;
                }
            }
        }];
    }
    else
    {
        Alert(@"主人,你还没有加入呢,加入才能关联哦");
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //举报
    if (indexPath.section == _sectionsNum-1)
    {
        UIStoryboard *stord = [UIStoryboard storyboardWithName:@"ComplaintFriendViewController" bundle:nil];
        ComplaintFriendViewController *complain = [stord instantiateInitialViewController];
        complain.reportChannel = YES;
        complain.reportObject = _model.accountID;
        [self.navigationController pushViewController:complain animated:YES];
    }
}
#pragma mark - 动态设置行高
- (CGFloat)getheight
{
    UIFont * font = [UIFont systemFontOfSize:13];
    CGRect rect = [_model.introduction boundingRectWithSize:CGSizeMake(181, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 72;
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return 270;
        }
        else
        {
            if(([self getheight]+20)<=45)
            {
                return 45;
            }
            else
            {
                return [self getheight]+20;
            }
        }
    }
    else if(indexPath.section == 2)
    {
        return 90;
    }
    else if(indexPath.section == 3||indexPath.section == 4)
    {
        if(_sectionsNum==4)
        {
            return 45;
        }
        else if(_sectionsNum==5)
        {
            if(indexPath.section == 3)
            {
                return 45;
                //return 90;
            }
            else
            {
                return 45;
            }
        }
        else if(_sectionsNum==6)
        {
//            return 90;
            return 45;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --更改关联状态--
- (IBAction)guanQuButtonClick:(UIButton *)sender
{
    
    if ([self.isThirdDevice isEqualToString:@"1"]) {
        NSString *messageStr= @"主人,关联新的频道后之前的频道会被覆盖掉,你将在新的频道里聊天噢";
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"主聊频道", nil];
        [_alert show];
    }else{
        NSString *messageStr= @"主人,关联新的频道后之前的频道会被覆盖掉,你将在新的频道里聊天噢";
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联+键",@"关联++键", nil];
        [_alert show];
    }
    _alert.tag=119;

//    if (!_isGenduo)
//    {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
//    }
//    
//    if ([_guanzhuButton.titleLabel.text isEqualToString:@"退出频道"])
//    {
//        [self existChannel];
//    }
//    else
//    {
//        [self joinChannel];
//    }
}


#pragma mark--加入频道--
- (void)joinChannel
{
    [self refreshWithStatus:YES];
    //NSString * code = [[_model.InviteUniqueCode componentsSeparatedByString:@"|"]firstObject];
    [RequestEngine joinSecretChannelWithCode:_model.InviteUniqueCode completed:^(NSString *errorCode, NSString *isVerify,NSString *applyIdx) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            if ([isVerify isEqualToString:@"0"]) {
                Alert(@"主人,你已成功加入该频道哟");
                [_guanzhuButton setTitle:@"退出频道" forState:UIControlStateNormal];
                [self getChannelData];
                _model = nil;
            }
            else if ([isVerify isEqualToString:@"1"])
            {
                 _model.applyIdx = applyIdx;
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,你需要填写验证信息才可加入哟,是否继续?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alert.tag = 111;
//                [alert show];
                TestViewController * vc = [[TestViewController alloc]init];
                vc.model = _model;
                vc.isFriend = NO;
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
        else if ([errorCode isEqualToString:@"ME18308"])
        {
            Alert(@"主人,你不能加入自己创建的频道哦");
        }
        else
        {
            Alert(@"主人,你加入该频道失败,请稍后再试哦");
        }
    }];
    
}
#pragma mark --退出频道--
- (void)existChannel
{
    [self refreshWithStatus:YES];
    NSString * number = _channelNumber.length==0?_model.number:_channelNumber;
    NSString * name = _model.name.length==0?@"":_model.name;
    //NSLog(@"%@   %@",number,_model.name);
    [RequestEngine quitSecretChannelWithNumber:number channelName:name completed:^(NSString *errorCode) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"]) {
            Alert(@"主人,您已退出该频道哟");
            [_guanzhuButton setTitle:@"加入频道" forState:UIControlStateNormal];
            [self getChannelData];
            _model = nil;
        }
        else if([errorCode isEqualToString:@"ME18311"])
        {
            NSString *str = @"主人,该频道已关联了+键或者++键,需要关联其它频道才能退出该频道哟";
            UIAlertView *alertShow = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"关联其它频道" otherButtonTitles:@"暂不退出", nil];
            alertShow.tag = 567;
            [alertShow show];
        }
        else
        {
            Alert(@"主人,退出频道失败,请稍后再试哟");
        }
    }];
}

#pragma mark - 警告框代理函数
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (alertView.tag == 111)
    //    {
    //        if (buttonIndex == 1)
    //        {
    //            TestViewController * vc = [[TestViewController alloc]init];
    //            vc.model = _model;
    //            vc.isFriend = NO;
    //            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    //            [self presentViewController:nav animated:YES completion:nil];
    //        }
    //    }
    //    else
    if (alertView.tag == 567)
    {
        if(buttonIndex==0)
        {
            Pin_Dao_SetViewController *pvc = [[Pin_Dao_SetViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
        
        else if (buttonIndex==1)
        {
            //暂不退出
        }
    }
    else if(alertView.tag == 1102)
    {
        if (buttonIndex == 0)
        {
            if([_typeInt isEqualToString:@"10086+4"]||[_typeInt isEqualToString:@"10086+5"])
            {
                NSString *typeStr = [[_typeInt componentsSeparatedByString:@"+"]lastObject];
                [self setOnlyOneUserkeyInfocustomType:typeStr channelNumber:@"10086"];
            }
            else
            {
                [self setOnlyOneUserkeyInfocustomType:_typeInt channelNumber:self.channelNumber];
            }
            
        }
        else
        {
            QunTableViewCell *cell = [self cellAtIndexRow:_cellAtIndexRow andAtSection:_atSection];
            if([_typeInt isEqualToString:@"4"])
            {
                cell.JiaKeySwitch.on = NO;
            }
            else if([_typeInt isEqualToString:@"5"])
            {
                cell.JiaJiaKeySwitch.on = NO;
            }
        }
    }
    else if(alertView.tag == 190)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSString *actionType = nil;
    if(alertView == _alert)
    {
        if ([self.isThirdDevice isEqualToString:@"1"])
        {
          if(buttonIndex == 1){
                //++键设置
                actionType = @"5";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }
        }else{
            if(buttonIndex==1)
            {
                //+键设置
                actionType = @"4";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }else if(buttonIndex == 2){
                //++键设置
                actionType = @"5";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
                
            }
        }
        if([actionType isEqualToString:@"5"]||[actionType isEqualToString:@"4"])
        {
            NSString *uniqueCode = self.getmodel.InviteUniqueCode;
            if (self.getmodel.InviteUniqueCode == nil) {
                uniqueCode = self.uniqueCode;
            }
            
            [RequestEngine setOnlyOneUserkeyInfocustomType:@"10" actionType:actionType customParameter:uniqueCode completed:^(NSString *errorCode, NSDictionary *resultDic) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
//                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                if([errorCode isEqualToString:@"0"])
                {
                    //[MBProgressHUD showSuccess:@"主人设置成功了噢"];
                    
                    //通知上一个页面刷新
                    NSNotification *notif=[[NSNotification alloc]initWithName:togetherTalkNofitificationName object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notif];
                    //需要验证
                    if ([resultDic[@"isVerify"] boolValue]) {
//                        TestViewController *test=[[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
//                        test.model = self.getmodel;
//                        test.applyIdx = resultDic[@"applyIdx"];
//                        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:test];
//                        [self presentViewController:nav animated:YES completion:nil];
//                        [self.guanzhuButton setTitle:@"等待验证" forState:UIControlStateNormal];
                        [self sendJoinChannelValidateMsg:self.getmodel applyIdx:resultDic[@"applyIdx"]];
                    }else{
                        //.............更改关联键................
                        [self changeCombineBtn:actionType];

                    }
                    
                    //[self getUserkeyInfoCompleted];
                }
                else
                {
                    [MBProgressHUD showError:@"主人,设置失败了，稍后再试试哟"];
                }
            }];
        }
        
    }
    
}

/**
 *  改变关联键
 *
 *  @param actionType actionType
 */
-(void)changeCombineBtn:(NSString*)actionType{
    if ([actionType isEqualToString:@"5"]) {
        if ([self.isThirdDevice isEqualToString:@"1"]) {
            
            [self.guanzhuButton setTitle:@"主聊频道" forState:UIControlStateNormal];
            
        }else{
            [self.guanzhuButton setTitle:@"关联++键中" forState:UIControlStateNormal];
        }
    }else if([actionType isEqualToString:@"4"]){
        [self.guanzhuButton setTitle:@"关联+键中" forState:UIControlStateNormal];
    }else if([actionType isEqualToString:@"0"]){
        [self.guanzhuButton setTitle:@"开始聊天" forState:UIControlStateNormal];
    }
}

/**
 *  加入频道如果需要验证发送推送的验证消息
 *
 *  @param model    <#model description#>
 *  @param applyIdx <#applyIdx description#>
 */
-(void)sendJoinChannelValidateMsg:(NewChannelModel*)model applyIdx:(NSString*)applyIdx{
    NSString * channelName = model.name.length==0?@"":model.name;
    NSString * applyIndx = applyIdx;
    NSString * nickName = model.adminName.length==0?@"微密":model.adminName;
    NSString * gender = model.gender.length==0?@"1":model.gender;
    NSString * userAres = model.userArea.length==0?@"上海":model.userArea;
    NSString *accountId=model.accountID.length==0?@"":model.accountID;
    NSDictionary *dict = @{@"msgContent":@"你好，申请加入频道",@"channelName":channelName,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"adminAccountID":accountId,@"applyAccountID":[PersonInfo sharePersonInfo].accountIDString,@"applyIdx":applyIndx,@"adminAccountNickName":nickName,@"gender":gender,@"userArea":userAres};
    [RequestEngine pushJoinSecretChannelMessageWithDic:dict completed:^(NSString *errorCode) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
        if ([errorCode isEqualToString:@"0"])
        {
            NSLog(@"验证消息发送成功!");
            [self.guanzhuButton.titleLabel setText:@"等待验证"];
            Alert(@"主人,设置成功啦");
            
        }
        else
        {
            Alert(@"主人,设置失败啦,稍后再试试哟");
            NSLog(@"验证消息发送失败!");
        }
    }];
    
}

#pragma mark -- 查看频道成员
- (void)checkOuntMembers:(UIButton *)sender
{
    if([_isJoined isEqualToString:@"1"])
    {
        MemberViewController * vc = [[MemberViewController alloc]init];
        vc.channelNumber = _model.number;
        if([_model.accountID isEqualToString:_accountIDString])
        {
            vc.isAdministrator = YES;
        }
        else
        {
            vc.isAdministrator = NO;
        }
        vc.infoType = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        Alert(@"主人,你还没有加入呢,加入才能看哦");
    }
}
#pragma mark - 二维码点击
- (void)erWeiMaButtonClick:(UIButton *)button
{
    ShowBigErWeiMaViewController *svc = [[ShowBigErWeiMaViewController alloc]init];
    svc.type = @"|2";
    svc.model = _model;
    svc.isZhubo = NO;
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark --公开频道
- (void)gongkaiSwitch:(UISwitch *)gongkaiSwitch
{
    NSString *openType;
    if(gongkaiSwitch.on)
    {
        openType = @"1";
    }
    else
    {
        openType = @"0";
    }
    [self modifySecretChannelInfo:self.channelNumber ChannelOpenType:openType isVerify:_isVerify];
}
#pragma mark--需要验证--
- (void)yanzhenSwitch:(UISwitch *)yanzhenSwitch
{
    NSString *isVerify;
    if(yanzhenSwitch.on)
    {
        isVerify = @"1";
    }
    else
    {
        isVerify = @"0";
    }
    [self modifySecretChannelInfo:self.channelNumber ChannelOpenType:_openType isVerify:isVerify];
}
#pragma mark - 公开频道验证频道请求函数
- (void)modifySecretChannelInfo:(NSString *)channelNumber ChannelOpenType:(NSString *)ChannelOpenType isVerify:(NSString *)isVerify
{
    QunTableViewCell *cell = [self cellAtIndexRow:_cellAtIndexRow_Open andAtSection:_atSection_Open];
    [self refreshWithStatus:YES];
    [Request1617 modifySecretChannelInfo:channelNumber ChannelOpenType:ChannelOpenType isVerify:isVerify completed:^(NSString *errorCode, NSString *result) {
        [self refreshWithStatus:NO];
        if([errorCode isEqualToString:@"0"])
        {
            _isVerify = isVerify;
            _openType = ChannelOpenType;
            if([ChannelOpenType isEqualToString:@"0"])
            {
                cell.gongkaiSwitch.on = NO;
            }
            else
            {
                cell.gongkaiSwitch.on = YES;
            }
            if([isVerify isEqualToString:@"0"])
            {
                cell.yanzhenSwitch.on = NO;
            }
            else
            {
                cell.yanzhenSwitch.on = YES;
            }
        }
        else
        {
            Alert(@"主人,你设置失败了哦");
        }
        
    }];
}
#pragma mark - 重新设置+或者++键提示
- (void)alertShowWithIndexPathRow:(NSInteger)indexPathRow
{
    NSString *messageStr;
    if(indexPathRow==4)
    {
        messageStr = @"主人,你如果重新设置了+键,之前关联的频道将要被覆盖掉哦";
    }
    else if (indexPathRow==5)
    {
        messageStr = @"主人,你如果重新设置了++键,之前关联的频道将要被覆盖掉哦";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重设" otherButtonTitles:@"取消", nil];
    alert.tag = 1102;
    [alert show];
}





















@end