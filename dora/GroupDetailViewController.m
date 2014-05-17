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
#import "Parse/PFObject.h"
#import "PopularListViewController.h"
#import "FlagViewController.h"
#import "GroupDetailCollectionViewLayout.h"
CGFloat widthOffset =30.f;
CGFloat heightOffset = 55.f;
CGFloat defaultWidth = 304.f;
CGFloat defaultHeight = 52.f;
CGFloat newWidth = 334.f;
CGFloat newHeight = 107.f;

@interface GroupDetailViewController ()

@property (atomic,strong) __block NSMutableArray *posts;
@property (nonatomic,strong) CMPopTipView *popTipView;
@property (nonatomic,strong) CMPopTipView *receivedPostCounterView;
@property (assign, nonatomic) int selectedRow;
@property (assign, nonatomic) int numberOfNewPosts;
@property (nonatomic, strong) NSNumber* currentlyDisplayedPosts;
@property (nonatomic, strong) NSNumber* numberOfResultsToFetch;
@property (strong, nonatomic) NSIndexPath *previousHighlightedIndexPath;
@property (nonatomic, assign) CGFloat totalViewHeight;
@property (nonatomic, assign) BOOL reachedEnd;
@property (nonatomic, assign) BOOL waitingForReload;
@property (strong, nonatomic) PostCell *currentCell;
@property (assign, nonatomic) int numberOfPosts;
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
    self.totalViewHeight = 0;
    self.numberOfNewPosts = 0;
    self.waitingForReload = NO;
    UINib *customNib = [UINib nibWithNibName:@"PostCell" bundle:nil];
    [self.postTable registerNib:customNib forCellWithReuseIdentifier:@"PostCell"];
    self.numberOfResultsToFetch = [NSNumber numberWithInt:20];
    self.currentlyDisplayedPosts = [NSNumber numberWithInt:0];
    self.postTable.collectionViewLayout = [[GroupDetailCollectionViewLayout alloc] init];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.postTable addSubview:refreshControl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter]
               addObserver:self
               selector:@selector(didReceivePushNotification:)
               name:UIApplicationDidReceiveRemoteNotification
               object:nil];
    self.writeButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:16];
    self.groupLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:16];
    [self.groupLabel setText:[NSString stringWithFormat: @"@%@", self.group.name]];
    if (self.group.objectId != nil) {
        [Post retrieveRecentPostsFromGroup:self.group number:[self numberOfResultsToFetch] skipNumber:[self currentlyDisplayedPosts] completion:^(NSArray *objects, NSError *error) {
            [refreshControl endRefreshing];
            self.currentlyDisplayedPosts = [NSNumber numberWithInt:[self currentlyDisplayedPosts].intValue + (int)[objects count]];
            for(Post* post in objects) {
                CGFloat postHeight = [self cellHeightWithPost:post] + [self cellLayoutHeight];
                self.totalViewHeight += postHeight;
            }
            self.posts = [NSMutableArray arrayWithArray:objects];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:self.group.name forKey:@"channels"];
            [currentInstallation saveInBackground];
            //[self reloadTable];
            [self.postTable reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    [self setBackgroundImage];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"newPostUploaded"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"flagThisPost"
                                               object:nil];
}

-(void)setBackgroundImage {
    User *currentUser = [User currentUser];
    if ([currentUser.backgroundImage isEqualToString:@"A"]) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    } else if ([currentUser.backgroundImage isEqualToString:@"B"]) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgB.png"]];
    } else if ([currentUser.backgroundImage isEqualToString:@"C"]) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgC.png"]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
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
    self.popTipView.textFont = [UIFont fontWithName:@"ProximaNovaBold" size:12];
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

