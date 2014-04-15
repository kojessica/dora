//
//  Post.m
//  dora
//
//  Created by Benjamin Chang on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Post.h"


@implementation Post
@dynamic text;
@dynamic userId;
@dynamic groupId;
@dynamic likes;
@dynamic dislikes;
@dynamic location;
@dynamic popularity;


+ (NSString *)parseClassName {
    return @"Post";
}

+(void) postWithUser:(User*)user group:(Group*)group text:(NSString*)content location:(CLLocation*) location {
    Post *post = [Post object];
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];

    post.groupId = group.objectId;
    post.text = content;
    post.userId = [User currentUserDictionary][@"objectId"];
    post.likes = [NSNumber numberWithInt:0];
    post.dislikes = [NSNumber numberWithInt:0];
    post.popularity = [NSNumber numberWithInt:0];
    if(geoPoint != nil) {
      post.location = geoPoint;
    }
    [post saveInBackground];
    
}

+(NSArray*) retrieveRecentPostsFromGroup:(Group*) group number:(NSNumber*)number {
    NSNumber *numPosts = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"groupId" equalTo:group.objectId];
    NSArray* results = [query findObjects];
    NSMutableArray* postResult = [[NSMutableArray alloc] init];
    for (Post *post in results) {
        if(numPosts < number) {
            [postResult addObject:post];
            numPosts = [NSNumber numberWithInt:[numPosts intValue] + 1];
        }
        else {
            break;
        }
    }
    return postResult;
    
}

+(NSArray*) retrievePostsFromGroup:(Group*) group {
    PFQuery *query = [Post query];
    [query whereKey:@"groupId" equalTo:group.objectId];
    NSArray* results = [query findObjects];
    return results;
}

+(void) likePostWithId:(NSString*)postId {
    PFQuery *query = [Post query];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object incrementKey:@"likes"];
        [object saveInBackground];
    }];
}
+(void) dislikePostWithId:(NSString*)postId {
    PFQuery *query = [Post query];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object incrementKey:@"dislikes"];
        [object saveInBackground];
    }];
    
}
+(void) setPopularityWithNumber:(NSNumber*)popularity {
    
}

@end
