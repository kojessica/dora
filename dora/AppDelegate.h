//
//  AppDelegate.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, TabsControllerDelegate>{
    NSString * const UIApplicationDidReceiveRemoteNotification;
    
}

@property (strong, nonatomic) UIWindow *window;
@end
