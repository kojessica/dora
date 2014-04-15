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
@dynamic popularIndex;
@dynamic totalPosts;
@dynamic location;
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
    group.popularIndex = [NSNumber numberWithInt:0];;
    group.totalPosts = [NSNumber numberWithInt:0];;

    [group saveInBackground];
    return group;
}


+ (Group*)getGroupWithName:(NSString*)name {
    PFQuery *query = [Group query];
    [query whereKey:@"name" equalTo:name];
    PFObject *group = [query getFirstObject];
    return (Group*)group;
}

+ (NSArray *)getAllGroups {
    PFQuery *query = [Group query];
    [query whereKeyExists:@"name"];
    NSArray *objects = [query findObjects];
    return objects;
}
@end
