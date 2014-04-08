//
//  User.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface User : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary *data;
+ (User *)currentUser;
+ (User *)setCurrentUser;
+ (NSDictionary *)currentUserDictionary;
+ (NSString *)setRandomKey;
+ (CLLocationManager *)locationManager;
- (id)initWithDictionary:(NSDictionary *)data;

@end