-(void)remove:(int)i {
    [self.postTable performBatchUpdates:^{
        [self.posts removeObjectAtIndex:i];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];
        [self.postTable deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
    }];
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"newPostUploaded"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"Posted @%@", self.group.name];
        hud.margin = 15.f;
        hud.yOffset = 150.f;
        hud.labelFont = [UIFont fontWithName:@"ProximaNovaBold" size:13.f];
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
        NSDictionary *userInfo = [notification userInfo];
        __block Post *post = [userInfo objectForKey:@"post"];
        __block NSString *newkey = [Post setRandomKey];


        
        NSDate* currentDate = [NSDate date];
        post.updatedAt = currentDate;
        post.newKey = newkey;
        [self insertGhostPost:post];
        
        [Post postWithUser:[User currentUser] group:[self group] text:post.text location:nil newKey:newkey completion:^(PFObject *result, NSError *error){
//            NSUInteger count = 0;
//                        for (Post *existingPost in self.posts) {
//                                if([existingPost.newKey isEqualToString:newkey]) {
//                                        break;
//                                    }
//                                count++;
//                            }
//            [self.posts setObject:nil atIndexedSubscript:count];
//                        [self.posts setObject:result atIndexedSubscript:count];
            [self.posts setObject:result atIndexedSubscript:0];
        }];
    } else if ([[notification name] isEqualToString:@"flagThisPost"]) {
        
        Post *flaggedPost = [self.posts objectAtIndex:self.selectedRow];
        [User updateFlaggedPosts:flaggedPost.objectId];
        
        UserActions *tempActionBar = (UserActions *)[self.currentCell viewWithTag:100];
        if(tempActionBar) {
            [tempActionBar.flagButton setImage:[UIImage imageNamed:@"flag_on_icon.png"] forState:UIControlStateSelected];
            [tempActionBar.flagButton setSelected:YES];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"%@", @"Thanks for the report!"];
        hud.labelFont = [UIFont fontWithName:@"ProximaNovaBold" size:13.f];
        hud.margin = 15.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}


- (void)reloadTable
{
    __block int currentPosition = 0;
    __block int maximumCount = (int)[self.posts count]-1;
    __block void (^animateTable)();
    __block NSTimeInterval duration = .3;
    
    animateTable = ^void() {
        if(currentPosition < maximumCount) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
                NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:currentPosition inSection:0]];
                self.numberOfPosts++;
                [self.postTable insertItemsAtIndexPaths:arrayWithIndexPaths];
                currentPosition++;
                duration = duration * .9;
            } completion:^(BOOL finished) {
                //animateTable();
            }];
        }
        
    };
    animateTable();

}

- (void)insertGhostPost:(Post *)post
{
    if ([self.posts count] > 0) {
        [self.posts insertObject:post atIndex:0];
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        if(self.selectedRow >= 0) {
            self.selectedRow++;
            NSIndexPath *previousIndexPath =  [NSIndexPath indexPathForRow:self.previousHighlightedIndexPath.row+1 inSection:0];
            self.previousHighlightedIndexPath = previousIndexPath;
        }
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];

        [self.postTable insertItemsAtIndexPaths:arrayWithIndexPaths];
   
    } else {
        [self.posts insertObject:post atIndex:0];
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.postTable insertItemsAtIndexPaths:arrayWithIndexPaths];
    }
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

- (void)didReceivePushNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if (self.isViewLoaded && self.view.window && ![[userInfo objectForKey:@"userId"] isEqualToString:[[User currentUser] objectId]]) {
        Post *post = [Post object];
        post.text = [userInfo objectForKey:@"text"];
        post.objectId = [userInfo objectForKey:@"objectId"];
        post.groupId = [userInfo objectForKey:@"groupId"];
        post.userId = [userInfo objectForKey:@"userId"];
        [self insertPostIntoTable:post];
    }
  }

- (void)insertPostIntoTable:(Post*)post {
    CGPoint offset = self.postTable.contentOffset;
    NSMutableArray* posts = [self.posts mutableCopy];
    offset.y += [self cellHeightWithPost:post] + [self cellLayoutHeight];
    [posts insertObject:post atIndex:0];
    self.posts = posts;
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
    if(self.selectedRow >= 0) {
        self.selectedRow++;
        NSIndexPath *previousIndexPath =  [NSIndexPath indexPathForRow:self.previousHighlightedIndexPath.row+1 inSection:0];
        self.previousHighlightedIndexPath = previousIndexPath;
    }
    [self.postTable insertItemsAtIndexPaths:indexArray];
    [self.postTable reloadData];
    [UIView animateWithDuration:0.05 animations:^{
        [self.postTable setContentOffset:offset];
    }completion:^(BOOL finished) {
        self.numberOfNewPosts = self.numberOfNewPosts+1;
        if(self.numberOfNewPosts > 1) {
            [self updateNewPostLabel];
        }
        else {
            [self showNewPostLabel];
        }
    }];
    
}

