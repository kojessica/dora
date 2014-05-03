//
//  GroupCell.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupCell.h"
#import "Group.h"
#import "Post.h"
#import "Timestamp.h"

@implementation GroupCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGroup:(Group*)group
{
    
    self.name.font = [UIFont fontWithName:@"ProximaNovaBold" size:15];
    self.firstPost.font = [UIFont fontWithName:@"ProximaNovaRegular" size:15];
    self.secondPost.font = [UIFont fontWithName:@"ProximaNovaRegular" size:15];
    self.totalPost.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
    self.lastUpdated.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
    
    self.name.text = group.name;
    self.name.text = [NSString stringWithFormat:(@"@%@"), group.name];
    self.totalPost.text = [group.totalPosts stringValue];
    self.lastUpdated.text = [Timestamp relativeTimeWithTimestamp:group.updatedAt];
    
    if (group.firstPost) {
        self.firstPost.text = [NSString stringWithFormat:(@"\"%@\""), group.firstPost];
    } else {
        self.firstPost.text = @"";
    }
    
    if (group.secondPost) {
        self.secondPost.text = [NSString stringWithFormat:(@"\"%@\""), group.secondPost];
    } else {
        self.secondPost.text = @"";
    }
    
    self.topView.layer.cornerRadius = 2;
    self.topView.layer.masksToBounds = YES;
    
    self.bottomView.layer.cornerRadius = 2;
    self.bottomView.layer.masksToBounds = YES;
}

@end
