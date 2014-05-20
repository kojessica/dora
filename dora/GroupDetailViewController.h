//
//  GroupDetailViewController.h
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;
#import "Group.h"
#import "UserActions.h"
#import "Post.h"
#import "CMPopTipView.h"
#import "DoraCollectionView.h"
#import "PostCell.h"


@interface GroupDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,  CMPopTipViewDelegate, UIScrollViewDelegate, DoraCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *receivedPostView;

- (IBAction)onBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) IBOutlet DoraCollectionView *postTable;
@property (strong, nonatomic) NSString *parentController;
- (IBAction)onCompose:(id)sender;
- (IBAction)onSubscribeButton:(id)sender;
- (IBAction)onSwap:(UISwipeGestureRecognizer *)sender;
-(void)showShareController:(Post *)post;
-(void)showFlagController:(Post*)post WithSender:(id)sender;

@end
