//
//  Common.swift
//  Canonchain
//
//  Created by LEE on 3/19/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import Foundation
//import Masonry
import UIKit
//宏定义
let wGreenColor = UIColorFromRGB(rgbValue : )

//MARK:==============方法======
// 获得RGB颜色


func UIColorFromRGB(rgbValue:Int) ->UIColor
{
    return UIColorFromRGBAndAlpha(rgbValue: rgbValue, alpha: 1)
}
func UIColorFromRGBAndAlpha(rgbValue:Int,alpha:CGFloat) ->UIColor
{
    return UIColor.init(red: CGFloat(((Float)((rgbValue & 0xFF0000) >> 16))/255.0), green: CGFloat(((Float)((rgbValue & 0xFF00) >> 8))/255.0), blue: CGFloat(((Float)(rgbValue & 0xFF))/255.0), alpha: alpha)
}
func HEIGHT() ->CGFloat
{
    return UIScreen.main.bounds.size.height
}
func WIDTH() ->CGFloat
{
    return UIScreen.main.bounds.size.width
}
func kFit(viewWidth : CGFloat) ->CGFloat
{
    return WIDTH() * viewWidth / 375.0
}

// 当前屏幕宽度与6s宽度的比例

func widthSCALE() -> CGFloat
{
     return  WIDTH() / 375.0
}
func heightSCALE() -> CGFloat
{
    return  HEIGHT() / 667.0
}

func xFit(_ x : CGFloat) -> CGFloat
{
    return  widthSCALE() * x
}
func yFit(_ y : CGFloat) -> CGFloat
{
    return  heightSCALE() * y
}
//只有向下的比例
func yFitWithDown(_ y : CGFloat) -> CGFloat
{
    return  heightSCALE() > 1 ? y : heightSCALE() * y
}

//只有向下的比例
func xFitWithDown(_ x : CGFloat) -> CGFloat
{
    return  widthSCALE() > 1 ? x : widthSCALE() * x
}




