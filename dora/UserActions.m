//
//  UserActions.m
//  dora
//
//  Created by Jessica Ko on 4/19/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "UserActions.h"
#import "Post.h"

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

/*-(void)didLikePost:(NSString *)postId {
    //[self.delegate sender:self didLikePost:self.postId];
    NSLog(@"%@", self.postId);
}*/

- (IBAction)onLikeButton:(id)sender {
    NSLog(@"asdfasfa");
    [self.delegate didLikePost];
}

@end
