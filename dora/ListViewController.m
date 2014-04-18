//
//  ListViewController.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "ListViewController.h"
#import "TabsController.h"
#import "GroupCell.h"
#import "GroupDetailViewController.h"
#import "Group.h"
#import "AFNetworking.h"
#import "Post.h"

@interface ListViewController ()

@property (strong, nonatomic) NSArray *listGroup;
@property (assign, nonatomic) BOOL detailviewIsPresent;
@property (strong, nonatomic) Post *post1;
@property (strong, nonatomic) Post *post2;

@end

@implementation ListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupCell" bundle:nil] forCellReuseIdentifier:@"GroupCell"];
    [Group getAllGroupsWithCompletion:^(NSArray *objects, NSError *error) {
        self.listGroup = objects;
        self.detailviewIsPresent = NO;
        [self.tableView reloadData];
    }];

}

#pragma mark - UITableViewDataSource

/*- (CGFloat)cellHeight:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    UIFont *font=[UIFont systemFontOfSize:15];
    
    CGFloat post1Height = 0.f;
    CGFloat post2Height = 0.f;
    
    if (self.post1 != nil) {
        CGRect textRect1 = [self.post1.text  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        post1Height = textRect1.size.height;
    } else {
        post1Height = 0.f;
    }
    
    if (self.post2 != nil) {
        CGRect textRect2 = [self.post2.text  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        post2Height = textRect2.size.height;
    } else {
        post2Height = 0.f;
    }
    
    return post1Height + post2Height;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
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
    
    /*NSNumber *numberOfPosts = [NSNumber numberWithInt:2];
     [Post retrieveRecentPostsFromGroup:[self.listGroup objectAtIndex:indexPath.row] number:numberOfPosts completion:^(NSArray *objects, NSError *error) {
        if ([objects count] > 1) {
            Group *group = [self.listGroup objectAtIndex:indexPath.row];
            group.firstPost = [objects objectAtIndex:0];
            group.secondPost = [objects objectAtIndex:1];
            [cell setGroup: firstPost:self.post1.text secondPost:self.post2.text];
        } else if ([objects count] > 0) {
            self.post1 = [objects objectAtIndex:0];
            self.post2 = nil;
            [cell setGroup:[self.listGroup objectAtIndex:indexPath.row] firstPost:self.post1.text secondPost:nil];
        } else {
            self.post1 = nil;
            self.post2 = nil;
            [cell setGroup:[self.listGroup objectAtIndex:indexPath.row] firstPost:nil secondPost:nil];
        }
        
    }];*/
    
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
