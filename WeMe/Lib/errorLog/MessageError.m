//
//  MessageError.m
//  微密
//
//  Created by iOS Dev on 15/1/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MessageError.h"

@implementation MessageError
+(NSString*)getWithString:(NSString *)errorCode;
{
    
    if([[errorCode substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"M"])
    {
        if ([[errorCode substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"0"]) {
            errorCode=[errorCode substringFromIndex:3];
        }else
        {
            errorCode=[errorCode substringFromIndex:2];
        }
    }
    NSInteger ec=[errorCode integerValue];
    
    switch (ec) {
        case 1002:
            return @"appkey认证错误";     //{"ME01002", "appKey error"}
            break;
        case 1003:
            return @"访问令牌不匹配";			//{"ME01003", "access token not matched"}
            break;
        case 1004:
            return @"访问令牌过期";			//{"ME01004", "access token expired"}
            break;
        case 1005:
            return @"访问令牌与当前用户不匹配";			//{"ME01005", "access token not this authorization"}
            break;
        case 1006:
            return @"json数据错误";			//{"ME01006", "error json data!"}
            break;
        case 1019:
            return @"签名不匹配";				//{"ME01019", "sign is not match!"}
            break;
            //sql
        case 1020:								//{"ME01020", "mysql failed!"}
            return @"数据库出错";				//{"ME01021", "redis failed!"}
            //系统错误
            break;
        case 1021:
            return @"访问redis失败";
            break;
        case 1022:
            return @"系统出错";				//{"ME01022", "internal data error!"}
            break;
            //http
//        case 1023:
//            return @"网络请求出错";			//{"ME01023", "%s is error!"}
//            break;
        case 1024:
            return @"网络请求参数为空";			//{"ME01024", "http body is null!"}
            break;
        case 1025:
            return @"请求失败";			//{"ME01025", "http failed!"},
            break;
        case 1026:
            return @"系统正忙";				//{"ME01026", "system is busy now !"}
            break;
            //结果错误
//        case 18001:
//            return @"请求码错误";			//{"ME18001", "%s!"},
//            break;
        case 18002:
            return @"用户名已经存在";			//{"ME18002", "user name is already exist!"}
            break;
        case 18003:
            return @"新浪认证不存在";			//{"ME18003", "sina oauth is not exist in db!"},
            break;
        case 18004:
            return @"系统数据出错";				//{"ME18004", "%s has more record in db!"}
            break;
        case 18005:
            return @"输入的参数不存在";			//{"ME18005", "this input field does not exist"}
            break;
        case 18006:
            return @"IMEI未绑定 ";			//{"ME18006", "IMEI has not bind!"}
            break;
        case 18007:
            return @"新浪认证访问令牌过期";		//{"ME18007", "sina oauth access token has expire!"}
            break;
        case 18008:
            return @"没有权限 ";	//{"ME18008", "mirrtalk is not power on!"}
            break;
        case 18009:
            return @"默认配置不存在";			//{"ME18009", "default config does not exist!"}
            break;
        case 18010:
            return @"第三方账户不存在";		//{"ME18010", "this third account does not exists!"}
            break;
        case 18011:
            return @"第三方账户已经存在";		//{"ME18011", "this third account has existed!"}
            break;
        case 18012:
            return @"mirrtalk没有账户ID";	//{"ME18012", "this mirrtalkNumber has not accountID"}
            break;
            //weibo group
        case 18013:
            return @"该用户不能被删除";			//{"ME18013", "this user cannot be deleted"}
            break;
        case 18014:
            return @"该用户不在这个组";		//{"ME18014", "this user hasn't this group"}
            break;
        case 18015:
            return @"帐户ID没有财务信息";		//{"ME18015", "this accountID has no finance information!"}
            break;
        case 18016:
            return @"没有道客密码";			//{"ME18016", "no daoke password"}
            break;
//        case 18017:
//            return @"提取金额大于申请撤回";		//{"ME18017", "the withdraw amount is larger than the apply withdraw amount:%s"}
//            break;
        case 18018:
            return @"该用户没有余额 ";			//{"ME18018", "this user has no money"}
            break;
        case 18019:
            return @"押金类型有效,不允许更改。";	//{"ME18019", "deposit type is valid, not allow to change it"}
            break;
        case 18020:
            return @"没有权利收回押金";		//{"ME18020", "no right to withdraw the deposit"}
            break;
        case 18021:
            return @"没有权利交换";			//{"ME18021", "no right to exchange the WEME"}
            break;
        case 18025:
            return @"删除成员太多了";			//{"ME18025", "delete too many members"}
            break;
            //reward
        case 18030:
            return @"IMEI号已经存在";		//{"ME18030", "IMEI is already exist!"}
            break;
        case 18031:
            return @"IMEI号不存在";			//{"ME18031", "IMEI is not exist!"}
            break;
        case 18032:
            return @"非法IMEI";			//{"ME18032", "IMEI is illegal!"}
            break;
        case 18033:
            return @"不能提款";				//{"ME18033", "no account of withdrawing"}
            break;
        case 18034:
            return @"没有押金密码";			//{"ME18034", "no deposit password"}
            break;
        case 18035:
            return @"押金密码不匹配";			//{"ME18035", "deposit password is not matched"}
            break;
        case 18036:
            return @"用户没有支付定金";		//{"ME18036", "the user hasn't paid the deposit"}
            break;
//        case 18037:
//            return @"申请总额大于可用金额";		//{"ME18037", "the applying amount is larger than the usable amount:%s"}
//            break;
//        case 18038:
//            return @"不是提款时间";			//{"ME18038", "it's not up to the withdrawable time:%s"}
//            break;
        case 18039:
            return @"WECODE不存在";		//{"ME18039", "WECODE is not exist!"}
            break;
        case 18040:
            return @"WECODE过期";			//{"ME18040", "WECODE has expired!"}
            break;
        case 18041:
            return @"用户没有申请退出合约";		//{"ME18041", "the user hasn't applied quit contract"}
            break;
        case 18042:
            return @"用户没有申请交换mirrtalk设备";//{"ME18042", "the user hasn't applied exchanging mirrtalk"}
            break;
//        case 18043:
//            return @"该IMEI号不可用";		//{"ME18043", "the IMEI:%s is unusable"}
//            break;
        case 18044:
            return @"奖金类型不存在";			//{"ME18044", "reward type is not exist!"}
            break;
        case 18045:
            return @"无用的奖励类型";			//{"ME18045", "the reward type is unusable"}
            break;
        case 18046:
            return @"存储类型不合法";			//{"ME18046", "the deposit type is illegal!"}
            break;
        case 18047:
            return @"无效的存储类型";			//{"ME18047", "the deposit type is unusable"}
            break;
        case 18048:
            return @"输入存款金额不匹配给定的存款金额";	//{"ME18048", "the input deposit amount is not match the given deposit amount"}
            break;
        case 18049:
            return @"该用户存在相同的奖金类型";	//{"ME18049", "the user has the same rewards type"}
            break;
        case 18050:
            return @"WECODE 已失效 ";		//{"ME18050", "WECODE has expired!"}
            break;
        case 18051:
            return @"业务ID不存在";			//{"ME18051", "business ID not exist!"}
            break;
            //weibo group
        case 18052:
            return @"分组已存在";			//{"ME18052", "this group is already exist!"}
            break;
        case 18053:
            return @"accountID已存在";		//{"ME18053", "this accountID is not exist!"}
            break;
        case 18054:
            return @"分组ID不存在";			//{"ME18054", "this groupID is not exist!"}
            break;
        case 18055:
            return @"无效的分组ID";			//{"ME18055", "this groupID is unusable"}
            break;
        case 18056:
            return @"申请的账户ID不是该组成员";	//{"ME18056", "this applyAccountID is not group member!"}
            break;
        case 18057:
            return @"申请人没有删除的权利";		//{"ME18057", "this applicant hasn't delete right"}
            break;
        case 18058:
            return @"删除的账户ID不是该组成员";	//{"ME18058", "this deleteAccountID is not group member!"}
            break;
            //account api
        case 18059:
            return @"IMEI 未绑定";		//{"ME18059", "IMEI has been bind!"}
            break;
        case 18060:
            return @"该账户ID停止服务";		//{"ME18060", "accountID is not in service!"}
            break;
        case 18061:
            return @"用户名不存在";			//{"ME18061", "user name is not exist!"}
            break;
        case 18062:
            return @"该用户名停止服务";		//{"ME18062", "user name is not in service!"}
            break;
        case 18063:
            return @"密码不匹配";				//{"ME18063", "password is not matched"}
            break;
        case 18064:
            return @"用已在这个分组";		//{"ME18064", "this user already in the group"}
            break;
        case 18065:
            return @"该用户没有权限";		//{"ME18065", "this user hasn't authorization"}
            break;
        case 18066:
            return @"该用户没有权限（权限过期）";			//{"ME18066", "this user authorization expire"}
            break;
        case 18067:
            return @"IMEI号已经被用";		//{"ME18067", "IMEI has already been used!"}
            break;
        case 18068:
            return @"用户手机号没有被授权";		//{"ME18068", "user mobile hasn't authorization!"}
            break;
        case 18069:
            return @"重定向url不匹配";		//{"ME18069", "redirect url don't match!"}
            break;
        case 18070:
            return @"授权码不存在";			//{"ME18070", "Authorization code don't exist!"}
            break;
        case 18071:
            return @"授权码过期";			//{"ME18071", "Authorization code expire!"}
            break;
        case 18072:
            return @"刷新令牌不存在";			//{"ME18072", "Refresh Token don't exist!"}
            break;
        case 18073:
            return @"刷新令牌已过期";			//{"ME18073", "Refresh Token expire!"}
            break;
        case 18074:
            return @"appkey不存在";		//{"ME18074", "app key don't exist!"}
            break;
        case 18075:
            return @"不允许创建组";			//{"ME18075", "not allow to create group!"}
            break;
            //developer
        case 18076:
            return @"开发者信息等待审核";		//{"ME18076", "developer Info is waiting audit"}
            break;
        case 18078:
            return @"开发者信息审核通过";		//{"ME18078", "developer Info have audit success"}
            break;
        case 18079:
            return @"开发者没有注册";		//{"ME18079", "developer has not registered !"}
            break;
            //WEME Setting
        case 18080:
            return @"网站不存在";			//{"ME18080", "website is not exist !"}
            break;
        case 18081:
            return @"用户必须在线";			//{"ME18081", "user must online"}
            break;
        case 18082:
            return @"该appley没有业务信息";	//{"ME18082", "this appKey has no business info !"}
            break;
        case 18083:
            return @" IMEI 不匹配当前appKey";//{"ME18083", "this IMEI is not match current business appKey !"}
            break;
        case 18084:
            return @"app不能使用";			//{"ME18084", "this app is unable to use!"}
            break;
        case 18085:
            return @"该开发者没有被认证";		//{"ME18085", "this developer has not been verified !"}
            break;
        case 18086:
            return @"该app不存在";			//{"ME18086", "this app is not exist!"}
            break;
        case 18087:
            return @"客户端appkey不存在";	//{"ME18087", "clientAppKey is not exist !"}
            break;
        case 18088:
            return @"客户端appkey不可用";	//{"ME18088", "clientAppKey is unusable !"}
            break;
        case 18089:
            return @"没有这个申请";			//{"ME18089", "have no such apply !"}
            break;
//        case 18090:
//            return @"请求频率过多";			//{"ME18090", "%s"},    ---- 控制API请求频率,%s,返回执行还需要等X秒(具体环境单位可以不一样)
//            break;
//        case 18091:
//            return @"用户未设置+键的操作";		//{"ME18091", "%s"},    ---- 用户未设置+键的操作
//            break;
        case 18092:
            return @"当前临时频道不是直播模式";	//{"ME18092", "current channel not start"},    ---- 当前临时频道不是直播模式
            break;
        case 18093:
            return @"该管理员没有业务组";		//{"ME18093", "this administrator has no business group !"}
            break;
            //sharePoints
        case 18094:
            return @"该用户没有分享坐标";		//{"ME18094", "this user has no share points"}
            break;
        case 18095:
            return @"多个相同的分享点记录";		//{"ME18095", "the same share points records more than one !"}
            break;
        case 18096:
            return @"分享点已经得到";			//{"ME18096", "the share points has been gotten !"}
            break;
        case 18097:
            return @"分享坐标超时";			//{"ME18097", "this share points has overtime"}
            break;
        case 18098:
            return @"用户的分享坐标必须大于0";	//{"ME18098", "user's share points must bigger than zero"}
            break;
        case 18099:
            return @"用户的等级超过范围";	//{"ME18099", "user's level has out of range "}
            break;
        case 18100:
            return @"分享点已经分发";			//{"ME18100", "share points has dispatched alreadly !"}
            break;
        case 18101:
            return @"该用户没有增长的信息";		//{"ME18101", "this user has no growth information !"}
            break;
        case 18102:
            return @"当前频道已经是活跃模式";	//{"ME18102", "current Channel already live mode"}
            break;
        case 18103:
            return @"当前频道已经是解散模式";	//{"ME18103", "current Channel already disband mode"}
            break;
        case 18104:
            return @"当前用户申请的频道已经被审核通过";	//{"ME18104", "current user channel already exist"} 当前用户申请的频道已经被审核通过了
            break;
        case 18105:
            return @"当前用户重复提交相同的数据";	//{"ME18105", "Repeat submitted" }当前用户重复提交相同的数据
            break;
        case 18106:
            return @"当前用户的密频道已经达到最大值";		//{"ME18106", "user channel Maximum" }当前用户的密频道已经达到最大值
            break;
        case 18107:
            return @"唯一码错误";	//{"ME18107", "uniquecode is error " }唯一码错误
            break;
        case 18108:
            return @"有效的邀请码太多,需要先删除一些无效的";	//{"ME18108", "user too many" }有效的邀请码太多,需要先删除一些无效的
            break;
        case 18109:
            return @"当前频道编码错误";		//{"ME18109", "channel number is error" }当前频道编码错误
            break;
            //map api [ME18110 ~ ME18300]
        case 18110:
            return @"平台认证key错误";		//{"ME18110", "location failed!"}
            break;
            //channel Info [ME18300 ~ ME18500 ]
        case 18301:
            return @"之前从未之前从未关注过";			//{"ME18301", "before not follow" }之前从未之前从未关注过
            break;
        case 18302:
            return @"禁止关注自己创建的微频道";	//{"ME18302", "do not follow yourself" }禁止关注自己创建的微频道
            break;
        case 18303:
            return @"当前已经是关注状态,不需要再关注";	//{"ME18303", "do not repeat follow"}当前已经是关注状态,不需要再关注
            break;
        case 18304:
            return @"当前已经是取消关注状态,请不要继续操作取消关注";//{"ME18304", "do not repeat unfollow" }当前已经是取消关注状态,请不要继续操作取消关注
            break;
        case 18305:
            return @"密频道不能管理自己";		//{"ME18305", "do not manage self" }密频道不能管理自己
            break;
        case 18306:
            return @"你不是密频道管理员";		//{"ME18306", "you are not manager" }当前不是密频道管理员
            break;
            //reward [ME18501 ~ ME18800 ]
        case 18502:
            return @"该用户申请提现不到10元";	//{"ME18502","this user apply withdraw amount less than ten"}
            break;
            //accountapi [ME18801 ~ ME18900 ] 2014-11-17
        case 18801:
            return @"当前状态不允许预入库操作";	//{"ME18801","cur IMEI status not allow prestorge"}当前状态不允许预入库操作
            break;
        case 18802:
            return @"没有收到开机信息";		//{"ME18802","not receive boot information"}没有收到开机信息
            break;
        case 18803:
            return @"没有接受到GPS信息";		//{"ME18803","not receive GPS information"}没有接受到GPS信息
            break;
        case 18517:
            return @"系统正在清算中";
            break;
        case -1:
            return @"网络错误,加载失败,请稍后再试";
            break;
        case 0:
            return @"成功";
            break;
        case 10000:
            return @"数据库错误";
            break;
        case 10001:
            return @"验证码错误";
            break;
        case 10002:
            return @"邮箱账户已注册";
            break;
        case 10003:
            return @"发送邮件失败";
            break;
        case 10004:
            return @"token过期";
            break;
        case 10005:
            return @"token不存在，有误";
            break;
        case 10006:
            return @"未绑定邮箱";
            break;
        case 10007:
            return @"邮箱未激活";
            break;
        case 10008:
            return @"没有完善商家资料";
            break;
        case 10009:
            return @"短信验证码错误";
            break;
        case 10010:
            return @"参数不合法";
            break;
        case 10011:
            return @"购买商品数量过多";
            break;
        case 10012:
            return @"商品单价有误";
            break;
        case 10013:
            return @"商品总价有误";
            break;
        case 10014:
            return @"云端出错";
            break;
        case 10015:
            return @"暂无数据";
            break;
        case 10016:
            return @"已经激活";
            break;
        case 10017:
            return @"审核商家失败";
            break;
        case 10018:
            return @"创建businessID失败";
            break;
        case 10019:
            return @"签名有误";
            break;
        case 10020:
            return @"当前话费查询失败";
            break;
        case 10021:
            return @"话费多充值失败";
            break;
        case 10022:
            return @"订单更新失败";
            break;
        case 10030:
            return @"确认订单失败，无法获取商品信息";
            break;
        case 10031:
            return @"支付宝账号输入有误";
            break;
        case 10100:
            return @"支付失败，无法获取商家信息";
            break;
        case 10101:
            return @"支付失败，无法获取订单信息";
            break;
        case 10102:
            return @"支付失败，用户不存在";
            break;
        case 10103:
            return @"支付失败，商家不存在";
            break;
        case 10104:
            return @"支付失败，订单已支付";
            break;
        case 10105:
            return @"支付失败，用户账户余额不足";
            break;
        case 10106:
            return @"支付失败，密码错误";
            break;
        case 10107:
            return @"支付失败，其他错误";
            break;
        case 10108:
            return @"支付失败，支付金额和订单总价有差";
            break;
        case 10109:
            return @"支付成功，生成兑换码失败";
            break;
        case 10110:
            return @"支付成功，但更新订单状态失败";
            break;
        case 10111:
            return @"支付失败，无法调取支付接口";
            break;
        case 10112:
            return @"支付失败，订单不存在";
            break;
        case 10120:
            return @"退款失败";
            break;
        default:
            return @"";
            break;
    }
    return nil;
}
@end
