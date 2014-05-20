//
//  Timestamp.m
//  dora
//
//  Created by Jessica Ko on 4/18/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
#import "Timestamp.h"

@implementation Timestamp


//2011-06-10T18:33:42Z

+ (NSDate*)dateWithJSONString:(NSString*)dateStr
{
    //NSLog(@"Date -- %@",dateStr);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM d HH:mm:ss ZZZ yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // Test data object if desired output format is achieved
    [dateFormat setDateFormat:@"EEE, MMM d YYYY"];
//    dateStr = [dateFormat stringFromDate:date];
    //NSLog(@"Date -- %@",dateStr);
    
    return date;
}

+ (NSString*)formattedDateWithJSONString:(NSString*)dateStr
{
    //Tue Aug 28 21:16:23 +0000 2012
    //2014-04-23 17:12:09 +0000
    //NSLog(@"Date -- %@",dateStr);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-d HH:mm:ss ZZZ"];
    //[dateFormat setDateFormat:@"EEE MMM d HH:mm:ss ZZZ yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    //9:16 PM 28 Aug 2012
    [dateFormat setDateFormat:@"h:mm a - d MMM YYYY"];
    dateStr = [dateFormat stringFromDate:date];
    //NSLog(@"Date -- %@",dateStr);
    
    return dateStr;
}

+ (NSString *)relativeTimeWithTimestamp:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setAMSymbol:@"am"];
    [dateFormatter setPMSymbol:@"pm"];
    
    NSString* timestamp;
    int timeIntervalInHours = (int)[[NSDate date] timeIntervalSinceDate:date] /3600;
    
    int timeIntervalInMinutes = (int)[[NSDate date] timeIntervalSinceDate:date] /60;
    
    if (timeIntervalInMinutes < 60){//less than 15 minutes old
        
        timestamp = [NSString stringWithFormat:@"%dm",timeIntervalInMinutes];
        
    } else if (timeIntervalInHours < 24){//less than 1 day
        
        timestamp = [NSString stringWithFormat:@"%dh",timeIntervalInHours];
        
    } else if (timeIntervalInHours < 8765){//less than a year
        
        [dateFormatter setDateFormat:@"d MMM"];
        timestamp = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        
    } else {//older than a year
        
        [dateFormatter setDateFormat:@"d MMM yyyy"];
        timestamp = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        
    }
    
    return timestamp;
}

@end
