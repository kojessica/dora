//
//  PostCell.m
//  dora
//
//  Created by Jessica Ko on 4/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "PostCell.h"

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
    self.message.text = post.text;
    self.postView.layer.cornerRadius = 1;
    self.postView.layer.masksToBounds = YES;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
