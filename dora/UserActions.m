//
//  UserActions.m
//  dora
//
//  Created by Jessica Ko on 4/19/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "UserActions.h"

@implementation UserActions

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"UserActions" owner:self options:nil];
        id mainView = [subviewArray objectAtIndex:0];
        
        [self addSubview:mainView];
    }
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
