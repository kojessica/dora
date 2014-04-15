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
#import "Parse/PFObject+subclass.h"

@interface Post : PFObject <PFSubclassing>

+ (NSString *)parseClassName;
+(void) postWithUser:(User*)user group:(Group*)group text:(NSString*)content location:(CLLocation*) location;
+(NSArray*) retrievePostsFromGroup:(Group*) group;
+(void) likePostWithId:(NSString*)postId;
+(void) dislikePostWithId:(NSString*)postId;
+(void) setPopularityWithNumber:(NSNumber*)popularity;
@property (retain) NSString *text;
@property (retain) NSString *userId;
@property (retain) NSString *groupId;
@property (retain) NSNumber *likes;
@property (retain) NSNumber *dislikes;
@property (retain) PFGeoPoint *location;
@property (retain) NSNumber *popularity;

@end