func culculatorTextSize(string:String,font:UIFont) ->CGSize
{
    let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
    let rect:CGSize = string.boundingRect(with: size, options:  NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size;
    return rect
}
func randomColor() -> UIColor
{
//    let redFloat:CGFloat = CGFloat(Double(arc4random()%255) / 255.0)
//    let blueFloat:CGFloat = CGFloat(Double(arc4random()%255) / 255.0)
//    let blueFloat:CGFloat = CGFloat(Double(arc4random()%255) / 255.0)
   return UIColor.init(red: CGFloat(Double(arc4random()%255) / 255.0), green: CGFloat(Double(arc4random()%255) / 255.0), blue: CGFloat(Double(arc4random()%255) / 255.0), alpha: 1)
//    return UIColor.init(red:CGFloat(Double(arc4random()%255) / 255.0), green: CGFloat(Double(arc4random()%255) / 255.0), CGFloat(Double(arc4random()%255) / 255.0), alpha: 1)
}

let hideHUDTime = 2
let autoBackTime : TimeInterval = TimeInterval(2)
let NAVIGATION_BAR_HEIGHT = IS_IPHONE_X() ? 88 : 64
let HOME_INDICATOR_HEIGHT = IS_IPHONE_X() ? 34 : 0
let STATUS_BAR_OFFSET = IS_IPHONE_X() ? 24 : 0


func IS_IPHONE_X()-> Bool{
    return HEIGHT() == 812.0
}
//主动ping时，对应定时器的id
let PKInitiativePingId = "PKInitiativePing"
//MARK:=====================================自定义颜色值==========================
//绿色
let PKGreenColor = UIColorFromRGB(rgbValue: 0x00B066)
//橙色
let PKOrangeColor = UIColorFromRGB(rgbValue: 0xFF8617)
//半透明绿色
let PKTranslucenceGreenColor = UIColorFromRGBAndAlpha(rgbValue:  0x00B066, alpha: CGFloat(0.2))
//半透明橙色
let PKTranslucenceOrangeColor = UIColorFromRGBAndAlpha(rgbValue: 0xFF8617,alpha: CGFloat(0.2))
//MARK: =====================================通知================

let NOTIFICATION_NAME_fetchImageAndImageUrl = "notification_fetchImageAndImageUrl"
let NOTIFICATION_NAME_fabiCurrencyListLeftLabelStr = "fabiCurrencyListLeftLabelStr"

//占位图片
let PLACE_HOLDER_IMAGE = "PLACE_HOLDER_IMAGE"
// token
let PK_TOKEN = "PK_TOKEN"


//MARK:=====================================宏定义参数集合===========
 //整个工程Realm数据库的名称
let wCanonchainRealmName = "PKCanonchainRealm"
 //行情数据写入Realm数据库的名称
let wMarketPairDetailModelRealmName = "PKMarketPairDetailModelRealm"
//存储country plist时用到
let wCountryDicArrayPlistName = "PKCountryDicArray"
//发送行情数据的通知名称
let wMarketManagerNotification = "PKMarketManagerNotification"
//发送涨幅榜的通知名称
let wMarketIncreaseDataNotification = "PKMarketIncreaseDataNotification"
//切换本地语言的通知名称
let wChangeLanguageTypeNotification =  NSNotification.Name.init("PKChangeLanguageTypeNotification")
//币币交易设置和读取数据的key
public let AsksFiveDepthModelGroupKey = "AsksFiveDepthModelGroupKey"
public let AsksTenDepthModelGroupKey = "AsksTenDepthModelGroupKey"
public let BidsFiveDepthModelGroupKey = "BidsFiveDepthModelGroupKey"
public let BidsTenDepthModelGroupKey = "BidsTenDepthModelGroupKey"

//===================队列=====================
//BibiDepthManager处理数据的队列
let BibiDepthManagerDealDepthDataQueue = "wBibiDepthManagerDealDethDataQueue"


//MARK:=====================================泛型运算符==========================
//字典的+=运算
func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
//字典的+运算
func + <KeyType, ValueType> ( left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) -> Dictionary<KeyType, ValueType> {
    var dic : Dictionary<KeyType, ValueType> =  Dictionary<KeyType, ValueType>()
    dic = left
    for (k, v) in right {
        dic.updateValue(v, forKey: k)
    }
    return dic
}

//MARK:==========================================网络请求参数集合======
let httpTestURLString = "http://192.168.10.221:8071"
//let httpTestURLString = "http://192.168.10.233:8098"
let httpTestPublicURLString = "http://192.168.10.221:8070"
let socketTestURLString = "ws://192.168.10.220:8070"



//获取K线图的数据
let wGETKLineHttpURLString = httpTestPublicURLString + "/api/v1/klines"
//获取K线图的数据
let wGet24hourTickerDataHttpURLString = httpTestPublicURLString + "/api/v1/klines"
//获取深度图的数据
let wGetDepthDataHttpURLString = httpTestPublicURLString + "/api/v1/depth"
//最新成交
let wRecentTradesListHttpURLString = httpTestPublicURLString + "/api/v1/trades"
//主动ping
let wInitiativePing = httpTestURLString + "/api/user/ping"
//登录请求
let wLoginHttpURLString = httpTestURLString + "/api/user/login"
//注册请求
let wRegisterHttpURLString = httpTestURLString + "/api/user/register"
//获取国家列表
let wGetcountrylistHttpURLString = httpTestURLString + "/api/user/getcountrylist"
//获取服务器时间
let wGetServerTimeHttpURLString = httpTestURLString + "/api/v1/time"
//发送手机验证码
let wsendMobileVerifySMSCodeHttpURLString = httpTestURLString + "/api/user/sendmobileverifysms"
//修改登录密码
let wRevampPSWHttpURLString = httpTestURLString + "/api/user/changeloginpwd"
//设置资金密码   /user/getuserinfo
let wSetPayPSWHttpURLString = httpTestURLString + "/api/user/setadminpwd"
//获取用户信息
let wGetUserInfoHttpURLString = httpTestURLString + "/api/user/getuserinfo"
//设置谷歌验证
let wSetGoogleauthHttpURLString = httpTestURLString + "/api/user/setgoogleauth"
//gengoogleauthsetupcode
//生成谷歌验证秘钥
let wGengoogleauthCodeHttpURLString = httpTestURLString + "/api/user/gengoogleauthsetupcode"
//绑定手机
let wBindmobBileHttpURLString = httpTestURLString + "/api/user/bindmobile"
//发送邮箱验证码
let wSendEmailverifyCodeHttpURLString = httpTestURLString + "/api/user/sendemailverifycode"
//绑定邮箱
let wBindemailaddressHttpURLString = httpTestURLString + "/api/user/bindemailaddress"
//修改用户昵称
let wSetNicknameHttpURLString = httpTestURLString + "/api/user/setnickname"
//获取银行卡列表
let wGetBanklistHttpURLString = httpTestURLString + "/api/user/getbanklist"
//获取充值记录
let wGetDepositsHttpURLString = httpTestURLString + "/api/account/deposits"
//获取充值设置信息
let wGetDepositSettingHttpURLString = httpTestURLString + "/api/account/getdepositsetting"
//获取提现设置信息
let wGetwithDrawsettingHttpURLString = httpTestURLString + "/api/account/getwithdrawsetting"
//提现
let wWithdrawHttpURLString = httpTestURLString + "/api/account/withdraw"
//获取充值记录
let wWithDrawalsHttpURLString = httpTestURLString + "/api/account/withdrawals"
//获取所有货币
let wGetcurrencylistHttpURLString = httpTestURLString + "/api/account/getcurrencylist"
//获取法币汇率
let wGeGtfiatmoneyrateHttpURLString = httpTestURLString + "/api/account/getfiatmoneyrate"
//获取货币余额
let wGetcurrencyBalanceHttpURLString = httpTestURLString + "/api/account/getcurrencybalance"
//查询用户   找回密码-验证账号
let wSearchUserHttpURLString = httpTestURLString + "/api/user/searchuser"
//找回密码-验证账号
//let wBeginResetLoginPwdHttpURLString = httpTestURLString + "/api/user/beginresetloginpwd"
//找回密码-重置密码
let wResetloginpwdHttpURLString = httpTestURLString + "/api/user/resetloginpwd"
//创建现货订单
let wCreateSpotorderHttpURLString = httpTestURLString + "/api/exchange/createspotorder"
//获取成交明细
let wSpotorderDetailsHttpURLString = httpTestURLString + "/api/exchange/spotorderdetails"
//获取当前委托列表
let wSpotOpenorderlistHttpURLString = httpTestURLString + "/api/exchange/spotopenorderlist"
//获取历史委托列表
let wSpotCloseOrderlistHttpURLString = httpTestURLString + "/api/exchange/spotcloseorderlist"
//获取行情所有交易对
let wGetCurrencyPairsHttpURLString = httpTestURLString + "/api/exchange/getcurrencypairs"
//获取自选交易对
let wFavouritecCurrencyPairlistHttpURLString = httpTestURLString + "/api/exchange/favouritecurrencypairlist"
//申请撤销现货订单
let wApplycCancelSpotorderHttpURLString = httpTestURLString + "/api/exchange/applycancelspotorder"
//自选/取消自选 交易对
let wAddOrDeleteFavourCurrencyPairHttpURLString = httpTestURLString + "/api/exchange/favourcurrencypair"
//申请上传Token
let wApplyUploadTokenHttpURLString = httpTestURLString + "/api/upload/applyuploadtoken"
//释放币
let wCompletetradeHttpURLString = httpTestURLString + "/api/market/completetrade"
//尝试创建交易 下单
let wTrycreatetrade = httpTestURLString + "/api/market/trycreatetrade"
//尝试创建交易 下单
let w24hrTickerHttpURLString = httpTestPublicURLString + "/api/v1/ticker/24hr"
//标记交易已付款
let wCompleteTradePayMent = httpTestURLString + "/api/market/completetradepayment"
//取消广告订单
let wCancelOrder = httpTestURLString + "/api/market/cancelorder"
//获取法币所有交易对
let wGetCurrencypairs = httpTestURLString + "/api/market/getcurrencypairs"
//获取收款设置
let wGetPaymentSetting = httpTestURLString + "/api/user/getpaymentsetting"
//保存收款设置
let wSavePaymentSetting = httpTestURLString + "/api/user/savepaymentsetting"
//生成预签名uri
let wGeneratepresigneduri = httpTestURLString + "/api/upload/generatepresigneduri"
//发布广告
let wCreateOrder = httpTestURLString + "/api/market/createorder"
//法币交易验证
let wValidate = httpTestURLString + "/api/market/validate"
//获取交易中的订单
let wGetOpenOrderList = httpTestURLString + "/api/market/getopenorderlist"
//获取我下架的订单
let wGetmyCloseOrderList = httpTestURLString + "/api/market/getmycloseorderlist"
//获取交易对当前市场价
let wGetmarketprice = httpTestURLString + "/api/market/getmarketprice"
//获取订单详情
let wGetOrder = httpTestURLString + "/api/market/getorder"
//获取可交易的订单
let wGetTradingOrders  = httpTestURLString + "/api/market/gettradingorders"
//获取我进行中的交易
let wGetMyOpenTradeList = httpTestURLString + "/api/market/getmyopentradelist"
//获取我已关闭的交易
let wGetMyCloseTradeList = httpTestURLString + "/api/market/getmyclosetradelist"
//获取交易详情
let wGetTrade = httpTestURLString + "/api/market/gettrade"
//获取身份认证信息
let wGetIdentityAuth = httpTestURLString + "/api/user/getidentityauth"
//获取配置
let wGetUserConfig = httpTestURLString + "/api/user/getconfig"
//保存身份认证
let wSaveSidentityauth = httpTestURLString + "/api/user/saveidentityauth"
//获取聊天消息
let wGetTalkMessageList = httpTestURLString + "/api/market/gettalkmessagelist"
//发送聊天消息
let wSendTalkMessage = httpTestURLString + "/api/market/sendtalkmessage"
//开启/关闭谷歌验证
let wSwitchGoogleAuth = httpTestURLString + "/api/user/switchgoogleauth"
//取消申诉
let wTryCancelTradeAppeal = httpTestURLString + "/api/market/trycanceltradeappeal"
//申诉
let wTryCreateTradeAppeal = httpTestURLString + "/api/market/trycreatetradeappeal"
