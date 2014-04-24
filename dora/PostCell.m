//
//  PostCell.m
//  dora
//
//  Created by Jessica Ko on 4/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "PostCell.h"
#import "User.h"
#import "Timestamp.h"

@implementation PostCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)cellWithPost:(Post *)post
{
    //TODO(jessicako): replace currentUser with getUserInfoById
    User *currentUser = [User currentUser];
    NSLog(@"%@", currentUser);
    self.message.text = post.text;
    self.age.text = [[post age] stringValue];
    self.posted.text = [NSString stringWithFormat:(@"%@"), [Timestamp relativeTimeWithTimestamp:post.updatedAt]];
    
    NSNumber *gender = [post gender];
    if (gender) {
        if ([gender intValue] == 1) {
            self.gender.text = @"M";
        } else if ([gender intValue] == 2) {
            self.gender.text = @"F";
        }
    }
    
    self.postView.layer.cornerRadius = 1;
    self.postView.layer.masksToBounds = YES;
    return self;
}

@end
