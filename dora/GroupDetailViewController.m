//
//  GroupDetailViewController.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "ListViewController.h"
#import "ComposeMessageViewController.h"
#import "MBProgressHUD.h"
#import "Post.h"
#import "PostCell.h"
#import "SearchResultsViewController.h"
#import "UserActions.h"
CGFloat widthOffset =30.f;
CGFloat heightOffset = 55.f;

@interface GroupDetailViewController ()

@property (nonatomic,strong) PostCell *previousHighlightedCell;
@property (nonatomic,strong) NSArray *posts;

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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveRemoteNotification:)
     name:UIApplicationDidReceiveRemoteNotification
     object:nil];
    
    UINib *customNib = [UINib nibWithNibName:@"PostCell" bundle:nil];
    [self.postTable registerNib:customNib forCellWithReuseIdentifier:@"PostCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.postTable addSubview:refreshControl];
    
    [self.groupLabel setText:[NSString stringWithFormat: @"@%@", self.group.name]];
    if (self.group.objectId != nil) {
        [Post retrievePostsFromGroup:self.group completion:^(NSArray *objects, NSError *error) {
            [refreshControl endRefreshing];
            self.posts = objects;
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:self.group.name forKey:@"channels"];
            [currentInstallation saveInBackground];
            [self.postTable reloadData];
        }];
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"newPostUploaded"
                                               object:nil];
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
    if (self.group.objectId != nil) {
        [Post retrievePostsFromGroup:self.group completion:^(NSArray *objects, NSError *error) {
            [refreshControl endRefreshing];
            self.posts = objects;
            [self.postTable reloadData];
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
        [hud hide:YES afterDelay:3];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    
    NSLog(@"%d", [self.presentingViewController isKindOfClass:[GroupDetailViewController class]]);
    
    if ([self.presentingViewController isKindOfClass:[SearchResultsViewController class]]) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)showUserActions:(PostCell *)cell {
    
    [self.postTable.collectionViewLayout invalidateLayout];
    
    //if the same cell was reselected
    if ([self.previousHighlightedCell isEqual:cell]) {
        NSLog(@"unselected the same cell");
        [UIView animateWithDuration:0.1f
                              delay:0.0f
             usingSpringWithDamping:1.f
              initialSpringVelocity:40.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGSize currentFrameSize = self.previousHighlightedCell.postView.frame.size;
                             self.previousHighlightedCell.postView.backgroundColor = [UIColor whiteColor];
                             self.previousHighlightedCell.message.textColor = [UIColor blackColor];
                             self.previousHighlightedCell.postView.frame = CGRectMake(10.f, 5.f, currentFrameSize.width - widthOffset, currentFrameSize.height - heightOffset);
                             UserActions *tempActionBar = (UserActions *)[self.previousHighlightedCell viewWithTag:100];
                             if(tempActionBar)
                                 [tempActionBar removeFromSuperview];
                         }
                         completion:nil];
        self.previousHighlightedCell = nil;
    } else {
        if (self.previousHighlightedCell) {
            NSLog(@"unselected the different cell");
            [UIView animateWithDuration:0.1f
                                  delay:0.0f
                 usingSpringWithDamping:1.f
                  initialSpringVelocity:40.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 CGSize currentFrameSize = self.previousHighlightedCell.postView.frame.size;
                                 self.previousHighlightedCell.postView.backgroundColor = [UIColor whiteColor];
                                 self.previousHighlightedCell.message.textColor = [UIColor blackColor];
                                 self.previousHighlightedCell.postView.frame = CGRectMake(10.f, 5.f, currentFrameSize.width - widthOffset, currentFrameSize.height - heightOffset);
                             }
                             completion:nil];
        }
        if (![self.previousHighlightedCell isEqual:cell]) {
            [UIView animateWithDuration:0.5f
                                  delay:0.0f
                 usingSpringWithDamping:0.9f
                  initialSpringVelocity:10.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 CGSize currentFrameSize = cell.postView.frame.size;
                                 cell.postView.frame = CGRectMake(0.f, 0.f, currentFrameSize.width + widthOffset, currentFrameSize.height + heightOffset);
                                 cell.message.frame = CGRectMake(18.f, -6.f, cell.message.frame.size.width + widthOffset, cell.message.frame.size.height + heightOffset);
                                 cell.postView.backgroundColor = [UIColor colorWithRed:58/255 green:58/255 blue:58/255 alpha:1];
                                 cell.message.textColor = [UIColor whiteColor];
                                 
                                 UserActions *actionbar = [[UserActions alloc] initWithFrame:CGRectMake(0.f, currentFrameSize.height + 2, 320.f, 32.f)];
                                 actionbar.tag = 100;
                                 actionbar.delegate = self;
                                 //actionbar.postId = postSelected.objectId;
                                 [cell.postView addSubview:actionbar];
                             }
                             completion:^(BOOL finished) {
                             }];
        }
        self.previousHighlightedCell = cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = (PostCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSelectorOnMainThread:@selector(showUserActions:) withObject:cell waitUntilDone:NO];
}

- (void)didLikePost:(NSString *)postId {
    
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];
    
    [cell cellWithPost:[self.posts objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)didReceiveRemoteNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if (self.isViewLoaded && self.view.window) {
        Post *post = [Post object];
        post.text = [userInfo objectForKey:@"text"];
        post.objectId = [userInfo objectForKey:@"objectId"];
        post.groupId = [userInfo objectForKey:@"groupId"];
        post.userId = [userInfo objectForKey:@"userId"];
        NSMutableArray* posts = [[NSMutableArray alloc] init];
        [posts addObjectsFromArray: self.posts];
        [posts addObject:post];
        self.posts = posts;
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
        
        [self.postTable insertItemsAtIndexPaths:indexArray];
        [self.postTable performBatchUpdates:^{
            [self.postTable reloadData];
        } completion:^(BOOL finished) {}];
    }
}

@end
