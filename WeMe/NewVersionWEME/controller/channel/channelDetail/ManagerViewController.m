//
//  ManagerViewController.m
//  微密
//
//  Created by MacDev on 15/4/17.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ManagerViewController.h"
#import "QunTableViewCell.h"
#import "ComplaintFriendViewController.h"
#import "ShowBigErWeiMaViewController.h"
#import "MemberViewController.h"
#import "newInputViewController.h"
#import "CityPickView.h"
#import "DismissOrChangeTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "PublicAndJoinTableViewCell.h"
@interface ManagerViewController ()<UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DismissOrChangeTableViewCellDelegate,openTestSwitchDelegate,PublicAndJoinTableViewCellDelegate>
{
    NewChannelModel * _model;/////
    NSString * _accountIdStr;//转移的accountId
    NSString * _zhuanYiNickName;//转移者的昵称
    NSArray * _titleArr;
    NSMutableArray * _fenleiArr;
    BOOL _changeImage;//修改头像
    UIImage * _channelImage;//频道的头像
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  开始聊天
 */
@property (weak, nonatomic) IBOutlet UIButton *beginChatBtn;

/**
 *  提示view
 */
@property(nonatomic,strong)UIAlertView *alert;

/**
 *  是否是第三方设备
 */
@property(nonatomic,copy)NSString* isThirdDevice;

@end

@implementation ManagerViewController

-(NSString *)isThirdDevice{
    if (_isThirdDevice==nil) {
        _isThirdDevice=[UserDefaults objectForKey:@"isThirdModel"];
    }
    return _isThirdDevice;
}

#pragma 解散
-(void)dismissChannel{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,您确定不要我了么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 49;
    [alert show];
    
}
- (IBAction)beginChatAction:(UIButton *)sender {
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
}

-(void)changeChannel{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,您确定要转移该频道么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 29;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actionType=nil;
    if (alertView.tag == 29)
    {
        if (buttonIndex == 1)
        {
            MemberViewController * vc = [[MemberViewController alloc]init];
            vc.channelNumber = _model.number;
            vc.infoType = @"1";
            vc.isZhuanYi = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (alertView.tag ==39)
    {
        if (buttonIndex == 1)
        {
            if ([[alertView textFieldAtIndex:0].text isEqualToString: [[NSUserDefaults standardUserDefaults]objectForKey:kpassworldString]])
            {
                [self zhuanyiRequest];
            }
            else
            {
                Alert(@"主人，您的密码输入错误哟");
            }
        }
    }
    else if (alertView.tag == 49)
    {
        if (buttonIndex == 1)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"主人，请输入您的密码哟" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 59;
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alert show];
        }
    }
    else if (alertView.tag == 59)
    {
        if (buttonIndex == 1)
        {
            if ([[alertView textFieldAtIndex:0].text isEqualToString: [[NSUserDefaults standardUserDefaults]objectForKey:kpassworldString]])
            {
                [self jiesanRequest];
            }
            else
            {
                Alert(@"主人，您的密码输入错误哟");
            }
        }
    }
    else if (alertView.tag == 69)
    {
        if (buttonIndex == 1)
        {
            NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":_model.number,@"channelName":_model.name,@"channelIntro":_model.introduction,@"channelCitycode":_model.cityCode,@"channelCatalogID":_model.catalogID,@"channelKeyWords":_model.keyWords,@"channelOpenType":_model.openType.length==0?@"1":_model.openType,@"isVerify":_model.isVerity.length==0?@"0":_model.isVerity};
            
            if (_channelImage)
            {
                [self refreshWithStatus:YES];
                [RequestEngine modifySecretChannelInfoWithDic:dic image:_channelImage completed:^(NSString *errorCode) {
                    [self refreshWithStatus:NO];
                    Alert(@"主人,该频道的信息修改成功了");
                }];
            }
            else
            {
                [self refreshWithStatus:YES];
                [RequestEngine modifySecretChannelInfoWithDic:dic image:nil completed:^(NSString *errorCode) {
                    [self refreshWithStatus:NO];
                    if ([errorCode isEqualToString:@"0"])
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
                        Alert(@"主人,该频道的信息修改成功了");
                    }
                }];
                
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
        }
        else
        {
            //[self getChannelData];
        }
    }
    
    if(alertView == _alert)
    {
        if ([self.isThirdDevice isEqualToString:@"1"])
        {
            if (buttonIndex == 0)
            {
                //取消
            }
            else
            {
                //++键设置
                actionType = @"5";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }
        }else{
            if (buttonIndex == 0)
            {
                //取消
            }
            else if(buttonIndex==1)
            {
                //+键设置
                actionType = @"4";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }else{
                //++键设置
                actionType = @"5";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
                
            }
        }
        if([actionType isEqualToString:@"5"]||[actionType isEqualToString:@"4"])
        {
            [RequestEngine setOnlyOneUserkeyInfocustomType:@"10" actionType:actionType customParameter:_model.InviteUniqueCode completed:^(NSString *errorCode, NSDictionary *resultDic) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                if([errorCode isEqualToString:@"0"])
                {
                    [MBProgressHUD showSuccess:@"主人设置成功了噢"];
                    NSArray * resultArr = [resultDic objectForKey:@"list"];
                    //                    NSString *actionType=nil;
                    //                    actionType=resultArr[0][@"actionType"];
                    if ([actionType isEqualToString:@"5"]) {
                        if ([self.isThirdDevice isEqualToString:@"1"]) {
                            
                            [self.beginChatBtn setTitle:@"主聊频道" forState:UIControlStateNormal];
                            
                        }else{
                            [self.beginChatBtn setTitle:@"关联++键中" forState:UIControlStateNormal];
                        }
                    }else if([actionType isEqualToString:@"4"]){
                        [self.beginChatBtn setTitle:@"关联+键中" forState:UIControlStateNormal];
                    }else if([actionType isEqualToString:@"0"]){
                        [self.beginChatBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getChannelData];
    [self getFenleiData];
    _accountIDString = [PersonInfo sharePersonInfo].accountIDString;
    _fenleiArr = [[NSMutableArray alloc]init];
     _titleArr = @[@[@"频道头像"],@[@"频道名",@"分类",@"关键字",@"地区",@"简介"],@[@"公开频道",@"需要验证"]];
    self.title = @"频道详情";
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhuanyiNotification:) name:@"zhuanyi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewControllerWithTag:) name:@"newInputViewController" object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClicksss)];
}
#pragma mark --保存修改
- (void)saveClicksss
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"主人,您确定修改吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 69;
    [alert show];
}

-(void)pushViewControllerWithTag:(NSNotification *)notifi
{
    NSString *inputTextField = [notifi.userInfo objectForKey:@"inputTextField"];
    NSString *twoTitleLable = [notifi.userInfo objectForKey:@"twoTitleLable"];
    if([twoTitleLable isEqualToString:@"频道名"])
    {
        _model.name = inputTextField;
    }
    else if ([twoTitleLable isEqualToString:@"关键字"])
    {
        _model.keyWords = inputTextField;
    }
    else if ([twoTitleLable isEqualToString:@"简介"])
    {
        _model.introduction = inputTextField;
    }
    [_tableView reloadData];
}

#pragma mark --得到分类--
- (void)getFenleiData
{
    [RequestEngine getCatalogInfoWithType:@"2" startPg:1 pageSize:19 completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *result) {
        if ([errorCode isEqualToString:@"0"]) {
            _fenleiArr = dataArray;
        }
    }];
}

#pragma mark --获取群聊频道详情--
- (void)getChannelData
{
    [self refreshWithStatus:YES];
    [RequestEngine getSecretChannelInfoWithChannelNumber:self.channelNumber completed:^(NSString *errorCode, NewChannelModel *model) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"]&&model!=nil)
        {
            _model = model;
            if([[NSString stringWithFormat:@"%@",model.isJoined] isEqualToString:@"1"]){
                NSString *bindkey=[NSString stringWithFormat:@"%@",_model.bindKey];
            if ([bindkey isEqualToString:@"4"]) {
                [self.beginChatBtn setTitle:@"关联+键中" forState:UIControlStateNormal];
            }else if([bindkey isEqualToString:@"5"]){
                if([self.isThirdDevice isEqualToString:@"1"]){
                    [self.beginChatBtn setTitle:@"主聊频道" forState:UIControlStateNormal];
                }else{
                    [self.beginChatBtn setTitle:@"关联++键中" forState:UIControlStateNormal];
                }
            }else{
                 [self.beginChatBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
            }}else{
                [self.beginChatBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
            }
             _model.channelNumber=_channelNumber;
            _bindKey = [NSString stringWithFormat:@"%@",_model.bindKey];
            [_tableView reloadData];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
             [cell fileDataWithModel:_model andType:@"|2"];
        }
        if (_changeImage&&_channelImage)
        {
            cell.headerImageView.image = _channelImage;
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell)
            {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:1];
            }
            [cell.channelNameButton addTarget:self action:@selector(exchanelTableClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.channelKeyWorkds addTarget:self action:@selector(exchanelTableClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.channelFenleiButton addTarget:self action:@selector(exchanelTableClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.channelArearButton addTarget:self action:@selector(exchanelTableClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.erWeiMaButton addTarget:self action:@selector(erWeiMaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(_model!=nil)
            {
                [cell fileDataWithModel:_model andType:@"|2"];

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
                [cell fileDataWithModel:_model andType:@"|2"];

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
        [cell.memberButton addTarget:self action:@selector(checkOuntMembers:) forControlEvents:UIControlEventTouchUpInside];
        if(_model!=nil)
        {
            [cell fileDataWithModel:_model andType:@"|2"];
        }
        return cell;
    }
    else if(indexPath.section == 3)
    {
//        QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
//        if (cell==nil)
//        {
//            QunTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:8];
//            cell.delegate=self;
//            _cellAtIndexRow_Open = indexPath.row;
//            _atSection_Open = indexPath.section;
//        [cell.openSwitch addTarget:self action:@selector(test:) forControlEvents:UIControlEventValueChanged];
//        }
        PublicAndJoinTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"PublicAndJoinTableViewCell" owner:nil options:nil].lastObject;
            cell.delegate=self;
            _cellAtIndexRow_Open = indexPath.row;
            _atSection_Open = indexPath.section;
        }
        
        if(_model!=nil)
        {
            _isVerify = [NSString stringWithFormat:@"%@",_model.isVerify];
            _openType = [NSString stringWithFormat:@"%@",_model.openType];
//            NSLog(@"-----------%@    %@",_model.isVerify,_model.openType);
//            NSLog(@"============%@    %@",_isVerify,_openType);
            if([_openType isEqualToString:@"1"])
            {
                UISwitch *openSwitch=(UISwitch *)[cell viewWithTag:99];
                openSwitch.on=YES;
            }
            else
            {
                UISwitch *openSwitch=(UISwitch *)[cell viewWithTag:99];
                openSwitch.on=NO;
            }
            if([_isVerify isEqualToString:@"1"])
            {
                UISwitch *testSwitch=(UISwitch *)[cell viewWithTag:999];
                testSwitch.on=YES;
               
            }
            else
            {
                UISwitch *testSwitch=(UISwitch *)[cell viewWithTag:999];
                testSwitch.on=NO;
            }
        }
        return cell;
    }
    //关联++ 和 +
//    else if(indexPath.section == 4)
//    {
//        QunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
//        if (!cell)
//        {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"QunTableViewCell" owner:self options:nil]objectAtIndex:6];
//        }
//        if(_model!=nil)
//        {
//            [cell.JiaKeySwitch addTarget:self action:@selector(JiaKeySwitch:) forControlEvents:UIControlEventValueChanged];
//            [cell.JiaJiaKeySwitch addTarget:self action:@selector(JiaJiaKeySwitch:) forControlEvents:UIControlEventValueChanged];
//            _cellAtIndexRow = indexPath.row;
//            _atSection = indexPath.section;
//            if([[NSString stringWithFormat:@"%@",_bindKey] isEqualToString:@"4"])
//            {
//                cell.JiaKeySwitch.on = YES;
//                cell.JiaJiaKeySwitch.on = NO;
//            }
//            else if([[NSString stringWithFormat:@"%@",_bindKey] isEqualToString:@"5"])
//            {
//                cell.JiaKeySwitch.on = NO;
//                cell.JiaJiaKeySwitch.on = YES;
//            }
//            else
//            {
//                cell.JiaKeySwitch.on = NO;
//                cell.JiaJiaKeySwitch.on = NO;
//            }
//            
//        }
//        return cell;
//    }
    else{
        
        DismissOrChangeTableViewCell *cell=[DismissOrChangeTableViewCell initWithTableView:tableView];
        cell.delegate=self;
        return cell;
    }
}

-(void)test:(UISwitch*)sw{
    NSLog(@"么么哒");
}
#pragma mark ---公开频道--


-(void)openDetailSwitchClick:(UISwitch *)openSwitch
{
    _model.openType=openSwitch.on?@"1":@"0";
     [self modifySecretChannelInfo:self.channelNumber ChannelOpenType:_model.openType isVerify:_model.isVerify];
}

-(void)publicSwitchValueChanged:(UISwitch *)sw{
    _model.openType=sw.on?@"1":@"0";
    [self modifySecretChannelInfo:self.channelNumber ChannelOpenType:_model.openType isVerify:_model.isVerify];
}
-(void)isverfySwitchValueChanged:(UISwitch *)sw{
    _model.isVerify = sw.on?@"1":@"0";
    [self modifySecretChannelInfo:self.channelNumber ChannelOpenType:_model.openType isVerify:_model.isVerify];
}
#pragma mark --需要验证--
-(void)testDetailSwitchClick:(UISwitch *)testSwitch
{
    _model.isVerify = testSwitch.on?@"1":@"0";
    [self modifySecretChannelInfo:self.channelNumber ChannelOpenType:_model.openType isVerify:_model.isVerify];
}

- (QunTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger) section
{
    QunTableViewCell * cell = (QunTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}


- (PublicAndJoinTableViewCell *)cellAtIndexRowPublic:(NSInteger)row andAtSection:(NSInteger) section
{
    PublicAndJoinTableViewCell * cell = (PublicAndJoinTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}


#pragma mark - 公开频道验证频道请求函数
- (void)modifySecretChannelInfo:(NSString *)channelNumber ChannelOpenType:(NSString *)ChannelOpenType isVerify:(NSString *)isVerify
{
//    QunTableViewCell *cell = [self cellAtIndexRow:_cellAtIndexRow_Open andAtSection:_atSection_Open];
    PublicAndJoinTableViewCell *cell = [self cellAtIndexRowPublic:_cellAtIndexRow_Open andAtSection:_atSection_Open];
    [self refreshWithStatus:YES];
    [Request1617 modifySecretChannelInfo:channelNumber ChannelOpenType:ChannelOpenType isVerify:isVerify completed:^(NSString *errorCode, NSString *result) {
        [self refreshWithStatus:NO];
        if([errorCode isEqualToString:@"0"])
        {
            _isVerify = isVerify;
            _openType = ChannelOpenType;
            if([ChannelOpenType isEqualToString:@"0"])
            {
                cell.openSwitch.on = NO;
            }
            else
            {
                cell.openSwitch.on = YES;
            }
            if([isVerify isEqualToString:@"0"])
            {
                cell.testSwitch.on = NO;
            }
            else
            {
                cell.testSwitch.on = YES;
            }
        }
        else
        {
            Alert(@"主人,你设置失败了哦");
        }
        
    }];
}


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
    else if(indexPath.section == 5){
        
        return 45;
    }else if(indexPath.section==3){
        return 90;
    }
    else if(indexPath.section==4){
        return 45;
    }
    else
    {
        return 90;
    }
}
#pragma mark - 举报单元格
- (void)exchanelTableClick:(UIButton *)button
{
    NSArray * array = @[@"频道名",@"关键字"];
    //NSLog(@"+++ %d",button.tag);
    
    if (button.tag == 900)
    {
        [self addFenLei];
    }
    else if (button.tag == 901)
    {
        [self addAreaPicker];
    }
    else
    {
        newInputViewController * vc = [[newInputViewController alloc]init];
        vc.twoTitleLable = [array objectAtIndex:button.tag-800];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"相机", nil),NSLocalizedString(@"从相册选择", nil),nil];
        [sheet showInView:self.view];
    }
    if (indexPath.section == 1&&indexPath.row ==1)
    {
        newInputViewController * vc = [[newInputViewController alloc]init];
        vc.twoTitleLable = @"简介";
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark --上传头像--
#pragma mark -选择头像 UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:NULL];
        } else {
            Alert(@"请在iOS'设置'-'隐私'-'相机'中打开");
        }
    } else if (buttonIndex == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        UINavigationBar *bar = imagePicker.navigationBar;
        [bar setTintColor:[UIColor whiteColor]];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

#pragma mark --头像UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        _changeImage = YES;
        _channelImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [_tableView reloadData];
    }
}

#pragma mark --添加分类pickerView--
- (void)addFenLei
{
    //CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"分类选择" delegate:self cates:@"3"];
    CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"分类选择" delegate:self cates:@"3" typeStr:@""];
    cpv.titleArray = _fenleiArr;
    [cpv showInView:self.view];
    cpv.fenleiBlock = ^(NewChannelModel *model)
    {

        _model.catalogName = model.name;
        _model.catalogID = model.number;
        [_tableView reloadData];
    };
}
#pragma mark --添加地区picker--
- (void)addAreaPicker
{
    //CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"城市选择" delegate:self cates:@"1"];
    CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"城市选择" delegate:self cates:@"1" typeStr:@""];
    
    [cpv showInView:self.view];
    
    cpv.cityBlock = ^(ProvincesAndCitiesModel *proAndCitInfo)
    {
        NSString * str = [NSString stringWithFormat:@"%@ %@",proAndCitInfo.proName,proAndCitInfo.citName];
        _model.cityName = str;
        _model.cityCode = [NSString stringWithFormat:@"%@",proAndCitInfo.code];
        [_tableView reloadData];
    };
}

#pragma mark - 查看频道成员
- (void)checkOuntMembers:(UIButton *)sender
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
    vc.infoType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 二维码
- (void)erWeiMaButtonClick:(UIButton *)button
{
    ShowBigErWeiMaViewController *svc = [[ShowBigErWeiMaViewController alloc]init];
    svc.type = @"|2";
    svc.model = _model;
    svc.isZhubo = NO;
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#pragma mark --
//- (IBAction)zhuanyiButtonClick:(UIButton *)sender
//{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,您确定要转移该频道么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 29;
//    [alert show];
//}
//#pragma mark --解散--
//- (IBAction)jiesanButtonClick:(UIButton *)sender
//{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,您确定不要我了么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 49;
//    [alert show];
//}
#pragma mark --UIAlertViewDelegate--
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 29)
//    {
//        if (buttonIndex == 1)
//        {
//            MemberViewController * vc = [[MemberViewController alloc]init];
//            vc.channelNumber = _model.number;
//            vc.infoType = @"1";
//            vc.isZhuanYi = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
//    else if (alertView.tag ==39)
//    {
//        if (buttonIndex == 1)
//        {
//            if ([[alertView textFieldAtIndex:0].text isEqualToString: [[NSUserDefaults standardUserDefaults]objectForKey:kpassworldString]])
//            {
//                [self zhuanyiRequest];
//            }
//            else
//            {
//                Alert(@"主人，您的密码输入错误哟");
//            }
//        }
//    }
//    else if (alertView.tag == 49)
//    {
//        if (buttonIndex == 1)
//        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"主人，请输入您的密码哟" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alert.tag = 59;
//            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
//            [alert show];
//        }
//    }
//    else if (alertView.tag == 59)
//    {
//        if (buttonIndex == 1)
//        {
//            if ([[alertView textFieldAtIndex:0].text isEqualToString: [[NSUserDefaults standardUserDefaults]objectForKey:kpassworldString]])
//            {
//                [self jiesanRequest];
//            }
//            else
//            {
//                Alert(@"主人，您的密码输入错误哟");
//            }
//        }
//    }
//    else if (alertView.tag == 69)
//    {
//        if (buttonIndex == 1)
//        {
//            NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":_model.number,@"channelName":_model.name,@"channelIntro":_model.introduction,@"channelCitycode":_model.cityCode,@"channelCatalogID":_model.catalogID,@"channelKeyWords":_model.keyWords,@"channelOpenType":_model.openType.length==0?@"1":_model.openType,@"isVerify":_model.isVerity.length==0?@"0":_model.isVerity};
//            
//            if (_channelImage)
//            {
//                [self refreshWithStatus:YES];
//                [RequestEngine modifySecretChannelInfoWithDic:dic image:_channelImage completed:^(NSString *errorCode) {
//                    [self refreshWithStatus:NO];
//                    Alert(@"主人,该频道的信息修改成功了");
//                }];
//            }
//            else
//            {
//                [self refreshWithStatus:YES];
//                [RequestEngine modifySecretChannelInfoWithDic:dic image:nil completed:^(NSString *errorCode) {
//                    [self refreshWithStatus:NO];
//                    if ([errorCode isEqualToString:@"0"])
//                    {
//                        [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
//                        Alert(@"主人,该频道的信息修改成功了");
//                    }
//                }];
//                
//            }
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
//        }
//        else
//        {
//            [self getChannelData];
//        }
//    }
//}
#pragma mark --接收到转移通知--
- (void)zhuanyiNotification:(NSNotification *)notify
{
    NSDictionary * dic = [notify userInfo];
    //NSLog(@"接到通知了 %@",dic);
     _accountIdStr = [dic objectForKey:@"accountId"];
    _zhuanYiNickName = [dic objectForKey:@"receiverAccountNickName"];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"主人，请输入您的密码哟" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 39;
    
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}
#pragma mark --转移数据请求--
- (void)zhuanyiRequest
{
    NSString * nickName = [PersonInfo sharePersonInfo].nicknameString.length==0?@"":[PersonInfo sharePersonInfo].nicknameString;
    NSDictionary * dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"password":[[NSUserDefaults standardUserDefaults]objectForKey:kpassworldString],@"channelNumber":_model.number,@"receiverAccountID":_accountIdStr,@"accountNickName":nickName,@"receiverAccountNickName":_zhuanYiNickName.length==0?@"":_zhuanYiNickName,@"channelName":_model.name.length==0?@"":_model.name};
    [self refreshWithStatus:YES];
    [RequestEngine transferSecretChannelWithDic:dict completed:^(NSString *errorCode) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
            Alert(@"主人,您成功转移频道了哟");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([errorCode isEqualToString:@"ME18106"])
        {
            Alert(@"主人,对方拥有的频道数已经超过10个,不能转移给他哦");
        }
        else
        {
            Alert(@"主人,转移频道失败了呀,稍后再试试吧");
        }
    }];
}
#pragma mark --解散频道--
- (void)jiesanRequest
{
    NSString * nickName = [PersonInfo sharePersonInfo].nicknameString.length==0?@"":[PersonInfo sharePersonInfo].nicknameString;
    NSDictionary * dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"password":[[NSUserDefaults standardUserDefaults]objectForKey:kpassworldString],@"channelNumber":_model.number,@"accountNickName":nickName,@"channelName":_model.name};
    [self refreshWithStatus:YES];
    [RequestEngine dissolveSecretChannelWithDic:dict completed:^(NSString *errorCode) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"channelStatus" object:self];
            Alert(@"主人,您成功解散频道了哟");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            Alert(@"主人,解散频道失败了呀,稍后再试试吧");
        }
    }];
}
#pragma mark - +键
- (void)JiaKeySwitch:(UISwitch *)sender
{
    if(sender.on)
    {
        sender.on = YES;
        //关闭+键 ++键是关闭状态
        [self setOnlyOneUserkeyInfocustomType:@"4"];
    }
    else
    {
        sender.on = NO;
        //打开+键 ++键不管什么状态都要关闭
        
    }
}
#pragma mark - ++键
- (void)JiaJiaKeySwitch:(UISwitch *)sender
{
    if(sender.on)
    {
        sender.on = YES;
        //关闭++键 +键是关闭状态
        [self setOnlyOneUserkeyInfocustomType:@"5"];
    }
    else
    {
        sender.on = NO;
        //打开++键 +键不管什么状态都要关闭
        
    }
}
- (void)setOnlyOneUserkeyInfocustomType:(NSString *)actionType
{
    QunTableViewCell *cell = [self cellAtIndexRow:_cellAtIndexRow andAtSection:_atSection];
    [self refreshWithStatus:YES];
    [RequestEngine setOnlyOneUserkeyInfocustomType:@"10" actionType:actionType customParameter:self.channelNumber completed:^(NSString *errorCode, NSDictionary *resultDic) {
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
        }
        else
        {
            Alert(@"主人,设置失败了");
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self getChannelData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




@end