- (void)updateNewPostLabel {
    [self.receivedPostCounterView setNewMessage:[NSString stringWithFormat:@"%i new posts", self.numberOfNewPosts]];
}

- (void)showNewPostLabel {
    self.receivedPostCounterView = [[CMPopTipView alloc] initWithMessage:[NSString stringWithFormat:@"%i new posts", self.numberOfNewPosts]];
    self.receivedPostCounterView.delegate = self;
    self.receivedPostCounterView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:169.0/255.0 blue:188.0/255.0 alpha:1];
    self.receivedPostCounterView.borderWidth = 0;
    self.receivedPostCounterView.textColor = [UIColor whiteColor];
    self.receivedPostCounterView.animation = 0.5;
    self.receivedPostCounterView.has3DStyle = NO;
    self.receivedPostCounterView.hasShadow = NO;
    self.receivedPostCounterView.hasGradientBackground = NO;
    self.receivedPostCounterView.pointerSize = 8.f;
    self.receivedPostCounterView.topMargin = -5.f;
    self.receivedPostCounterView.textFont = [UIFont fontWithName:@"ProximaNovaBold" size:12];
    self.receivedPostCounterView.dismissTapAnywhere = NO;
    self.receivedPostCounterView.pointerSize = 0;
    [self.receivedPostCounterView presentPointingAtView:self.receivedPostView inView:self.receivedPostView animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.numberOfNewPosts > 0) {
        CGFloat currentPosition = [scrollView contentOffset].y;
        CGFloat newPostOffset = 0;
        for (int i = 0; i < self.numberOfNewPosts; i++) {
            CGFloat rowHeight = [self cellHeightWithPost:self.posts[i]] + [self cellLayoutHeight];
            newPostOffset += rowHeight;
            if(newPostOffset-50 >= currentPosition) {
                self.numberOfNewPosts = i;
                [self updateNewPostLabel];
            }
            if(self.numberOfNewPosts == 0) {
                [self.receivedPostCounterView setHidden:YES];
            }
        }
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
//    return self.numberOfPosts;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)showUserActions:(NSArray *)arrayOfThings {
    Post *postSelected = [arrayOfThings objectAtIndex:1];
    NSIndexPath *indexPath = [arrayOfThings objectAtIndex:2];
    UICollectionView *collectionView = [arrayOfThings objectAtIndex:3];
    NSNumber *displayNumber = [arrayOfThings objectAtIndex:4];
    int redisplay = [displayNumber intValue];
    [self.postTable.collectionViewLayout invalidateLayout];
    NSLog(@"%@", self.previousHighlightedIndexPath);
    //if the same cell was reselected
    if(redisplay == 1) {
        PostCell *currentCell = (PostCell *)[arrayOfThings objectAtIndex:0];
        [currentCell selectCell:indexPath.row];
        self.selectedRow = (int)indexPath.row;

    }
    else if ((self.selectedRow == indexPath.row) && (self.previousHighlightedIndexPath != nil)) {
        NSLog(@"unselected the same cell");
        PostCell *prevCell = (PostCell *)[collectionView cellForItemAtIndexPath:self.previousHighlightedIndexPath];
        [prevCell unselectCell];
        self.selectedRow = -1;
        self.previousHighlightedIndexPath = nil;
    } else {
        if (self.previousHighlightedIndexPath != nil) {
            PostCell *prevCell = (PostCell *)[collectionView cellForItemAtIndexPath:self.previousHighlightedIndexPath];
            NSLog(@"unselected the different cell");
            [prevCell unselectCell];
            self.selectedRow = -1;
            self.previousHighlightedIndexPath = nil;
        }
        if (![self.previousHighlightedIndexPath isEqual:indexPath]) {
            self.currentCell = (PostCell *)[collectionView cellForItemAtIndexPath:indexPath];
                       
            self.selectedRow = (int)indexPath.row;
            [self.currentCell selectCell:indexPath.row];
        }
        self.previousHighlightedIndexPath = indexPath;
    }
}


