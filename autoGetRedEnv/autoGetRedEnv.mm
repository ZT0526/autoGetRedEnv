//
//  autoGetRedEnv.m
//  autoGetRedEnv
//
//  Created by East on 16/3/21.
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//

#import "CaptainHook.h"
#import "ZTClassHeaders.h"
#import "ZTConfig.h"
#import "ZTSafety.h"


#define SAVESETTINGS(key, value) { \
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); \
NSString *docDir = [paths objectAtIndex:0]; \
if (!docDir){ return;} \
NSMutableDictionary *dict = [NSMutableDictionary dictionary]; \
NSString *path = [docDir stringByAppendingPathComponent:@"HBPluginSettings.txt"]; \
[dict setObject:value forKey:key]; \
[dict writeToFile:path atomically:YES]; \
}

#define ZTParamKey @"ZTParamKey"
#define kZTAutoGrapEnvKey @"ZTAutoGrapEnvKey"
#define ZTUserDefaults [NSUserDefaults standardUserDefaults]


CHDeclareClass(CMessageMgr);

CHDeclareClass(MMTableViewInfo);
CHDeclareClass(MMTableView);
CHDeclareClass(MMTableViewCellInfo);
CHDeclareClass(MMTableViewSectionInfo);

CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2) {
    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);
    
    NSUInteger m_uiMessageType = [arg2 m_uiMessageType];
    
    id m_nsFromUsr = [arg2 m_nsFromUsr];
    id m_nsContent = [arg2 m_nsContent];
    
    switch(m_uiMessageType) {
            
        case 49: {
            id logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("WCRedEnvelopesLogicMgr")];
            id contactManager =[[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
            id selfContact = [contactManager getSelfContact];
            id m_nsUsrName = [selfContact m_nsUsrName];
            
            if ([m_nsFromUsr isEqualToString:m_nsUsrName]) {//不抢自己的红包
                return;
            }
            
            if ([m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound) {
                if (!kZTConfig.isAutoGrapEnv) {
                    return;
                }
                
                NSString *nativeUrl = m_nsContent;
                NSRange rangeStart = [m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao"];
                if (rangeStart.location != NSNotFound) {
                    NSUInteger locationStart = rangeStart.location;
                    nativeUrl = [nativeUrl substringFromIndex:locationStart];
                }
                
                NSRange rangeEnd = [nativeUrl rangeOfString:@"]]"];
                if (rangeEnd.location != NSNotFound) {
                    NSUInteger locationEnd = rangeEnd.location;
                    nativeUrl = [nativeUrl substringToIndex:locationEnd];
                }
                
                NSString *naUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                
                NSArray *parameterPairs =[naUrl componentsSeparatedByString:@"&"];
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
                for (NSString *currentPair in parameterPairs) {
                    NSRange range = [currentPair rangeOfString:@"="];
                    if(range.location == NSNotFound)
                        continue;
                    NSString *key = [currentPair substringToIndex:range.location];
                    NSString *value =[currentPair substringFromIndex:range.location + 1];
                    [parameters SafetySetObject:value forKey:key];
                }
                
                //红包参数
                NSMutableDictionary *params = [@{} mutableCopy];
                
                [params SafetySetObject:parameters[@"msgtype"] forKey:@"msgType"];
                [params SafetySetObject:parameters[@"sendid"] forKey:@"sendId"];
                [params SafetySetObject:parameters[@"channelid"] forKey:@"channelId"];
                
                id getContactDisplayName = [selfContact getContactDisplayName];
                id m_nsHeadImgUrl = [selfContact m_nsHeadImgUrl];
                
                [params SafetySetObject:getContactDisplayName forKey:@"nickName"];
                [params SafetySetObject:m_nsHeadImgUrl forKey:@"headImg"];
                [params SafetySetObject:[NSString stringWithFormat:@"%@", nativeUrl] forKey:@"nativeUrl"];
                [params SafetySetObject:m_nsFromUsr forKey:@"sessionUserName"];
                
                [ZTUserDefaults setObject:params forKey:ZTParamKey];
                
                NSMutableDictionary* dictParam = [NSMutableDictionary dictionary];

                [dictParam SafetySetObject:@"0" forKey:@"agreeDuty"];                                             //agreeDuty
                [dictParam SafetySetObject:parameters[@"channelid"] forKey:@"channelId"];        //channelId
                [dictParam SafetySetObject:@"1" forKey:@"inWay"];                                                 //inWay
                [dictParam SafetySetObject:parameters[@"msgtype"] forKey:@"msgType"];            //msgType
                [dictParam SafetySetObject:nativeUrl forKey:@"nativeUrl"];                                     //nativeUrl
                [dictParam SafetySetObject:parameters[@"sendid"] forKey:@"sendId"];              //sendId
                
                NSLog(@"dictParam=%@", dictParam);
                ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(ReceiverQueryRedEnvelopesRequest:), dictParam);
                
                return;
            }
            
            break;
        }
        default:
            break;
    }
}

CHOptimizedMethod(1, self, void, CMessageMgr, onRevokeMsg, id, value1) {
    
}

#pragma mark - WCRedEnvelopesLogicMgr

CHDeclareClass(WCRedEnvelopesLogicMgr);

CHOptimizedMethod1(self, void, WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest, id, arg1) {
    NSLog(@"%@", arg1);
    CHSuper1(WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest, arg1);
}

CHOptimizedMethod1(self, void, WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, id, arg1) {
    CHSuper1(WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, arg1);
}

CHOptimizedMethod2(self, void, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, id, arg1, Request, id, arg2) {
    NSLog(@"%@", arg1);
    NSLog(@"%@", arg2);
    /*
     <HongBaoRes: 0x1123400f0>
     <HongBaoReq: 0x1123805f0>
     */
    
    CHSuper2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, arg1, Request, arg2);
    
    if ([ZTUserDefaults boolForKey:kZTAutoGrapEnvKey]) {
        if ([NSStringFromClass([arg1 class]) isEqualToString:@"HongBaoRes"]) {
            NSData *data = [[arg1 retText] buffer];
            
            if (nil != data && 0 < [data length]) {
                NSError* error = nil;
                id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
                if (nil != error) {
                    NSLog(@"error %@", [error localizedDescription]);
                }
                else if (nil != jsonObj)
                {
                    if ([NSJSONSerialization isValidJSONObject:jsonObj]) {
                        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                            id idTemp = jsonObj[@"timingIdentifier"];
                            if (idTemp) {
                                NSMutableDictionary *params = [[ZTUserDefaults objectForKey:ZTParamKey] mutableCopy];
                                [ZTUserDefaults setObject:[NSMutableDictionary dictionary] forKey:ZTParamKey];
                                [params SafetySetObject:idTemp forKey:@"timingIdentifier"]; // "timingIdentifier"字段
                                
                                // 防止重复请求
                                if (params.allKeys.count < 2) {
                                    return;
                                }
                                
                                id logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("WCRedEnvelopesLogicMgr")];
                                
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^(void) {
                                    ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(OpenRedEnvelopesRequest:), params);
                                });
                            }
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - WCDeviceStepObject
CHDeclareClass(WCDeviceStepObject)
////修改步数
CHOptimizedMethod(0, self, unsigned long, WCDeviceStepObject, m7StepCount) {
    if(kZTConfig.stepCount == 0){
        kZTConfig.stepCount = CHSuper0(WCDeviceStepObject, m7StepCount);
    }
    
    return kZTConfig.stepCount;
}

CHOptimizedMethod(0, self, unsigned long, WCDeviceStepObject, hkStepCount) {
    if(kZTConfig.stepCount == 0){
        kZTConfig.stepCount = CHSuper0(WCDeviceStepObject, m7StepCount);
    }
    
    return kZTConfig.stepCount;
}

//添加抢红包以及修改步数选择
#pragma mark - NewSettingViewController
CHDeclareClass(NewSettingViewController)

CHOptimizedMethod0(self, void, NewSettingViewController, reloadTableData) {
    CHSuper0(NewSettingViewController, reloadTableData);
    MMTableViewInfo *tableInfo = [self valueForKey:@"m_tableViewInfo"];
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    MMTableViewCellInfo *autoGrapRedEnvCellInfo = [objc_getClass("MMTableViewCellInfo")
                                                   switchCellForSel:@selector(autoGrabEnvSwitchAction:)
                                                   target:kZTConfig
                                                   
                                                   title:@"自动抢红包"
                                                   
                                                   on:kZTConfig.isAutoGrapEnv];
    [sectionInfo addCell:autoGrapRedEnvCellInfo];
    
    MMTableViewCellInfo *setpCell = [objc_getClass("MMTableViewCellInfo") editorCellForSel:@selector(handleStepCount:)
                                                                                    target:kZTConfig
                                                                                       tip:@"请输入步数"
                                                                                     focus:NO
                                                                                      text:[NSString stringWithFormat:@"%ld", (long)kZTConfig.stepCount]];
    [sectionInfo addCell:setpCell];
    
    [tableInfo insertSection:sectionInfo At:0];
    MMTableView *tableView = [tableInfo getTableView];
    [tableView reloadData];
}

__attribute__((constructor)) static void entry()
{
    //加载CMessageMgr类
    CHLoadLateClass(CMessageMgr);
    //hook AsyncOnAddMsg:MsgWrap:方法
    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
    // 消息防撤回
    CHHook(1, CMessageMgr, onRevokeMsg);
    
    // 微信步数
    CHLoadLateClass(WCDeviceStepObject);
    CHHook(0, WCDeviceStepObject, m7StepCount);
    CHHook(0, WCDeviceStepObject, hkStepCount);
    
}

