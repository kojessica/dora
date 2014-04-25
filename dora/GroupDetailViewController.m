//
//  GroupDetailViewController.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "ListViewController.h"
#import "TabsController.h"
#import "ComposeMessageViewController.h"
#import "MBProgressHUD.h"
#import "Post.h"
#import "PostCell.h"
#import "SearchResultsViewController.h"
#import "UserActions.h"
#import "GroupPickerViewController.h"
#import "PopularListViewController.h"
CGFloat widthOffset =30.f;
CGFloat heightOffset = 55.f;
CGFloat defaultWidth = 304.f;
CGFloat defaultHeight = 52.f;
CGFloat newWidth = 334.f;
CGFloat newHeight = 107.f;

@interface GroupDetailViewController ()

@property (nonatomic,strong) NSMutableArray *posts;
@property (nonatomic,strong) CMPopTipView *popTipView;
@property (assign, nonatomic) int selectedRow;
@property (assign, nonatomic) NSIndexPath *previousHighlightedIndexPath;
- (void)showSubscribeHelper:(NSString *)content;

@end

@implementation GroupDetailViewController
NSString * const UIApplicationDidReceiveRemoteNotification = @"NewPost";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewDidUnload {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationDidReceiveRemoteNotification
     object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.postTable.delegate = self;
    self.postTable.dataSource = self;
    self.previousHighlightedIndexPath = nil;
    self.selectedRow = -1;
    
    UINib *customNib = [UINib nibWithNibName:@"PostCell" bundle:nil];
    [self.postTable registerNib:customNib forCellWithReuseIdentifier:@"PostCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.postTable addSubview:refreshControl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.writeButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:16];
    self.groupLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:16];
    [self.groupLabel setText:[NSString stringWithFormat: @"@%@", self.group.name]];
    if (self.group.objectId != nil) {
        [Post retrievePostsFromGroup:self.group completion:^(NSArray *objects, NSError *error) {
            [refreshControl endRefreshing];
            self.posts = [NSMutableArray arrayWithArray:objects];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:self.group.name forKey:@"channels"];
            [currentInstallation saveInBackground];
            [self.postTable reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        //show appropriate subscribe button according to user status
        User *currentUser = [User currentUser];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", self.group.name];
        NSArray *checkIfUnsubscribed = [currentUser.unsubscribedGroups filteredArrayUsingPredicate:predicate];
        if ([checkIfUnsubscribed count] == 0) {
            NSArray *checkIfSubscribed = [currentUser.subscribedGroups filteredArrayUsingPredicate:predicate];
            if ([checkIfSubscribed count] == 0) {
                [User updateRelevantGroupsByName:self.group.name WithSubscription:YES];
                [self showSubscribeHelper:@"Auto-followed"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldUpdateFollowingGroups" object:nil];
            }
            [self.subscribeButton setImage:[UIImage imageNamed:@"pin_icon.png"] forState:UIControlStateSelected];
            [self.subscribeButton setSelected:YES];
        } else {
            [self.subscribeButton setSelected:NO];
        }
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"newPostUploaded"
                                               object:nil];
}

- (void)showSubscribeHelper:(NSString *)content {
    self.popTipView = [[CMPopTipView alloc] initWithMessage:content];
    self.popTipView.delegate = self;
    self.popTipView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:169.0/255.0 blue:188.0/255.0 alpha:1];
    self.popTipView.borderWidth = 0;
    self.popTipView.textColor = [UIColor whiteColor];
    self.popTipView.animation = 0.5;
    self.popTipView.has3DStyle = NO;
    self.popTipView.hasShadow = NO;
    self.popTipView.hasGradientBackground = NO;
    self.popTipView.pointerSize = 8.f;
    self.popTipView.topMargin = -5.f;
    self.popTipView.textFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    self.popTipView.dismissTapAnywhere = NO;
    [self.popTipView autoDismissAnimated:YES atTimeInterval:2.0];
    [self.popTipView presentPointingAtView:self.subscribeButton inView:self.view animated:YES];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    self.popTipView = nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)reload:(UIRefreshControl *)refreshControl
{
    self.previousHighlightedIndexPath = nil;
    self.selectedRow = -1;
    
    if (self.group.objectId != nil) {
        [Post retrievePostsFromGroup:self.group completion:^(NSArray *objects, NSError *error) {
            [refreshControl endRefreshing];
            self.posts = [NSMutableArray arrayWithArray:objects];
            [self.postTable reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"newPostUploaded"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"Posted @%@", self.group.name];
        hud.margin = 15.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
        NSDictionary *userInfo = [notification userInfo];
        Post *post = [userInfo objectForKey:@"post"];
        NSDate* currentDate = [NSDate date];
        post.updatedAt = currentDate;
        [self insertGhostPost:post];
    }
}

- (void)insertGhostPost:(Post *)post
{
    [self.posts insertObject:post atIndex:0];
    NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
    [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.postTable insertItemsAtIndexPaths:arrayWithIndexPaths];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldUpdateFollowingGroups" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
          
    if ([self.presentingViewController isKindOfClass:[SearchResultsViewController class]]) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if ([self.parentController isEqualToString:@"GroupPicker"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goHome" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
        }];
    }
}

- (IBAction)onCompose:(id)sender {
    ComposeMessageViewController *composeView = [[ComposeMessageViewController alloc] init];
    composeView.group = self.group;
    
    [self presentViewController:composeView animated:YES completion:nil];
}

- (IBAction)onSubscribeButton:(id)sender {
    [self.popTipView dismissAnimated:YES];
    if ([sender isSelected]) {
        [User updateRelevantGroupsByName:self.group.name WithSubscription:NO];
        [sender setImage:[UIImage imageNamed:@"pin_empty_icon.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [self showSubscribeHelper:@"Unfollowing"];
    } else {
        [User updateRelevantGroupsByName:self.group.name WithSubscription:YES];
        [sender setImage:[UIImage imageNamed:@"pin_icon.png"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        [self showSubscribeHelper:@"Following"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldUpdateFollowingGroups" object:nil];
}

- (IBAction)onSwap:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if ([self.presentingViewController isKindOfClass:[SearchResultsViewController class]]) {
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
            }];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//TODO(timlee): some weird scrolling behavior ... try selecting the first cell and scroll down the table!
- (void)showUserActions:(NSArray *)arrayOfThings {
    Post *postSelected = [arrayOfThings objectAtIndex:1];
    NSIndexPath *indexPath = [arrayOfThings objectAtIndex:2];
    UICollectionView *collectionView = [arrayOfThings objectAtIndex:3];
    
    [self.postTable.collectionViewLayout invalidateLayout];
    
    //if the same cell was reselected
    if ((self.selectedRow == indexPath.row) && (self.previousHighlightedIndexPath != nil)) {
        NSLog(@"unselected the same cell");
        PostCell *prevCell = (PostCell *)[collectionView cellForItemAtIndexPath:self.previousHighlightedIndexPath];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.selectedRow = -1;
                             CGSize currentFrameSize = prevCell.postView.frame.size;
                             prevCell.postView.backgroundColor = [UIColor whiteColor];
                             prevCell.message.textColor = [UIColor blackColor];
                             
                             if (prevCell.postView.frame.size.width > defaultWidth) {
                                 prevCell.postView.frame = CGRectMake(10.f, 5.f, currentFrameSize.width - widthOffset, currentFrameSize.height - heightOffset);
                             }
                             
                             UserActions *tempActionBar = (UserActions *)[prevCell viewWithTag:100];
                             if(tempActionBar)
                                 [tempActionBar removeFromSuperview];
                         }
                         completion:nil];
        self.previousHighlightedIndexPath = nil;
    } else {
        if (self.previousHighlightedIndexPath != nil) {
            PostCell *prevCell = (PostCell *)[collectionView cellForItemAtIndexPath:self.previousHighlightedIndexPath];
            NSLog(@"unselected the different cell");
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.selectedRow = -1;
                                 CGSize currentFrameSize = prevCell.postView.frame.size;
                                 prevCell.postView.backgroundColor = [UIColor whiteColor];
                                 prevCell.message.textColor = [UIColor blackColor];
                                 
                                 if (prevCell.postView.frame.size.width > defaultWidth) {
                                     prevCell.postView.frame = CGRectMake(10.f, 5.f, currentFrameSize.width - widthOffset, currentFrameSize.height - heightOffset);
                                 }
                                 UserActions *tempActionBar = (UserActions *)[prevCell viewWithTag:100];
                                 if(tempActionBar)
                                     [tempActionBar removeFromSuperview];
                             }
                             completion:nil];
        }
        if (![self.previousHighlightedIndexPath isEqual:indexPath]) {
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 
                                 PostCell *currentCell = (PostCell *)[collectionView cellForItemAtIndexPath:indexPath];
                                 
                                 self.selectedRow = indexPath.row;
                                 CGSize currentFrameSize = currentCell.postView.frame.size;
                                 currentCell.postView.frame = CGRectMake(0.f, 0.f, currentFrameSize.width + widthOffset, currentFrameSize.height + heightOffset);
                                 currentCell.message.frame = CGRectMake(18.f, -6.f, currentCell.message.frame.size.width + widthOffset, currentCell.message.frame.size.height + heightOffset);
                                 currentCell.postView.backgroundColor = [UIColor colorWithRed:38/255 green:38/255 blue:38/255 alpha:0.8];
                                 currentCell.message.textColor = [UIColor whiteColor];
                                 
                                 UserActions *actionbar = [[UserActions alloc] initWithFrame:CGRectMake(0.f, currentFrameSize.height + 2, 320.f, 32.f)];
                                 actionbar.tag = 100;
                                 actionbar.delegate = self;
                                 actionbar.likeCount.text = [postSelected.likes stringValue];
                                 actionbar.post = postSelected;
                                 actionbar.rowNum  = indexPath.row;
                                 
                                 //check if this was liked before
                                 User *currentUser = [User currentUser];
                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", postSelected.objectId];
                                 NSArray *results = [currentUser.likedPosts filteredArrayUsingPredicate:predicate];
                                 if ([results count] > 0) {
                                     [actionbar.likeButton setImage:[UIImage imageNamed:@"heart_selected_icon.png"] forState:UIControlStateSelected];
                                     [actionbar.likeButton setSelected:YES];
                                 }
                                 
                                 [currentCell.postView addSubview:actionbar];
                             }
                             completion:^(BOOL finished) {
                             }];
        }
        self.previousHighlightedIndexPath = indexPath;
    }
}

- (void)didLikePost:(int)rowNum {
    Post *post = [self.posts objectAtIndex:rowNum];
    float incremented = [post.likes integerValue] + 1;
    post.likes = [NSNumber numberWithInt:incremented];
}

- (void)didUnlikePost:(int)rowNum {
    Post *post = [self.posts objectAtIndex:rowNum];
    float decremented = [post.likes integerValue] - 1;
    post.likes = [NSNumber numberWithInt:decremented];
}

- (void)shareThisPost:(Post *)post {
    NSString *shareString = [NSString stringWithFormat:(@"@%@ (From Dora)\n\"%@\""), self.group.name ,post.text];
    UIImage *shareImage = [UIImage imageNamed:@"logo_icon.png"];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d", self.selectedRow);
    PostCell *cell = (PostCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Post *postSelected = [self.posts objectAtIndex:indexPath.row];
    
    //Check to see if this is a ghost post
    if (postSelected.objectId == nil) {
        [Post getPostWithNewKey:postSelected.newKey completion:^(PFObject *object, NSError *error) {
            postSelected.objectId = object.objectId;
            NSArray * arrayOfThingsToPass = [NSArray arrayWithObjects: cell, postSelected, indexPath, nil];
            [self performSelectorOnMainThread:@selector(showUserActions:) withObject:arrayOfThingsToPass waitUntilDone:NO];
        }];
    } else {
        NSArray * arrayOfThingsToPass = [NSArray arrayWithObjects: cell, postSelected, indexPath, collectionView, nil];
        [self performSelectorOnMainThread:@selector(showUserActions:) withObject:arrayOfThingsToPass waitUntilDone:NO];
    }
}

- (CGFloat)cellHeight:(NSIndexPath *)indexPath
{
    Post *post = [self.posts objectAtIndex:indexPath.row];
    NSString *name = post.text;
    CGSize maximumLabelSize = CGSizeMake(270,9999);
    UIFont *font=[UIFont systemFontOfSize:14];
    CGRect textRect = [name  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return textRect.size.height;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, [self cellHeight:indexPath] + 62);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];
    
    if (self.selectedRow == indexPath.row) {
        UserActions *actionbar = [[UserActions alloc] initWithFrame:CGRectMake(0.f, cell.postView.frame.size.height + 2, 320.f, 32.f)];
        Post *postSelected = [self.posts objectAtIndex:indexPath.row];
        cell.postView.frame = CGRectMake(0.f, 0.f, cell.postView.frame.size.width + widthOffset, cell.postView.frame.size.height + heightOffset);
        cell.postView.backgroundColor = [UIColor colorWithRed:38/255 green:38/255 blue:38/255 alpha:0.8];
        cell.message.textColor = [UIColor whiteColor];
        actionbar.tag = 100;
        actionbar.delegate = self;
        actionbar.likeCount.text = [postSelected.likes stringValue];
        actionbar.post = postSelected;
        actionbar.rowNum  = (int)indexPath.row;
        
        //check if this was liked before
        User *currentUser = [User currentUser];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", postSelected.objectId];
        NSArray *results = [currentUser.likedPosts filteredArrayUsingPredicate:predicate];
        if ([results count] > 0) {
            [actionbar.likeButton setImage:[UIImage imageNamed:@"heart_selected_icon.png"] forState:UIControlStateSelected];
            [actionbar.likeButton setSelected:YES];
        }
        [cell.postView addSubview:actionbar];
        cell.message.text = [[self.posts objectAtIndex:indexPath.row] objectForKey:@"text"];
    } else {
        cell.postView.backgroundColor = [UIColor whiteColor];
        if (cell.postView.frame.size.width > defaultWidth) {
            cell.postView.frame = CGRectMake(10.f, 5.f, cell.postView.frame.size.width - widthOffset, cell.postView.frame.size.height - heightOffset);
        }
        cell.message.textColor = [UIColor blackColor];
        [cell cellWithPost:[self.posts objectAtIndex:indexPath.row]];
        UserActions *tempActionBar = (UserActions *)[cell viewWithTag:100];
        if(tempActionBar)
            [tempActionBar removeFromSuperview];
    }
    return cell;
}

@end
