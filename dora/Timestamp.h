//
//  Timestamp.h
//  dora
//
//  Created by Jessica Ko on 4/18/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import Foundation;

@interface Timestamp : NSObject

+ (NSString *)relativeTimeWithTimestamp:(NSDate *)date;
+ (NSDate*)dateWithJSONString:(NSString*)dateStr;
+ (NSString*)formattedDateWithJSONString:(NSString*)dateStr;

@end

