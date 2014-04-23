//
//  GroupDetailViewController.h
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "Post.h"

@interface GroupDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (IBAction)onBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (strong, nonatomic) Group *group;
@property (weak, nonatomic) IBOutlet UICollectionView *postTable;
- (IBAction)onCompose:(id)sender;

@end
