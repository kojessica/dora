//
//  AppDelegate.m
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import QuartzCore;
#import "AppDelegate.h"
#import "TDBWalkthrough.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Group.h"
#import "Post.h"
#import "GroupPickerViewController.h"
#import "LocationController.h"
#import "ListViewController.h"
#import "PopularListViewController.h"
#import "TabsController.h"
#import "GroupDetailViewcontroller.h"

typedef NS_ENUM(NSInteger, TDBButtonTag) {
    TDBButtonTagGetStarted
};

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Post registerSubclass];
    [Group registerSubclass];
    [User registerSubclass];
    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"8bV5UK3dsmvpzryGKdo1ZEPavEpVfneYmx3Qu8S0"
                  clientKey:@"MylibgnIyThCTzlI9tkU0jDZOGkciX2osY73LKY8"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    LocationController *locationController = [LocationController sharedLocationController];
    [[locationController locationManager] startUpdatingLocation];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert)];
    User *currentUser = [User currentUser];
    [currentUser saveInBackground];
    if ([User currentUser]) {
        ListViewController *listViewController1 = [[ListViewController alloc] init];
        PopularListViewController *listViewController2 = [[PopularListViewController alloc] init];
        
        listViewController1.title = @"FOLLOWING";
        listViewController2.title = @"POPULAR";
        
        NSArray *viewControllers = @[listViewController1, listViewController2];
        TabsController *tabBarController = [[TabsController alloc] init];
        
        tabBarController.delegate = self;
        tabBarController.viewControllers = viewControllers;
        [tabBarController setSelectedViewController:listViewController1 animated:NO];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabBarController];
        nav.navigationBar.hidden = YES;
        
        _window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    } else {
        [User setCurrentUser];
        
        GroupPickerViewController *pickerViewController = [[GroupPickerViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
        self.window.rootViewController = nav;
        nav.navigationBar.hidden = YES;
        
        [self.window makeKeyAndVisible];
        [self showTDBSimpleWhite];
    }

    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"NewPost"
     object:self
     userInfo:userInfo];
}

#pragma mark - TDBWalkthroughDelegate Methods

- (void)didPressButtonWithTag:(NSInteger)tag
{
    switch (tag) {
        case TDBButtonTagGetStarted:
            NSLog(@"Get Started");
            [[TDBWalkthrough sharedInstance] dismiss];
            break;
        default:
            break;
    }
}


#pragma mark - Examples Initialization Methods

- (void)showTDBSimpleWhite
{
    TDBWalkthrough *walkthrough = [TDBWalkthrough sharedInstance];
    
    NSArray *bgImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"walkthrough1.png"],
                       [UIImage imageNamed:@"walkthrough2.png"],
                       [UIImage imageNamed:@"walkthrough3.png"], nil];
    
    walkthrough.images = bgImages;
    walkthrough.className = @"TDBSimpleWhite";
    walkthrough.nibName = @"TDBSimpleWhite";
    walkthrough.delegate = self;
    
    //page control
    UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 518, 120, 30)];
    pc.numberOfPages = 3;
    pc.currentPage = 0;
    pc.pageIndicatorTintColor = [UIColor lightGrayColor];
    pc.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    
    walkthrough.walkthroughViewController.pageControl = pc;
    [walkthrough.walkthroughViewController.view addSubview:walkthrough.walkthroughViewController.pageControl];
    [walkthrough show];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[LocationController sharedLocationController].locationManager stopUpdatingLocation];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LocationController sharedLocationController].locationManager startUpdatingLocation];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
