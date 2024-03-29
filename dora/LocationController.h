//
//  LocationController.h
//  dora
//
//  Created by Benjamin Chang on 4/9/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import Foundation;
@import CoreLocation;

// protocol for sending location updates to another view controller
@protocol LocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation*)location;
@end

@interface LocationController : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager* locationManager;
    CLLocation* location;
    __weak id delegate;
}

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) CLLocation* location;
@property (nonatomic, weak) id  delegate;

+ (LocationController*)sharedLocationController; // Singleton method

@end
