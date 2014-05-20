//
//  User.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import Foundation;
@import CoreLocation;
#import "Parse/Parse.h"
#import "Parse/PFObject+subclass.h"
#import "Group.h"
@interface User : PFObject <CLLocationManagerDelegate, PFSubclassing>

+ (User *)currentUser;
+ (User *)setCurrentUser;
+ (NSString *)setRandomKey;
+ (void)setUserGroup:(NSString *)groupName;
+ (void)setUserAge:(NSNumber *)age;
+ (void)setUserGender:(NSNumber *)gender;
+ (void)persistUser:(User *)user;
+ (void)setUserNickname:(NSString *)nickname;
+ (void)updateFlaggedPosts:(NSString *)postId;
+ (void)updateLikedPosts:(NSString *)postId ByIncrement:(BOOL)increment;
+ (void)setUserBackground:(NSString *)background;
+ (void)updateRelevantGroupsByName:(NSString *)groupName WithSubscription:(BOOL)subscription;
@property (retain) NSString *nickname;
@property (retain) NSString *key;
@property (retain) NSNumber *age;
@property (retain) NSNumber *gender;
@property (retain) NSString *groupName;
@property (strong,nonatomic) NSArray *likedPosts;
@property (strong,nonatomic) NSArray *subscribedGroups;
@property (strong,nonatomic) NSArray *unsubscribedGroups;
@property (strong,nonatomic) NSArray *flaggedPosts;
@property (retain) PFGeoPoint *location;
@property (strong, nonatomic) NSString *backgroundImage;
@end
