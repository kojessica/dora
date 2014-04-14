//
//  Post.m
//  dora
//
//  Created by Benjamin Chang on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Post.h"

@implementation Post
- (id)initWithDictionary:(NSMutableDictionary *)data {
    if (self = [super init]) {
        _data = data;
    }
    
    return self;
}

-(id)init {
    self = [super init];
    self.data = [[NSMutableDictionary alloc] init];
    return self;
}

+(void) postWithUser:(User*)user group:(Group*)group text:(NSString*)content location:(CLLocation*) location {
    PFObject *post = [PFObject objectWithClassName:@"Post"];
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];

    post[@"groupId"] = group.getObjectId;
    post[@"text"] = content;
    post[@"userId"] = [User currentUserDictionary][@"objectId"];
    post[@"likes"] = [NSNumber numberWithInt:0];
    post[@"dislikes"] = [NSNumber numberWithInt:0];
    post[@"popularity"] = [NSNumber numberWithInt:0];
    if(geoPoint != nil) {
      post[@"location"] = geoPoint;
    }
    [post saveInBackground];
    
}

+(NSArray*) retrieveRecentPostsFromGroup:(Group*) group number:(NSNumber*)number {
    NSNumber *numPosts = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"groupId" equalTo:group.getObjectId];
    NSArray* results = [query findObjects];
    NSMutableArray* postResult = [[NSMutableArray alloc] init];
    for (PFObject *object in results) {
        if(numPosts < number) {
            Post *post = [[Post alloc] init];
            post.data = [[object dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"text",@"userId",@"likes",@"dislikes",@"popularity",@"objectId",@"location",@"groupId", nil]] mutableCopy];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"groupId" equalTo:group.getObjectId];
    NSArray* results = [query findObjects];
    NSMutableArray* postResult = [[NSMutableArray alloc] init];
    for (PFObject *object in results) {
        Post *post = [[Post alloc] init];
        post.data = [[object dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"text",@"userId",@"likes",@"dislikes",@"popularity",@"objectId",@"location",@"groupId", nil]] mutableCopy];
        [postResult addObject:post];
    }
    return postResult;
}
+(void) likePostWithId:(NSString*)postId {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object incrementKey:@"likes"];
        [object saveInBackground];
    }];
}
+(void) dislikePostWithId:(NSString*)postId {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object incrementKey:@"dislikes"];
        [object saveInBackground];
    }];
    
}
+(void) setPopularityWithNumber:(NSNumber*)popularity {
    
}
- (NSString*) getText {
    return self.data[@"text"];
}
- (NSString*) getUserId {
    return self.data[@"userId"];
}
- (NSString*) getLikes {
    return self.data[@"likes"];
}
- (NSString*) getDislikes {
    return self.data[@"dislikes"];
}
- (NSString*) getPopularity {
    return self.data[@"popularity"];
}
- (PFGeoPoint*) getLocation {
    return self.data[@"location"];
}

@end
