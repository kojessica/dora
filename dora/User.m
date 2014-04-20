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
#import "LocationController.h"

@interface User()

@end

@implementation User
@dynamic key;
@dynamic groupName;
@dynamic age;
@dynamic nickname;
@dynamic gender;
@dynamic location;
//static CLLocationManager *_locationManager;

static User *currentUser = nil;
+ (NSString *)parseClassName {
    return @"Users";
}


+ (User *)currentUser {
    if (currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if(data) {
            User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (user) {
                currentUser = user;
            }
            PFQuery *query = [User query];
            [query whereKey:@"objectId" equalTo:currentUser.objectId];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                currentUser = (User*)object;
            }];
        }
    }
    return currentUser;
}

+ (User *)setCurrentUser {

    currentUser = [User object];
    currentUser.key = [self setRandomKey];
    CLLocation *location = [[LocationController sharedLocationController] locationManager].location;
   
    if(location != nil) {
        CLLocationCoordinate2D coordinate = [location coordinate];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
        currentUser.location = geoPoint;
    }
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        currentUser.objectId = [currentUser objectId];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:currentUser] forKey:@"current_user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
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

+ (void)setUserGroup:(NSString *)groupName {
    currentUser.groupName = groupName;
    [currentUser saveInBackground];
}

+ (void)setUserAge:(NSNumber *)age {
    currentUser.age = age;
    [User persistUser:currentUser];
}

+ (void)setUserGender:(NSNumber *)gender {
    currentUser.gender = gender;
    [User persistUser:currentUser];
}

+ (void)setUserNickname:(NSString *)nickname {
    currentUser.nickname = nickname;
    [User persistUser:currentUser];
}

+ (void)persistUser:(User *)user {
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"current_user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}
@end
