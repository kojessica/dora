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
- (void)setGroup:(Group*)group;
//- (void)setGroup:(Group*)group firstPost:(NSString *)post1 secondPost:(NSString *)post2;
@end
