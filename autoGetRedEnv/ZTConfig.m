//
//  ZTConfig.m
//  ZTWeChatDylib
//
//  Created by ZT0526 on 2017/10/23.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTConfig.h"

#define kZTUserDefaults [NSUserDefaults standardUserDefaults]
#define kZTAutoGrapEnvKey @"ZTAutoGrapEnvKey"

@implementation ZTConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    static ZTConfig *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [ZTConfig new];
    });
    return _instance;
}

- (BOOL)isAutoGrapEnv {
    return [kZTUserDefaults boolForKey:kZTAutoGrapEnvKey];
}

- (void)setAutoGrapEnv:(BOOL)autoGrapEnv {
    [kZTUserDefaults setBool:autoGrapEnv forKey:kZTAutoGrapEnvKey];
    [kZTUserDefaults synchronize];
}

- (void)autoGrabEnvSwitchAction:(UISwitch *)autoGrabEnv {
    self.autoGrapEnv = autoGrabEnv.isOn;
}

- (void)handleStepCount:(id )stepCountStr{
    if([stepCountStr isKindOfClass:[UITextField class]]){
        UITextField *textLb = (UITextField *)stepCountStr;
        if(textLb.text.length > 0) self.stepCount = [textLb.text integerValue];
    }
    
}

@end
