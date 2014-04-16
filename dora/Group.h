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
+ (NSArray *)getAllGroups;
@property (retain) NSString *name;
@property (retain) NSNumber *popularIndex;
@property (retain) NSNumber *totalPosts;
@property (retain) PFGeoPoint *location;

@end