-(void)doAnim:(PostCell*)cell {
    cell.postView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    cell.postView.alpha = 1;
    [UIView commitAnimations];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat contentOffsetWhenFullyScrolledDown = (self.totalViewHeight - scrollView.bounds.size.height) * .90f;
    if (scrollView.contentOffset.y >= contentOffsetWhenFullyScrolledDown && !self.reachedEnd && !self.waitingForReload) {
        self.waitingForReload = YES;
        
        [Post retrieveRecentPostsFromGroup:self.group number:[self numberOfResultsToFetch] skipNumber:[self currentlyDisplayedPosts] completion:^(NSArray *objects, NSError *error) {
            if([objects count] < [[self numberOfResultsToFetch] intValue]) {
                self.reachedEnd = YES;
            }
            self.currentlyDisplayedPosts = [NSNumber numberWithInt:[self currentlyDisplayedPosts].intValue + (int)[objects count]];
            NSMutableArray *newArray = [self.posts mutableCopy];
            [newArray addObjectsFromArray:objects];
            self.posts = newArray;
            [self.postTable reloadData];
            self.waitingForReload = NO;
        }];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d", self.selectedRow);
    PostCell *cell = (PostCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Post *postSelected = [self.posts objectAtIndex:indexPath.row];
    
    //Check to see if this is a ghost post
    if (postSelected.objectId == nil) {
        [Post getPostWithNewKey:postSelected.newKey completion:^(PFObject *object, NSError *error) {
            postSelected.objectId = object.objectId;
            NSArray * arrayOfThingsToPass = [NSArray arrayWithObjects: cell, postSelected, indexPath, collectionView, [NSNumber numberWithInt:0], nil];
            [self performSelectorOnMainThread:@selector(showUserActions:) withObject:arrayOfThingsToPass waitUntilDone:NO];
        }];
    } else {
        NSArray * arrayOfThingsToPass = [NSArray arrayWithObjects: cell, postSelected, indexPath, collectionView, [NSNumber numberWithInt:0], nil];
        [self performSelectorOnMainThread:@selector(showUserActions:) withObject:arrayOfThingsToPass waitUntilDone:NO];
    }
}

- (CGFloat)cellHeight:(NSIndexPath *)indexPath
{
    Post *post = [self.posts objectAtIndex:indexPath.row];
    return [self cellHeightWithPost:post];
}

- (CGFloat)cellLayoutHeight {
    return 62;
}

- (CGFloat)cellHeightWithPost:(Post*)post {
    NSString *name = post.text;
    CGSize maximumLabelSize = CGSizeMake(270,9999);
    UIFont *font=[UIFont systemFontOfSize:14];
    CGRect textRect = [name  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return textRect.size.height;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, [self cellHeight:indexPath] + [self cellLayoutHeight]);
}

-(void)showShareController:(Post *)post {
    NSString *shareString = [NSString stringWithFormat:(@"@%@ (From Dora)\n\"%@\""), self.group.name ,post.text];
    UIImage *shareImage = [UIImage imageNamed:@"logo_icon.png"];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)showFlagController:(Post*)post WithSender:(id)sender {
    if (![sender isSelected]) {
        float flagged = [post.flags integerValue] + 1;
        post.flags = [NSNumber numberWithInt:flagged];
        
        FlagViewController *flagView = [[FlagViewController alloc] init];
        flagView.group = self.group;
        flagView.post = post;
        [self presentViewController:flagView animated:YES completion:nil];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"%@", @"Already flagged this post"];
        hud.labelFont = [UIFont fontWithName:@"ProximaNovaBold" size:13.f];
        hud.margin = 15.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];
    [self doAnim:cell];
    [cell cellWithPost:[self.posts objectAtIndex:indexPath.row]];
    cell.delegate = self;
    if(self.selectedRow == indexPath.row) {
        NSArray * arrayOfThingsToPass = [NSArray arrayWithObjects: cell, [self.posts objectAtIndex:indexPath.row], indexPath, collectionView, [NSNumber numberWithInt:1], nil];
        [self performSelectorOnMainThread:@selector(showUserActions:) withObject:arrayOfThingsToPass waitUntilDone:NO];
    }

    return cell;
}

@end
