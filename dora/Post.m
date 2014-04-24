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
@dynamic updatedAt;
@dynamic popularity;
@dynamic newKey;
@dynamic age;
@dynamic gender;

+(NSString *)parseClassName {
    return @"Post";
}

+ (NSString *)setRandomKey {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < 20; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        [randomString appendFormat:@"%C", [alphabet characterAtIndex:r]];
    }
    return randomString;
}

+(void) postWithUser:(User*)user group:(Group*)group text:(NSString*)content location:(CLLocation*) location newKey:(NSString *)newkey {
    Post *post = [Post object];
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    post.groupId = group.objectId;
    post.text = content;
    post.userId = [[User currentUser] objectId];
    post.likes = [NSNumber numberWithInt:0];
    post.dislikes = [NSNumber numberWithInt:0];
    post.popularity = [NSNumber numberWithInt:0];
    post.newKey = newkey;
    post.age = [[User currentUser] age];
    post.gender = [[User currentUser] gender];
    
    if(geoPoint != nil) {
      post.location = geoPoint;
    }
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        group.firstPost = 0;
        
        [post objectId];
    }];
}

+(void)getPostWithNewKey:(NSString*)key completion:(void(^) (PFObject *object, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"newKey" equalTo:key];
    [query getFirstObjectInBackgroundWithBlock:completion];
    return;
}

+(void) retrieveRecentPostsFromGroup:(Group*) group number:(NSNumber*)number completion:(void (^) (NSArray* objects, NSError* error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"groupId" equalTo:group.objectId];
    [query orderByDescending:@"createdAt"];
    query.limit = [number intValue];
    [query findObjectsInBackgroundWithBlock:completion];
    return;
}

+(void) retrievePostsFromGroup:(Group*) group completion:(void (^) (NSArray* objects, NSError* error))completion {
    PFQuery *query = [Post query];
    [query whereKey:@"groupId" equalTo:group.objectId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:completion];
}

+(void) likePostWithId:(NSString*)postId {
    PFQuery *query = [Post query];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object incrementKey:@"likes"];
        [object saveInBackground];
    }];
}

+(void) unlikePostWithId:(NSString*)postId {
    PFQuery *query = [Post query];
    [query whereKey:@"objectId" equalTo:postId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object incrementKey:@"likes" byAmount:[NSNumber numberWithInt:-1]];
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
