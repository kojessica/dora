//
//  User.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSMutableDictionary *data;
+ (User *)currentUser;
+ (User *)setCurrentUser;
+ (NSDictionary *)currentUserDictionary;
+ (NSString *)setRandomKey;
- (id)initWithDictionary:(NSDictionary *)data;

@end
