//
//  Company.m
//  dora
//
//  Created by Jessica Ko on 4/7/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Company.h"
#import "Parse/Parse.h"
@implementation Company

+ (Company*) setCompany{
    PFObject *company = [PFObject objectWithClassName:@"Company"];
    company[@"name"]= nil;
    company[@"id"] = nil;
    company[@"popularity"] = nil;
    company[@"posts"] = nil;
    return nil;
}
@end
