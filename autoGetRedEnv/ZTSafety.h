//
//  ZTSafety.h
//  ZTWeChatDylib
//
//  Created by ZT0526 on 2017/10/23.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

/*
 * NSArray
 */
@interface NSArray (ZTSafety)

- (id)SafetyObjectAtIndex:(NSUInteger)index;

@end


/*
 * NSMutableArray
 */
@interface NSMutableArray (ZTSafety)

- (BOOL)SafetyAddObject:(id)anObject;
- (BOOL)SafetyInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (BOOL)SafetyRemoveObject:(id)anObject;
- (BOOL)SafetyRemoveObjectAtIndex:(NSUInteger)index;
- (BOOL)SafetyReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end

/*
 * NSMutableDictionary
 */
@interface NSMutableDictionary (ZTSafety)

- (void)SafetySetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

@interface NSCalendar(ZTSafety)

- (NSDate *)safeDateFromComponents:(NSDateComponents *)comps;
- (NSDateComponents *)safeComponents:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date;

@end

