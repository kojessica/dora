//
//  GroupDetailViewController.h
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "UserActions.h"
#import "Post.h"
#import "CMPopTipView.h"
#import "DoraCollectionView.h"


@interface GroupDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UserActionsDelegate, CMPopTipViewDelegate, UIScrollViewDelegate>
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

@end
