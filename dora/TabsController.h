//
//  TabsController.h
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabsControllerDelegate;

/*
 * A custom tab bar container view controller. It works just like a regular
 * UITabBarController, except the tabs are at the top and look different.
 */
@interface TabsController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id <TabsControllerDelegate> delegate;

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

/*
 * The delegate protocol for MHTabBarController.
 */
@protocol TabsControllerDelegate <NSObject>
@optional
- (BOOL)tabsController:(TabsController *)tabsController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)tabsController:(TabsController *)tabsController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end
