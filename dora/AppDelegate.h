//
//  AppDelegate.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;

#import "TabsController.h"
#import "TDBWalkthrough.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, TabsControllerDelegate, TDBWalkthroughDelegate>{
}

@property (strong, nonatomic) UIWindow *window;
@end
