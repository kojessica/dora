//
//  Group.m
//  dora
//
//  Created by Benjamin Chang on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Group.h"
#import "Parse/Parse.h"

@implementation Group
@synthesize data = _data;
- (id)initWithDictionary:(NSMutableDictionary *)data {
    if (self = [super init]) {
        _data = data;
    }
    
    return self;
}

- (id)init {
    self = [super init];
    self.data = [[NSMutableDictionary alloc] init];
    return self;
}

+ (Group*)createGroupWithName:(NSString*)name location:(CLLocation*) location {
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    PFObject *pfGroup = [PFObject objectWithClassName:@"Groups"];
    pfGroup[@"name"] = name;
    pfGroup[@"location"] = geoPoint;
    pfGroup[@"popularIndex"] = [NSNumber numberWithInt:0];;
    pfGroup[@"totalPosts"] = [NSNumber numberWithInt:0];;

    [pfGroup saveInBackground];
    Group *group = [[Group alloc] init];
    group.data[@"name"] = name;
    group.data[@"objectId"] = pfGroup[@"objectId"];
    if(geoPoint != nil) {
        group.data[@"location"] = geoPoint;
    }
    group.data[@"popularIndex"] = [NSNumber numberWithInt:0];
    group.data[@"totalPosts"] = [NSNumber numberWithInt:0];
    return group;
}


+ (Group*)getGroupWithName:(NSString*)name {
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    [query whereKey:@"name" equalTo:name];
    PFObject *object = [query getFirstObject];
    Group *group = [[Group alloc] init];
    group.data = [[object dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"name",@"objectId",@"location",@"popularIndex",@"totalPosts", nil]] mutableCopy];
    return group;
}

+ (NSArray *)getAllGroups {
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    [query whereKeyExists:@"name"];
    NSArray *objects = [query findObjects];
    return objects;
}

- (void)setName:(NSString*)name {
    NSString *objectId = self.data[@"objectId"];
    PFQuery *query = [PFQuery queryWithClassName:@"Company"];
    [query whereKey:@"objectId" equalTo:objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"name"] = name;
        [object saveInBackground];
        self.data[@"name"] = name;
    }];
    
}

- (void)setObjectId:(NSString*) objectId {
    NSString *originalObjectId = self.data[@"objectId"];
    PFQuery *query = [PFQuery queryWithClassName:@"Company"];
    [query whereKey:@"objectId" equalTo:originalObjectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"objectId"] = objectId;
        [object saveInBackground];
        self.data[@"objectId"] = objectId;
    }];
    
}

- (void)setPopularityIndex:(NSNumber *)popularityIndex {
    NSString *objectId = self.data[@"objectId"];
    PFQuery *query = [PFQuery queryWithClassName:@"Company"];
    [query whereKey:@"objectId" equalTo:objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"popularIndex"] = popularityIndex;
        [object saveInBackground];
        self.data[@"popularIndex"] = popularityIndex;
    }];
    
}

- (void)setTotalPosts:(NSNumber *)totalPosts {
    NSString *objectId = self.data[@"objectId"];
    PFQuery *query = [PFQuery queryWithClassName:@"Company"];
    [query whereKey:@"objectId" equalTo:objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"totalPosts"] = totalPosts;
        [object saveInBackground];
        self.data[@"totalPosts"] = totalPosts;
    }];
}

- (NSString*)getName {
    return self.data[@"name"];
}
- (NSString*)getObjectId {
    return self.data[@"objectId"];
}
- (NSNumber*)getPopularityIndex {
    return self.data[@"popularIndex"];
}
- (NSNumber*)getTotalPosts {
    return self.data[@"totalPosts"];
}
- (PFGeoPoint*)getLocation {
    return self.data[@"location"];
}

@end
