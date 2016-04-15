//
//  MailListViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MailListViewController.h"
#import "MailListTableViewCell.h"
#import "TestViewController.h"
#import "TKAddressBook.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TKAddressBook.h"
@interface MailListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _listArr;
    NSMutableArray *_addressBookTemp;
    NSMutableArray * _personArray;    //联系人数组
}
@property(nonatomic)ABAddressBookRef addressBooks;
@property(nonatomic,assign)BOOL hasRegister;
@end

@implementation MailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getPhoneNum];
    self.title = @"通讯录好友";
    [self _createTableView];
    _addressBookTemp = [[NSMutableArray alloc]init];
    _personArray = [[NSMutableArray alloc]init];
    _table.tableFooterView = [[UIView alloc]init];
    [self registerCallback];
    //[self refreshData];刷新加载
    //获取电话号码
    [self getPhoneDataBase];
}

- (void)getPhoneDataBase
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:HasUpDatePhone]||[[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneChange"] isEqualToString:@"1"])
    {
        [self getPhoneNum];
    }
    else
    {
        [self getArrOfMailList];
    }
}


- (void)registerCallback
{
    if (!self.addressBooks)
    {
        self.addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);;
    }

    if (!self.hasRegister)
    {
        ABAddressBookRegisterExternalChangeCallback(self.addressBooks, addressCallback, (__bridge void *)(self));
        self.hasRegister =YES;
        //NSLog(@"RegisterCallBack");
    }
}

- (void)unregisterCallback {
    //NSLog(@"unRegisterCallBack");
    if (self.hasRegister) {
        ABAddressBookUnregisterExternalChangeCallback(self.addressBooks, addressCallback, (__bridge void *)(self));
        self.hasRegister = NO;
    }
}

//添加回调方法
void addressCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"phoneChange"];

}


