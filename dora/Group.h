//
//  Group.h
//  dora
//
//  Created by Benjamin Chang on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"
#import "Parse/Parse.h"
#import "Parse/PFObject+subclass.h"

@interface Group : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

+ (Group *)createGroupWithName:(NSString*)name location:(CLLocation *) location;
+ (void)getGroupWithName:(NSString*)name completion:(void(^) (PFObject *object, NSError *error))completion;
+ (void)getAllGroupsWithCompletion:(void(^) (NSArray *objects, NSError *error))completion;
@property (retain) NSString *name;
@property (strong,nonatomic) NSString *objectId;
@property (retain) NSNumber *popularIndex;
@property (retain) NSNumber *totalPosts;
@property (strong, nonatomic) NSDate *updatedAt;
@property (retain) PFGeoPoint *location;
@property (strong, nonatomic) NSString *firstPost;
@property (strong, nonatomic) NSString *secondPost;
@end
