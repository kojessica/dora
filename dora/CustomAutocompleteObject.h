//
//  CustomAutocompleteObject.h
//  dora
//
//  Created by Jessica Ko on 4/8/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import Foundation;
#import "MLPAutoCompletionObject.h"

@interface CustomAutocompleteObject : NSObject <MLPAutoCompletionObject>

- (id)initWithGroup:(NSString *)name;

@end
