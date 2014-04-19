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
- (void)setGroup:(Group*)group;
@end
