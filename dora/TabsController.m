//
//  TabsController.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "TabsController.h"
#import "SettingsViewController.h"
#import "SearchResultsViewController.h"
#import <Parse/Parse.h>
#import "PopularListViewController.h"
#import "ListViewController.h"

static const NSInteger TagOffset = 1000;
static const float yOffset = 68.f;


@interface TabsController ()

@property (strong,nonatomic) UIView *contentContainerView;
@property (strong,nonatomic) UIView *tabButtonsContainerView;
@property (strong,nonatomic) UIView *indicatorView;
@property (assign,nonatomic) BOOL isPresent;

@end

@implementation TabsController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	CGRect rect = CGRectMake(0.0f, yOffset, self.view.bounds.size.width, self.tabBarHeight);
	self.tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
	[self.view addSubview:self.tabButtonsContainerView];
    
	rect.origin.y = self.tabBarHeight + yOffset;
	rect.size.height = self.view.bounds.size.height - self.tabBarHeight - yOffset;
	self.contentContainerView = [[UIView alloc] initWithFrame:rect];
	self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.contentContainerView];
    
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width / [self.viewControllers count], 5.f)];
    self.indicatorView.layer.backgroundColor =  [[UIColor colorWithRed:82/255.0f green:97/255.0f blue:76/255.0f alpha:1.0f] CGColor];

	[self.view addSubview:self.indicatorView];
    
    self.searchInputBox.delegate = self;
    [self.searchInputBox resignFirstResponder];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 10)];
    self.searchInputBox.leftView = paddingView;
    self.searchInputBox.leftViewMode = UITextFieldViewModeAlways;
    self.searchInputBox.font = [UIFont fontWithName:@"ProximaNovaBold" size:11];
    self.isPresent = YES;
    
    CGRect currentframe = self.settingButton.frame;
    [self.settingButton setFrame: CGRectMake(currentframe.origin.x, currentframe.origin.y, 38, 44)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(receiveNotification:)
                                          name:@"dismissKeyboard"
                                          object:nil];
    [self reloadTabButtons];
}

- (void) receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"dismissKeyboard"])
        [self.searchInputBox resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    SearchResultsViewController *searchResultsView = [[SearchResultsViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
    searchResultsView.transitioningDelegate = self;
    searchResultsView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:searchResultsView animated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];
    
	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:11];
		
        [button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];

		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
		[self deselectTabButton:button];
		[self.tabButtonsContainerView addSubview:button];
        
		++index;
	}
}

- (void)removeTabButtons
{
	while ([self.tabButtonsContainerView.subviews count] > 0)
	{
		[[self.tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];
    
	CGRect rect = CGRectMake(0.0f, 0.0f, floorf(self.view.bounds.size.width / count), self.tabBarHeight);
    
	self.indicatorView.hidden = YES;
    
	NSArray *buttons = [self.tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
			rect.size.width = self.view.bounds.size.width - rect.origin.x;
        
		button.frame = rect;
		rect.origin.x += rect.size.width;
        
		if (index == self.selectedIndex)
			[self centerIndicatorOnButton:button];
        
		++index;
	}
}

- (void)centerIndicatorOnButton:(UIButton *)button
{
	CGRect rect = self.indicatorView.frame;
	rect.origin.x = button.center.x - floorf(self.indicatorView.frame.size.width/2.0f);
	rect.origin.y = self.tabBarHeight - self.indicatorView.frame.size.height + yOffset;
	self.indicatorView.frame = rect;
	self.indicatorView.hidden = NO;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	UIViewController *oldSelectedViewController = self.selectedViewController;
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
    
	_viewControllers = [newViewControllers copy];
    
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;
    
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
    
	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (IBAction)onSettingButton:(id)sender {
    SettingsViewController *settingView = [[SettingsViewController alloc] init];
    settingView.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
    [self.navigationController pushViewController:settingView animated:YES];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
	if ([self.delegate respondsToSelector:@selector(tabsController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate tabsController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}
    
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;
        
		if (_selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
        
		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;
        
		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = self.contentContainerView.bounds;
			[self.contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(tabsController:didSelectViewController:atIndex:)])
				[self.delegate tabsController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = self.contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;
            
			toViewController.view.frame = rect;
			self.tabButtonsContainerView.userInteractionEnabled = NO;
            
			[self transitionFromViewController:fromViewController
                              toViewController:toViewController
                                      duration:0.3f
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^
             {
                 
                 if ([toViewController isKindOfClass:[PopularListViewController class]])
                     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
                 else
                     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
                 
                 CGRect rect = fromViewController.view.frame;
                 if (oldSelectedIndex < newSelectedIndex)
                     rect.origin.x = -rect.size.width;
                 else
                     rect.origin.x = rect.size.width;
                 
                 fromViewController.view.frame = rect;
                 toViewController.view.frame = self.contentContainerView.bounds;
                 [self centerIndicatorOnButton:toButton];
             }
                                    completion:^(BOOL finished)
             {
                 self.tabButtonsContainerView.userInteractionEnabled = YES;
                 
                 if ([self.delegate respondsToSelector:@selector(tabsController:didSelectViewController:atIndex:)])
                     [self.delegate tabsController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
             }];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];
            
			toViewController.view.frame = self.contentContainerView.bounds;
			[self.contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(tabsController:didSelectViewController:atIndex:)])
				[self.delegate tabsController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{
	[self setSelectedIndex:sender.tag - TagOffset animated:YES];
}

#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor colorWithRed:85/255.0f green:93/255.0f blue:82/255.0f alpha:1.0f] forState:UIControlStateNormal];
}

- (CGFloat)tabBarHeight
{
	return 50.0f;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresent = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresent = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
    CGRect currentFrame = CGRectMake(0, 0, sizeOfScreen.width, sizeOfScreen.height);
    
    if (self.isPresent) {
        toViewController.view.frame = containerView.frame;
        [containerView addSubview:toViewController.view];
        toViewController.view.frame = CGRectOffset(currentFrame, 0, 0);

        [UIView animateWithDuration:0.0 animations:^{
            toViewController.view.frame = CGRectOffset(currentFrame, 0, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        fromViewController.view.frame = containerView.frame;
        [containerView addSubview:fromViewController.view];
        fromViewController.view.frame = CGRectOffset(currentFrame, 0, -self.view.frame.size.height);
        
        [UIView animateWithDuration:0.0 animations:^{
            fromViewController.view.frame = CGRectOffset(currentFrame, 0, -self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end

