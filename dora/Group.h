//
//  Group.h
//  dora
//
//  Created by Benjamin Chang on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"

@interface Group : NSObject
@property (nonatomic, strong) NSMutableDictionary *data;
- (id)initWithDictionary:(NSDictionary *)data;
+ (Group*)createGroupWithName:(NSString*)name location:(CLLocation*) location;

- (void)setName:(NSString*)name;
- (void)setObjectId:(NSString*) objectId;
- (void)setPopularityIndex:(NSNumber *)popularityIndex;
- (void)setTotalPosts:(NSNumber *)totalPosts;
- (NSString*)getName;
- (NSString*)getObjectId;
- (NSNumber*)getPopularityIndex;
- (NSNumber*)getTotalPosts;

@end
