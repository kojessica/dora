//
//  GroupCell.h
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;
#import "Group.h"

@interface GroupCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *secondPost;
@property (nonatomic, weak) IBOutlet UILabel *firstPost;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *wrapper;
@property (nonatomic, weak) IBOutlet UILabel *totalPost;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdated;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIView *topView;
- (void)initWithGroup:(Group*)group;
@end
