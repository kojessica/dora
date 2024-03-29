//
//  LocationController.m
//  dora
//
//  Created by Benjamin Chang on 4/9/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "LocationController.h"
static LocationController* sharedCLDelegate = nil;

@implementation LocationController
@synthesize locationManager, location, delegate;

- (id)init
{
    self = [super init];
    if (self != nil) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        [locationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations[0];
}

+ (LocationController *)sharedLocationController
{
    static LocationController *sharedLocationControllerInstance = nil;
    if(sharedLocationControllerInstance) return sharedLocationControllerInstance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedLocationControllerInstance = [[self alloc] init];
    });
    return sharedLocationControllerInstance;
}

- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
    /* ... */
    
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [super allocWithZone:zone];
            return sharedCLDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


@end
