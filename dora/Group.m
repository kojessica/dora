//
//  Group.m
//  dora
//
//  Created by Benjamin Chang on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Group.h"


@implementation Group

@dynamic name;
@dynamic objectId;
@dynamic popularIndex;
@dynamic totalPosts;
@dynamic location;
@dynamic updatedAt;
@dynamic firstPost;
@dynamic secondPost;

+ (NSString *)parseClassName {
    return @"Groups";
}

+ (Group*)createGroupWithName:(NSString*)name location:(CLLocation*) location {
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    Group *group = [Group object];
    group.name = name;
    group.location = geoPoint;
    group.popularIndex = [NSNumber numberWithInt:0];
    group.totalPosts = [NSNumber numberWithInt:0];

    [group saveInBackground];
    return group;
}

+ (Group*)createGroupWithName:(NSString*)name location:(CLLocation*) location completion:(void(^)(PFObject *object, NSError *error))completion{
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    Group *group = [Group object];
    group.name = name;
    group.location = geoPoint;
    group.popularIndex = [NSNumber numberWithInt:0];
    group.totalPosts = [NSNumber numberWithInt:0];
    
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(group, error);
	}];
    return group;
}

+ (void)getGroupWithName:(NSString*)name completion:(void(^) (PFObject *object, NSError *error))completion{
    PFQuery *query = [Group query];
    [query whereKey:@"name" equalTo:name];
    [query getFirstObjectInBackgroundWithBlock:completion];
    return;
}

+ (void)getAllGroupsWithCompletion:(void(^) (NSArray *objects, NSError *error))completion {
    PFQuery *query = [Group query];
    [query whereKeyExists:@"name"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:completion];
    return;
}

+ (void)getAllGroupsByNames:(NSArray *)names WithCompletion:(void(^) (NSArray *objects, NSError *error))completion {
    PFQuery *query = [Group query];
    [query whereKey:@"name" containedIn:names];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:completion];
    return;
}

+ (void)getPopularGroupsWithCompletion:(void(^) (NSArray *objects, NSError *error))completion {
    PFQuery *query = [Group query];
    [query whereKeyExists:@"name"];
    [query orderByDescending:@"totalPosts"];
    [query findObjectsInBackgroundWithBlock:completion];
    return;
}
@end
