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
    self.name.text = group.name;
    self.name.text = [NSString stringWithFormat:(@"@%@"), group.name];
    self.firstPost.text = group.firstPost;
    self.secondPost.text = group.secondPost;
}

@end
