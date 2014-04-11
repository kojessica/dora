//
//  User.m
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>
#import "CoreLocation/CoreLocation.h"

@interface User()

@end

@implementation User

//static CLLocationManager *_locationManager;
static User *currentUser = nil;

- (id)initWithDictionary:(NSMutableDictionary *)data {
    if (self = [super init]) {
        _data = data;
    }
    
    return self;
}

/*
+ (CLLocationManager *)locationManager {
    if (_locationManager != nil) {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    
    return _locationManager;
}
*/

+ (User *)currentUser {
    if (currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dictionary) {
            currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    NSLog(@"%@", currentUser.data);
    return currentUser;
}

+ (User *)setCurrentUser {
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
    [dictionary setObject:[self setRandomKey] forKey: @"key"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dictionary] forKey:@"current_user"];

    /*
     [[self locationManager] startUpdatingLocation];
    CLLocation *location = _locationManager.location;
    location.timestamp
    [[self locationManager] stopUpdatingLocation];
    CLLocationCoordinate2D cooridnate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:cooridnate.latitude longitude:cooridnate.longitude];
    */
    currentUser = [[User alloc] initWithDictionary:dictionary];
    PFObject *user = [PFObject objectWithClassName:@"Users"];
    user[@"key"] = [currentUser.data objectForKey:@"key"];
    //user[@"location"] = geoPoint;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"saved!");
    }];
    //(TODO): here we save lat long info of user
    return currentUser;
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

+ (NSDictionary *)currentUserDictionary {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dictionary;
}

+ (void)setUserGroup:(NSString *)groupName {
    NSString *userKey = currentUser.data[@"key"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"key" equalTo:userKey];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"defaultGroup"] = groupName;
        [object saveInBackground];
    }];
}

+ (void)setUserAge:(NSNumber *)age {
    NSString *userKey = currentUser.data[@"key"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"key" equalTo:userKey];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"age"] = age;
        [object saveInBackground];
    }];
}

+ (void)setUserGender:(NSString *)gender {
    NSString *userKey = currentUser.data[@"key"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"key" equalTo:userKey];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"gender"] = gender;
        [object saveInBackground];
    }];
}

@end
