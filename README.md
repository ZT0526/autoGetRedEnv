# autoGetRedEnv
微信自动抢红包、修改步数、防止消息撤回
# 


## 从去年使用到现在  已经用了很长时间了，没有被封号！

需要准备的东西
[dumpdecrypted](https://github.com/stefanesser/dumpdecrypted) 砸壳用
[yololib](https://github.com/KJCracks/yololib) 注入需要用到
[class-dump](https://github.com/nygard/class-dump) 获取头文件用到，用于分析代码
[iOSOpenDev](http://iosopendev.com/download/)
[iTools](http://www.itools.cn/)或者pp助手等
OpenSSH(通过越狱手机Cydia安装)
Cycript(通过越狱手机Cydia安装)
Command Line Tools
reveal(查看应用运行界面)
hopper(查看二进制文件，用于分析代码)
Xcode
苹果开发者证书或企业证书以及配置文件
一台越狱的iPhone
微信程序安装包

## 一、砸壳
     获取砸壳后的文件有两种 ：1.自己手动砸壳 2.通过第三方越狱平台下载已经砸壳的微信(如itools  pp助手等)

手动砸壳：
### 1.先在越狱软件上安装ssh插件OpenSSH  ,命令行下和应用交互的插件Cycript

### 2.让越狱手机和mac电脑在同一个局域网下(为了能够通过ssh服务从mac电脑访问手机)

### 3.在mac的命令行终端  通过ssh服务登录手机  输入ssh root@192.168.80.212(手机ip)。默认情况下的root密码是alpine。root密码可以自己修改。

![399D152C-81F3-4FCA-9DDF-D351FBE72C13.png](http://upload-images.jianshu.io/upload_images/1716542-6cb674a834b69fbf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 4.在手机上运行微信  ， 然后通过获取运行程序的命令加上管道命令  ps -e | grep WeChat  筛选出WeChat的文件路径  并做记录稍后会用到
我这里得到的路径是  /var/containers/Bundle/Application/D7DA798A-006B-4B9F-AD53-EDF4D52A1BAE/WeChat.app/WeChat(需要自己去获取)

![56D7977B-3E75-4505-98B7-2B1BAFDCD991.png](http://upload-images.jianshu.io/upload_images/1716542-c4bae63074a473d7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 5.查找到WeChat的Documents路径，输入cycript -p WeChat，进入cycript命令状态

![57DAC8A2-AD31-4972-A921-F0C7CAAF85CA.png](http://upload-images.jianshu.io/upload_images/1716542-70b2c173240c2612.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 6.输入NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0]，获得Documents路径  并做记录稍后会用到.(需要微信在运行中，ctrl + d cycript结束命令状态
这里得到的路径是 **/var/mobile/Containers/Data/Application/B3DFAF56-E8EE-4CAD-A56B-884C21C43049/Documents(需要自己去获取)**

![2711B4E5-C657-4FF4-BF00-E760207C0A00.png](http://upload-images.jianshu.io/upload_images/1716542-fd401594092c9901.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 7.将dumpdecrypted拷贝到WeChat的Documents目录下，用于砸壳。将命令行切回Mac os,使用scp命令将文件拷贝到WeChat的Documents目录下

输入scp dumpdecrypted.dylib root@192.168.80.212:****Documents目录


![5F78387A-7807-4723-973F-3409D7144C17.png](http://upload-images.jianshu.io/upload_images/1716542-0d342f1678d4862c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 8.重新通过ssh服务登录手机，开始砸壳
    使用命令 DYLD_INSERT_LIBRARIES=/Documents路径dumpdecrypted.dylib 可执行文件路径
     在我的手机(ios9.3.2)上执行以上命令的时候出现了以下错误：
Killed: 9

![189F2AC1-1B83-4D33-9DF7-57792510C5EB.png](http://upload-images.jianshu.io/upload_images/1716542-9220855c92334b45.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

查了一下资料说要在mobile模式下运行以上命令，然后我再次执行,出现如下错误
Failed opening: Permission denied

![31692734-D1E3-424A-8A14-F2BECC80DAAA.png](http://upload-images.jianshu.io/upload_images/1716542-4e8a763e95e8180e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

八九个月以前 就是这个错误阻挡我前进的  但是我不甘心   经过反复尝试  使用下面的方法砸壳成功

cd到**Documents目录下  以mobile身份执行命令**
**DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib WeChat可执行文件目录。  终于成功了**
****

![EB4A14E5-720B-48F8-853C-DC836780271A.png](http://upload-images.jianshu.io/upload_images/1716542-0299b2cf217bb8e9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

命令会在当前目录下生成砸壳后的的文件 WeChat.decrypted

![B0619C85-E3CA-4089-8A53-24FB113F15A9.png](http://upload-images.jianshu.io/upload_images/1716542-7359bfaadc89a434.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 9.将WeChat.decrypted拷贝到Mac电脑上
scp root@192.168.80.212:/var/mobile/Containers/Data/Application/B3DFAF56-E8EE-4CAD-A56B-884C21C43049/Documents/WeChat.decrypted ./ (拷贝到当前目录)

![918C6A80-4C07-4040-870B-29B06403B896.png](http://upload-images.jianshu.io/upload_images/1716542-71307674a85aa0b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

检查砸壳是否成功 otool -l WeChat.decrypted | grep -B 2 crypt  。   cryptid 0表示成功 cryptid 1表示未成功  我的手机是5s,arm64中的cryptid是0  代表砸壳成功


![54FCCBEF-9FA2-4A68-BDC0-841E74D94C4E.png](http://upload-images.jianshu.io/upload_images/1716542-6c49bed99e1de484.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 10.将WeChat.app拷贝出来待使用
     这里拷贝的时候要使用  scp -r 
scp -r root@192.168.80.212:/var/containers/Bundle/Application/D7DA798A-006B-4B9F-AD53-EDF4D52A1BAE/WeChat.app ./

## 二、注入
### 一.安装iOSOpenDev
http://iosopendev.com/download/
 
xcode8及以上直接安装会出错  解决办法：
如果你们也遇到类似的问题，可以尝试下载[iOSOpenDev_Patches](https://github.com/provswin/Wechat-Auto-Red/blob/master/tools/iOSOpenDev_Patches.zip)，然后按照如下步骤：
#### 1、
把Specifications1文件夹重命名为Specifications放到/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/
#### 2、
把Specifications2文件夹重命名为Specifications放到/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/
#### 3、
把usr3重命名为usr放到/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/

#### 4、
安装[iOSOpenDev](http://iosopendev.com/download/)

### 二、生成dylib文件
     新建项目的时候选择Cocoa Touch Library，项目名为 autoGetRedEnv
 
![6986DB9C-EE6F-46BC-B03E-73E5AAA232E7.png](http://upload-images.jianshu.io/upload_images/1716542-05bee24a2fa7cf2f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从github中下载[autoGetRedEnv](https://github.com/east520/AutoGetRedEnv)工程源码中的CaptainHook.h和autoGetRedEnv.mm拷贝源码，复制到工程中对应文件中，完成后进行编译，即可得到libautoGetRedEnv.dylib文件。.mm文件里面抢红包的方法需要做修改，因为抢红包的方法已经改变。  不再是hook微信的AsyncOnAddMsg: MsgWrap:方法 然后调用打开红包的的方法 那么简单  

新的自动获取红包的方法：

hook微信的AsyncOnAddMsg: MsgWrap:  ，在这个方法中调用接收红包的方法 ReceiverQueryRedEnvelopesRequest
     
```

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
                
                //红包参数...
   
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
```
再hook OnWCToHongbaoCommonResponse 方法，在这个方法中再去调用 打开红包的方法  OpenRedEnvelopesRequest

```
CHDeclareClass(WCRedEnvelopesLogicMgr);

CHOptimizedMethod2(self, void, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, id, arg1, Request, id, arg2) {
    
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
                                //延迟1秒抢红包
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

```

为了减少被封号的几率  在前红包的时候 不要去抢自己的红包 不要重复去抢红包  必要的可以加上抢红包的延时

修改微信步数

```
#pragma mark - WCDeviceStepObjectCHDeclareClass(WCDeviceStepObject)////修改步数CHOptimizedMethod(0, self, unsigned long, WCDeviceStepObject, m7StepCount) {    return 6666;
}

CHOptimizedMethod(0, self, unsigned long, WCDeviceStepObject, hkStepCount) {    return 6666;

}

__attribute__((constructor)) static void entry()
{
    // 微信步数    CHLoadLateClass(WCDeviceStepObject);    CHHook(0, WCDeviceStepObject, m7StepCount);    CHHook(0, WCDeviceStepObject, hkStepCount);   
}

```

防止消息撤回 撤回消息的时候会调用onRevokeMsg  方法，我们hook这个方法  让它什么都不做

```

CHDeclareClass(CMessageMgr);
CHOptimizedMethod(1, self, void, CMessageMgr, onRevokeMsg, id, value1) {   
}

__attribute__((constructor)) static void entry(){    //加载CMessageMgr类
    CHLoadLateClass(CMessageMgr);
    // 消息防撤回
    CHHook(1, CMessageMgr, onRevokeMsg);  
}

```

我们还可以在设置界面中加入控制开关哦 微信中的设置页面是  NewSettingViewController 我们可以在里面添加两个cell来控制  抢红包的开关  以及设置步数。在设置页面中的cell类是MMTableViewSectionInfo  通过hopper可以看到里面有很多创建cell的方法  这里我们会用到下面两个方法。对于步数的保存以及红包开关的控制，使用一个单利类来保存


![EA14B06C-B893-4E99-A177-BD7740DB3DCF.png](http://upload-images.jianshu.io/upload_images/1716542-5311288933d4cffa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```

//添加抢红包以及修改步数选择
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

```

编译得到libautoGetRedEnv.dylib文件

三、注入dylib

     1.将WeChat.decrypted  改名为WeChat,然后通过**yoyolib**向**WeChat**注入**dylib**
****./yololib 目标可执行文件 需注入的dylib。注入成功如下所示****

![059F5C48-C8A2-4706-A373-27A023CFCE3D.png](http://upload-images.jianshu.io/upload_images/1716542-311f85092c04a330.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

三、重新签名打包
1.
新建Entitlements.plist
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>application-identifier</key>
<string>证书id.com.xx.xx</string>
<key>aps-environment</key>
<string>production</string>
<key>com.apple.developer.team-identifier</key>
<string>证书id</string>
<key>get-task-allow</key>
<false/>
</dict>
</plist>
```
当中所需要的信息  可以从以往的项目的app中得到  
/opt/iOSOpenDev/bin/ldid -e ./Demo.app/Demo

2.下载配置文件

从开发者网站下载一个与上面plist相匹配的配置文件，并命名为embedded.mobileprovision

3.将四个文件，放入到之前备份好的WeChat.app文件夹中：
1.embedded.mobileprovision
2.libautoGetRedEnv.dylib
3.注入libautoGetRedEnv.dylib后的WeChat文件
4.Entitlements.plist

这里需要注意  .plist文件 embedded.mobileprovision 以及打包需要的证书 这三个需要对应  不然打包会失败，无论尝试多少次 都会失败

4.重新给微信程序签名
codesign -f -s 证书名字 目标文件
具体操作步骤
```
codesign -f -s "iPhone Developer:xxxxx" WeChat.app/libautoGetRedEnv.dylib
codesign -f -s "iPhone Developer:xxxxx" WeChat.app/Watch/WeChatWatchNative.app/PlugIns/WeChatWatchNativeExtension.appex
codesign -f -s "iPhone Developer:xxxxx" WeChat.app/Watch/WeChatWatchNative.app
codesign -f -s "iPhone Developer:xxxxx" WeChat.app/PlugIns/WeChatShareExtensionNew.appex
codesign -f -s "iPhone Developer:xxxxx" --entitlements Entitlements.plist WeChat.app
```
打包成ipa
给微信重新签名后，我们就可以用xcrun来生成ipa了，具体实现如下：
xcrun -sdk iphoneos PackageApplication -v WeChat.app -o ~/WeChat.ipa
如果不想手动那样麻烦的操作的话 还可以使用签名的工具进行签名 我使用的是ios app signer

![81E5DCF6-8FCC-4B9E-BDDA-8BA0EF4C8DEB.png](http://upload-images.jianshu.io/upload_images/1716542-2f6132ca149fcbe5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打包出WeChat.ipa 然后使用itools安装到手机上


![AE75B962-0D48-4C6E-9710-45CA1E8A6023.png](http://upload-images.jianshu.io/upload_images/1716542-07bcd4c21847bf07.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

直接上效果

自动抢红包


![198F81BB-EFDB-439F-AAC1-B8F0E3399A2B.png](http://upload-images.jianshu.io/upload_images/1716542-5baf449c7cbd74a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

防止群消息撤回


![27C473B4-9407-4235-B473-3C4718FD60B3.png](http://upload-images.jianshu.io/upload_images/1716542-1756e2c848d70142.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

修改步数


![324B1D90-0CA4-4D66-A92A-FB8A97709EBE.png](http://upload-images.jianshu.io/upload_images/1716542-fb78fa2ed6c227d4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

自动抢红包开关以及设置步数


![71508837055_.pic.jpg](http://upload-images.jianshu.io/upload_images/1716542-e6524ef167ddf71e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
