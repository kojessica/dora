//
//  PopularListViewController.m
//  dora
//
//  Created by Jessica Ko on 4/23/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "PopularListViewController.h"
#import "TabsController.h"
#import "GroupCell.h"
#import "GroupDetailViewController.h"
#import "Group.h"
#import "AFNetworking.h"
#import "Post.h"
#import <QuartzCore/QuartzCore.h>

@interface PopularListViewController ()

@property (strong, nonatomic) NSArray *listGroup;
@property (assign, nonatomic) BOOL detailviewIsPresent;
@property (strong, nonatomic) Post *post1;
@property (strong, nonatomic) Post *post2;

@end

@implementation PopularListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupCell" bundle:nil] forCellReuseIdentifier:@"GroupCell"];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [Group getPopularGroupsWithCompletion:^(NSArray *objects, NSError *error) {
        [refreshControl endRefreshing];
        self.listGroup = objects;
        self.detailviewIsPresent = NO;
        [self.tableView reloadData];
    }];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload:(UIRefreshControl *)refreshControl
{
    [Group getAllGroupsWithCompletion:^(NSArray *objects, NSError *error) {
        [refreshControl endRefreshing];
        self.listGroup = objects;
        self.detailviewIsPresent = NO;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat contentHeight = 0.f;
    NSString *firstPost = [self.listGroup objectAtIndex:indexPath.row][@"firstPost"];
    NSString *secondPost = [self.listGroup objectAtIndex:indexPath.row][@"secondPost"];
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
	return [self.listGroup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"GroupCell";
    
    GroupCell *cell = (GroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setGroup:[self.listGroup objectAtIndex:indexPath.row]];
    
    cell.name.text = [NSString stringWithFormat:(@"#%d %@"), indexPath.row+1, cell.name.text];
    [cell setBackgroundColor:[UIColor clearColor]];
    
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%@, parent is %@", self.title, self.parentViewController);
    
    [self performSelectorOnMainThread:@selector(presentGroupDetailViewAtIndexPath:) withObject:indexPath waitUntilDone:NO];
    
}

- (void)presentGroupDetailViewAtIndexPath:(NSIndexPath *)indexPath {
    Group *groupSelected = [self.listGroup objectAtIndex:indexPath.row];
    
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
