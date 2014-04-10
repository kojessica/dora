//
//  CustomAutocompleteObject.m
//  dora
//
//  Created by Jessica Ko on 4/8/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "CustomAutocompleteObject.h"

@interface CustomAutocompleteObject ()
@property (strong) NSString *countryName;
@end

@implementation CustomAutocompleteObject

- (id)initWithCountry:(NSString *)name
{
    self = [super init];
    if (self) {
        [self setCountryName:name];
    }
    return self;
}

#pragma mark - MLPAutoCompletionObject Protocl

- (NSString *)autocompleteString
{
    return self.countryName;
}

@end
