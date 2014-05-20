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
@property (nonatomic, weak) IBOutlet UIView *receivedPostView;
@property (nonatomic, weak) IBOutlet UIButton *writeButton;
@property (nonatomic, weak) IBOutlet UIView *topBar;
@property (nonatomic, weak) IBOutlet UIView *mainContentView;
@property (nonatomic, weak) IBOutlet UIButton *subscribeButton;
@property (nonatomic, weak) IBOutlet UILabel *groupLabel;
@property (nonatomic) Group *group;
@property (nonatomic) IBOutlet DoraCollectionView *postTable;
@property (nonatomic) NSString *parentController;
- (IBAction)onBackButton:(id)sender;
- (IBAction)onCompose:(id)sender;
- (IBAction)onSubscribeButton:(id)sender;
- (IBAction)onSwap:(UISwipeGestureRecognizer *)sender;
-(void)showShareController:(Post *)post;
-(void)showFlagController:(Post*)post WithSender:(id)sender;

@end
