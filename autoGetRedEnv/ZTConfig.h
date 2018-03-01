//
//  ZTConfig.h
//  ZTWeChatDylib
//
//  Created by ZT0526 on 2017/10/23.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kZTConfig [ZTConfig sharedConfig]

@interface ZTConfig : NSObject

+ (instancetype)sharedConfig;

@property (nonatomic, getter = isAutoGrapEnv) BOOL autoGrapEnv;
@property (nonatomic, assign) NSInteger     stepCount;

- (void)autoGrabEnvSwitchAction:(UISwitch *)autoGrabEnv;

- (void)handleStepCount:(id )stepCountStr;

@end
