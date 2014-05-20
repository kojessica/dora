//
//  GroupCell.h
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@interface GroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *secondPost;
@property (weak, nonatomic) IBOutlet UILabel *firstPost;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *wrapper;
@property (weak, nonatomic) IBOutlet UILabel *totalPost;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdated;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
- (void)initWithGroup:(Group*)group;
@end
