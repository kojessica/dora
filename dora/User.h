//
//  User.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"
#import "Parse/Parse.h"
#import "Parse/PFObject+subclass.h"
@interface User : PFObject <CLLocationManagerDelegate, PFSubclassing>

+ (User *)currentUser;
+ (User *)setCurrentUser;
+ (NSString *)setRandomKey;
+ (void)setUserGroup:(NSString *)groupName;
+ (void)setUserAge:(NSNumber *)age;
+ (void)setUserGender:(NSNumber *)gender;
+ (void)setUserNickname:(NSString *)nickname;
@property (retain) NSString *nickname;
@property (retain) NSString *key;
@property (retain) NSNumber *age;
@property (retain) NSNumber *gender;
@property (retain) NSString *groupName;
@property (retain) PFGeoPoint *location;
@end
