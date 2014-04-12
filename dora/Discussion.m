//
//  Discussion.m
//  dora
//
//  Created by Jessica Ko on 4/7/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Discussion.h"
#import "Parse/Parse.h"
@implementation Discussion

- (id)initWithDictionary:(NSMutableDictionary *)data {
    if (self = [super init]) {
        _data = data;
    }
    
    return self;
}

+ (Discussion*) setDiscussion{
    PFObject *discussion = [PFObject objectWithClassName:@"Discussion"];
    discussion[@"company_id"] = nil;
    discussion[@"id"] = nil;
    discussion[@"text"] = nil;
    discussion[@"userid"] = nil;
    discussion[@"likes"] = nil;
    discussion[@"dislikes"] = nil;
    discussion[@"popularity"] = nil;
    
    
    return nil;
}
@end
