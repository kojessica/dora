//
//  UserActions.m
//  dora
//
//  Created by Jessica Ko on 4/19/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "UserActions.h"
#import "Post.h"
#import "User.h"

@implementation UserActions

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"UserActions" owner:self options:nil];
        id mainView = [subviewArray objectAtIndex:0];
        [self addSubview:mainView];
        self.likeCount.text = @"";
        self.shareCount.text = @"";
    }
    return self;
}

/*-(void)didLikePost:(NSString *)postId {
    //[self.delegate sender:self didLikePost:self.postId];
    NSLog(@"%@", self.postId);
}*/

- (IBAction)onLikeButton:(id)sender {
    if ([sender isSelected]) {
        [Post unlikePostWithId:self.post.objectId];
        [User updateLikedPosts:self.post.objectId ByIncrement:NO];
        int decremented = [self.post.likes integerValue] - 1;
        self.likeCount.text = [NSString stringWithFormat:(@"%d"), decremented];
        
        [sender setImage:[UIImage imageNamed:@"heart_white_empty.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [self.delegate didUnlikePost:self.rowNum];
    } else {
        [Post likePostWithId:self.post.objectId];
        [User updateLikedPosts:self.post.objectId ByIncrement:YES];
        int incremented = [self.post.likes integerValue] + 1;
        self.likeCount.text = [NSString stringWithFormat:(@"%d"), incremented];
        
        [sender setImage:[UIImage imageNamed:@"heart_selected_icon.png"] forState:UIControlStateSelected];
        
        UIButton *button = (UIButton*)sender;
        CGRect newFrame = CGRectMake(button.frame.origin.x, button.frame.origin.y - 3, button.frame.size.width, button.frame.size.height);
        [button setFrame:newFrame];
        
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             CGRect newFrame = CGRectMake(button.frame.origin.x, button.frame.origin.y + 5, button.frame.size.width, button.frame.size.height);
                             [button setFrame:newFrame];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1f
                                                   delay:0.0f
                                                 options: UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  CGRect newFrame = CGRectMake(button.frame.origin.x, button.frame.origin.y - 2, button.frame.size.width, button.frame.size.height);
                                                  [button setFrame:newFrame];
                                              }
                                              completion:nil];
                         }];
        
        [sender setSelected:YES];
        [self.delegate didLikePost:self.rowNum];
    }
}

@end