#pragma mark --获得通讯录中的信息--
- (void)getPhoneNum
{
    if (_addressBookTemp.count>0)
    {
        [_addressBookTemp removeAllObjects];
    }
    ABAddressBookRef  _addressbook = nil;
    self.addressBooks = _addressbook;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0)
    {
        _addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(_addressbook, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        CFErrorRef* error=nil;
        _addressbook = ABAddressBookCreateWithOptions(NULL, error);
        //_addressbook = ABAddressBookCreate();
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(_addressbook);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(_addressbook);
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;

        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        //NSLog(@"nameString == %@  tel == %@",nameString,addressBook.tel);
        [_addressBookTemp addObject:addressBook];
    }
    if (_addressBookTemp.count>0)
    {
        [self getPersonArray];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:HasUpDatePhone];
         [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"phoneChange"];
    }
    else
    {
        //Alert(@"通讯录的好友人数为0");
    }
}
#pragma mark - 获取数组
- (void)getPersonArray
{
    NSMutableArray * dataArr = [NSMutableArray array];
    for (int i = 0; i<_addressBookTemp.count; i++)
    {
        TKAddressBook * addressbook = [_addressBookTemp objectAtIndex:i];
        [dataArr addObject:addressbook];
    }
    [self getPerson];
    [self fileHandleForWritingAtPathWithArray:dataArr];
}
#pragma mark - 把通讯录存到本地
- (void)fileHandleForWritingAtPathWithArray:(NSArray *)array
{
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    for(int i=0;i<array.count;i++)
    {
        TKAddressBook *model = [array objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        if(model.tel!=nil&&model.name!=nil)
        {
            [dict setObject:model.tel forKey:@"tel"];
            [dict setObject:model.name forKey:@"name"];
            [dataArr addObject:dict];
        }
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"tongxunlu.plist"];
    [dataArr writeToFile:filename atomically:YES];
    //[self getArrOfMailList];
}
#pragma mark --刷新控件--
- (void)refreshData
{
    [_table addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
}
#pragma mark --下拉刷新--
- (void)headerRefresh
{
    if (_addressBookTemp.count>0)
    {
        [self requestDataWithData:_addressBookTemp];
    }
}
#pragma mark - 读取本地保存的通讯录
- (void)getArrOfMailList
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"tongxunlu.plist"];
    _listArr = [[NSArray alloc] initWithContentsOfFile:filename];
    if(_listArr.count>0)
    {
        [self getPerson];
    }
}
#pragma mark - 解析本地保存的通讯录
- (void)getPerson
{
    for (int i = 0; i<_listArr.count; i++)
    {
        NSDictionary *dict = [_listArr objectAtIndex:i];
        TKAddressBook * addressbook = [[TKAddressBook alloc]init];
        [addressbook setValuesForKeysWithDictionary:dict];
        [_addressBookTemp addObject:addressbook];
    }
    [self requestDataWithData:_addressBookTemp];
}
#pragma mark - 根据通讯录请求数据
- (void)requestDataWithData:(NSMutableArray *)phoneArr
{
    NSMutableArray *listArr = [[NSMutableArray alloc]init];
    int num = ((int)phoneArr.count/200);
    int surplusNum = (int)(phoneArr.count - 200*num);
    if(surplusNum>0)
    {
        num++;
    }
    if(phoneArr.count>200)
    {
        for (int i =0; i<num; i++)
        {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            if(i==num-1)
            {
                for(int j = 0+200*i ; j < surplusNum+ 200*i; j++)
                {
                    [arr addObject:phoneArr[j]];
                }
            }
            else
            {
                for(int j = 0+200*i ; j < 200+ 200*i; j++)
                {
                    [arr addObject:phoneArr[j]];
                }
            }
            [listArr addObject:arr];
        }
    }
    else
    {
        [listArr addObject:phoneArr];
    }
    
    for (NSMutableArray *arr in listArr)
    {
        [self refreshWithStatus:YES];
        [RequestEngine judgeIsWeMeAccountWithMobiles:arr completed:^(NSString *errorCode, NSMutableArray *modelArr) {
            [self refreshWithStatus:NO];
            [_table headerEndRefreshing];
            if ([errorCode isEqualToString:@"0"]&&modelArr.count>0)
            {
                for (NewChannelModel *model in modelArr) {
                    [_personArray addObject:model];
                }
            }
            [_table reloadData];
        }];

    }
}
#pragma mark - UITableView
- (void) _createTableView
{
    _table.dataSource = self;
    _table.delegate = self;
}
#pragma mark -UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifi = @"friendCell";
    MailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MailListTableViewCell" owner:self options:nil] firstObject];
    }
    NewChannelModel * model = [_personArray objectAtIndex:indexPath.row];
    model.phoneName = [self getPhoneNameWithModel:model];
    cell.addFriend.tag = indexPath.row;
    [cell fileDataWithModel:model];
    [cell.addFriend addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (NSString *)getPhoneNameWithModel:(NewChannelModel *)model
{
    NSString * str = nil;
    for (int i = 0; i<_addressBookTemp.count; i++)
    {
        TKAddressBook * book = [_addressBookTemp objectAtIndex:i];
        if ([[self getPhone:book.tel] isEqualToString:model.mobile])
        {
            str = book.name;
        }
    }
    return str;
}
- (NSString *)getPhone:(NSString *)mobiles
{
    NSString * phoneStr = nil;
    if ([mobiles rangeOfString:@"-"].location != NSNotFound)
    {
        if (mobiles.length>8&&mobiles.length<13)
        {
            NSArray * arary = [mobiles componentsSeparatedByString:@"-"];
            
            phoneStr = [NSString stringWithFormat:@"%@%@",[arary objectAtIndex:0],[arary objectAtIndex:1]];
        }
        else if (mobiles.length == 13&&[mobiles hasPrefix:@"1"])
        {
            NSArray * arary = [mobiles componentsSeparatedByString:@"-"];
            phoneStr = [NSString stringWithFormat:@"%@%@%@",[arary objectAtIndex:0],[arary objectAtIndex:1],[arary objectAtIndex:2]];
        }
    }
    else
    {
        phoneStr = mobiles;
    }
    NSArray *array = [phoneStr componentsSeparatedByString:@"+86"];
    if (array.count>0)
    {
        phoneStr = [array componentsJoinedByString:@"+86"];
    }
    array = [phoneStr componentsSeparatedByString:@"-"];
    if (array.count>0)
    {
        phoneStr = [array componentsJoinedByString:@""];
    }
    array = [phoneStr componentsSeparatedByString:@" "];
    if (array.count>0)
    {
        phoneStr = [array componentsJoinedByString:@""];
    }
    //NSLog(@"phoneStr == %@",phoneStr);
    return phoneStr;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_table deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark --加好友--
- (void) addFriendAction:(UIButton *)button
{
    
    NewChannelModel * model = [_personArray objectAtIndex:button.tag];
    NSString * nickName = model.nickName==nil?@"":model.nickName;
    NSString * accountId = model.accountID==nil?@"":model.accountID;
    NSString * gender = model.gender.length==0?@"1":model.gender;
    NSString * area = model.userArea.length==0?@"":model.userArea;
    //需要验证
    //NSLog(@"验证  %@",[NSString stringWithFormat:@"%@",model.isVerifyOpinion]);
    if([[NSString stringWithFormat:@"%@",model.isVerifyOpinion] isEqualToString:@"1"])
    {
        //NSLog(@"需要验证 。。。");
        TestViewController *tvc = [[TestViewController alloc]init];
        tvc.model = model;
        tvc.isFriend = YES;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:tvc];
      [self presentViewController:nav animated:YES completion:nil];
    
    }
    //不需要验证
    else if([[NSString stringWithFormat:@"%@",model.isVerifyOpinion] isEqualToString:@"0"]||model.isVerifyOpinion==nil)
    {
        //NSLog(@"不需要验证");
        
        NSDictionary *dict = @{@"msgContent":@"",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"friendAccountID":accountId,@"friendNickName":nickName,@"gender":gender,@"userArea":area};
        [self refreshWithStatus:YES];
        [RequestEngine addFriends:dict completed:^(NSString *errorCode, NSString *result) {
            [self refreshWithStatus:NO];
            if([errorCode isEqualToString:@"0"])
            {
                model.isFriend = @"1";
                [_personArray replaceObjectAtIndex:button.tag withObject:model];
                [_table reloadData];
                Alert(@"主人,添加好友成功了哦");
                button.enabled=NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addFriendSuccess" object:self];
            }
            else
            {
                Alert(@"主人,添加好友失败了,请稍后再试吧");
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
