//
//  CustomAutocompleteObject.m
//  dora
//
//  Created by Jessica Ko on 4/8/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "CustomAutocompleteObject.h"

@interface CustomAutocompleteObject ()
@property (strong) NSString *groupName;
@end

@implementation CustomAutocompleteObject

- (id)initWithGroup:(NSString *)name
{
    self = [super init];
    if (self) {
        [self setGroupName:name];
    }
    return self;
}

#pragma mark - MLPAutoCompletionObject Protocl

- (NSString *)autocompleteString
{
    return self.groupName;
}

@end
