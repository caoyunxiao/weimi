//
//  GoodsView.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "GoodsView.h"

@implementation GoodsView

#pragma mark - 视图初始化
- (void)awakeFromNib
{
    _textFieldArray = [[NSArray alloc] init];
    _textFieldArray = @[_manifestNumberTextFeild,_companyTextField,_reasonTextFeild,_nameTextFeild,_phoneNameTextFeild,_adressTextFeild];
    [self changeTextUIReturnKeyAndDelegate:_textFieldArray];
    
    [self.confirmbtn setBackgroundImage:[UIImage imageNamed:@"buttonone_select"]forState:UIControlStateHighlighted];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}
#pragma mark - 确认换货
- (IBAction)confirmButton:(id)sender
{
    if (![self judgeIsEnable])
    {
        Alert(@"主人,发现你还有未填项,请将信息填写完善哦");
        return;
    }
    if ([_delegate respondsToSelector:@selector(applyExchangeGoods:expressNumber:expressCompany:name:telephone:address:exchangeReason:)])
    {
        [_delegate applyExchangeGoods:@"" expressNumber:self.manifestNumberTextFeild.text expressCompany:self.companyTextField.text name:self.nameTextFeild.text telephone:self.phoneNameTextFeild.text address:self.adressTextFeild.text exchangeReason:self.reasonTextFeild.text];
    }
}

#pragma mark - 结束编辑状态
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
#pragma mark - 设置所有的textField的代理和键盘方式
- (void)changeTextUIReturnKeyAndDelegate:(NSArray *)array
{
    for (UITextField *textField in array)
    {
        textField.delegate = self;
        NSInteger index = [array indexOfObject:textField];
        if((index+1)==array.count)
        {
            textField.returnKeyType =UIReturnKeyDone;
        }
        else
        {
            textField.returnKeyType =UIReturnKeyNext;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([_textFieldArray indexOfObject:textField]!=NSNotFound)
    {
        NSInteger index = [_textFieldArray indexOfObject:textField];
        [textField resignFirstResponder];
        if((index+1)==_textFieldArray.count)
        {
            [self endEditing:YES];
        }
        else
        {
            UITextField *textNext = [_textFieldArray objectAtIndex:index+1];
            [textNext becomeFirstResponder];
        }
    }
    else
    {
        [self endEditing:YES];
    }
    return YES;
}
#pragma mark - 判断是否为空
- (BOOL)judgeIsEnable
{
//    NSString *cashString = self.cashPassworldTextField.text;//押金密码为空
    NSString *expressageString = self.manifestNumberTextFeild.text;
    NSString *companyString = self.companyTextField.text;
    NSString *reasonString = self.reasonTextFeild.text;
    NSString *nameString = self.nameTextFeild.text ;
    NSString *phoneString = self.phoneNameTextFeild.text;
    NSString *adressString = self.adressTextFeild.text;
    
    if (![expressageString isEqualToString:@""]
        && ![companyString isEqualToString:@""] && ![reasonString isEqualToString:@""]
        && ![nameString isEqualToString:@""] && ![phoneString isEqualToString:@""]
        && ![adressString isEqualToString:@""])
    {
       return  YES;
    }else
    {
        return  NO;
    }
}

@end
