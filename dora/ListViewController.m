//
//  ListViewController.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import QuartzCore;
#import "ListViewController.h"
#import "TabsController.h"
#import "GroupCell.h"
#import "GroupDetailViewController.h"
#import "Group.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Post.h"

@interface ListViewController ()

@property (nonatomic) NSArray *listGroup;
@property (nonatomic, assign) BOOL detailviewIsPresent;
@property (nonatomic) Post *post1;
@property (nonatomic) Post *post2;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ListViewController
@synthesize refreshControl = _refreshControl;
- (void)viewDidLoad
{
	[super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupCell" bundle:nil] forCellReuseIdentifier:@"GroupCell"];
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    User *currentUser = [User currentUser];
    [Group getAllGroupsByNames:currentUser.subscribedGroups WithCompletion:^(NSArray *objects, NSError *error) {
        [self.refreshControl endRefreshing];
        self.listGroup = objects;
        self.detailviewIsPresent = NO;
        [self.tableView reloadData];
        [self showEmptyState:objects];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    self.view.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"shouldUpdateFollowingGroups"
                                               object:nil];
    
}

- (void) receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"shouldUpdateFollowingGroups"])
        [self reload];
}

- (void)showEmptyState:(NSArray *)objects
{
    UIButton *emptyButtonExists = (UIButton *)[self.view viewWithTag:82];
    
    if ([objects count] > 0) {
        if(emptyButtonExists)
            [emptyButtonExists removeFromSuperview];
    } else {
        if(!emptyButtonExists) {
            UIButton *emptyState = [[UIButton alloc] initWithFrame:CGRectMake(-20, 20, 361.f, 350.f)];
            UIImage *btnImage = [UIImage imageNamed:@"empty_state.png"];
            [emptyState setAlpha:0.7f];
            [emptyState setImage:btnImage forState:UIControlStateNormal];
            emptyState.tag = 82;
            [self.view addSubview:emptyState];
            
        }
    }
}

- (void)reload
{
    User *currentUser = [User currentUser];
    [Group getAllGroupsByNames:currentUser.subscribedGroups WithCompletion:^(NSArray *objects, NSError *error) {
        [self.refreshControl endRefreshing];
        self.listGroup = objects;
        self.detailviewIsPresent = NO;
        [self.tableView reloadData];
        [self showEmptyState:objects];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat contentHeight = 0.f;
    NSString *firstPost = [self.listGroup objectAtIndex:(NSUInteger)indexPath.row][@"firstPost"];
    NSString *secondPost = [self.listGroup objectAtIndex:(NSUInteger)indexPath.row][@"secondPost"];
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    UIFont *font=[UIFont systemFontOfSize:15];
    if (firstPost != nil) {
        CGRect textRect1 = [firstPost boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        contentHeight += textRect1.size.height + 25;
    }
    if (secondPost != nil) {
        CGRect textRect2 = [secondPost boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        contentHeight += textRect2.size.height + 25;
    }
    return contentHeight + 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (NSInteger)[self.listGroup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"GroupCell";
    
    GroupCell *cell = (GroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell initWithGroup:[self.listGroup objectAtIndex:(NSUInteger)indexPath.row]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelectorOnMainThread:@selector(presentGroupDetailViewAtIndexPath:) withObject:indexPath waitUntilDone:NO];
}

- (void)presentGroupDetailViewAtIndexPath:(NSIndexPath *)indexPath {
    Group *groupSelected = [self.listGroup objectAtIndex:(NSUInteger)indexPath.row];
    
    GroupDetailViewController *groupDetailView = [[GroupDetailViewController alloc] init];
    groupDetailView.transitioningDelegate = self;
    groupDetailView.modalPresentationStyle = UIModalPresentationCustom;
    groupDetailView.group = groupSelected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
    [self presentViewController:groupDetailView animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.detailviewIsPresent = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.detailviewIsPresent = YES;
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
    
    if (!self.detailviewIsPresent) {
        toViewController.view.frame = containerView.frame;
        [containerView addSubview:toViewController.view];
        toViewController.view.frame = CGRectOffset(currentFrame, self.view.frame.size.width, 0);
        fromViewController.view.frame = CGRectOffset(currentFrame, 0, 0);
        
        [UIView animateWithDuration:0.3 animations:^{
            toViewController.view.frame = CGRectOffset(currentFrame, 0, 0);
            fromViewController.view.frame = CGRectOffset(currentFrame, -self.view.frame.size.width, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        fromViewController.view.frame = CGRectOffset(currentFrame, 0, 0);
        toViewController.view.frame = CGRectOffset(currentFrame, -self.view.frame.size.width, 0);
        
        [UIView animateWithDuration:0.2 animations:^{
            fromViewController.view.frame = CGRectOffset(currentFrame, self.view.frame.size.width, 0);
            toViewController.view.frame = CGRectOffset(currentFrame, 0, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
