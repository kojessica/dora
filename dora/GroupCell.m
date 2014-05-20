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

- (void)initWithGroup:(Group*)group
{
   
    _name.font = [UIFont fontWithName:@"ProximaNovaBold" size:15];
    _firstPost.font = [UIFont fontWithName:@"ProximaNovaRegular" size:15];
    _secondPost.font = [UIFont fontWithName:@"ProximaNovaRegular" size:15];
    _totalPost.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
    _lastUpdated.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
    
    _name.text = group.name;
    _name.text = [NSString stringWithFormat:(@"@%@"), group.name];
    _totalPost.text = [group.totalPosts stringValue];
    _lastUpdated.text = [Timestamp relativeTimeWithTimestamp:group.updatedAt];
    
    if (group.firstPost) {
        _firstPost.text = [NSString stringWithFormat:(@"\"%@\""), group.firstPost];
    } else {
        _firstPost.text = @"";
    }
    
    if (group.secondPost) {
        _secondPost.text = [NSString stringWithFormat:(@"\"%@\""), group.secondPost];
    } else {
        _secondPost.text = @"";
    }
    
    _topView.layer.cornerRadius = 2;
    _topView.layer.masksToBounds = YES;
    
    _bottomView.layer.cornerRadius = 2;
    _bottomView.layer.masksToBounds = YES;
}

@end
