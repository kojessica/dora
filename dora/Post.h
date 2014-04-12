//
//  Post.h
//  dora
//
//  Created by Benjamin Chang on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Group.h"
#import "LocationController.h"
#import "Parse/Parse.h"

@interface Post : NSObject
@property (nonatomic, strong) NSMutableDictionary *data;
- (id)initWithDictionary:(NSDictionary *)data;
+(void) postWithUser:(User*)user group:(Group*)group text:(NSString*)content location:(CLLocation*) location;
+(NSArray*) retrievePostsFromGroup:(Group*) group;
+(void) likePostWithId:(NSString*)postId;
+(void) dislikePostWithId:(NSString*)postId;
+(void) setPopularityWithNumber:(NSNumber*)popularity;
- (NSString*) getText;
- (NSString*) getUserId;
- (NSString*) getLikes;
- (NSString*) getDislikes;
- (NSString*) getPopularity;
- (PFGeoPoint*) getLocation;


@end
