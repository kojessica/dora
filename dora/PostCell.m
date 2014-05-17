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
#import "UserActions.h"
#import <QuartzCore/QuartzCore.h>
#import "FlagViewController.h"
#import "MBProgressHUD.h"

@implementation PostCell
CGFloat cellWidthOffset =30.f;
CGFloat cellHeightOffset = 55.f;
CGFloat cellDefaultWidth = 304.f;
CGFloat cellDefaultHeight = 52.f;
CGFloat cellNewWidth = 334.f;
CGFloat cellNewHeight = 107.f;
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
    self.post = post;
    self.postView.backgroundColor = [UIColor whiteColor];
    if (self.postView.frame.size.width > cellDefaultWidth) {
        self.postView.frame = CGRectMake(8.f, 8.f, self.postView.frame.size.width - cellWidthOffset, self.postView.frame.size.height - cellHeightOffset);
    }
    NSLog(@"postViewframe in a normal cell = %@\n", NSStringFromCGRect(self.postView.frame));
    
    self.message.textColor = [UIColor blackColor];

    User *currentUser = [User currentUser];
    NSLog(@"%@", currentUser);
    self.message.font = [UIFont fontWithName:@"ProximaNovaRegular" size:14];
    self.age.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
    self.gender.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
    self.posted.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
    
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
    
    self.postView.layer.cornerRadius = 2;
    self.postView.layer.masksToBounds = YES;
    UserActions *tempActionBar = (UserActions *)[self viewWithTag:100];
    if(tempActionBar)
        [tempActionBar removeFromSuperview];

        return self;
}

-(void)unselectCell {
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGSize currentFrameSize = self.postView.frame.size;
                         self.postView.backgroundColor = [UIColor whiteColor];
                         self.message.textColor = [UIColor blackColor];
                         
                         if (self.postView.frame.size.width > cellDefaultWidth) {
                             self.postView.frame = CGRectMake(8.f, 8.f, currentFrameSize.width - cellWidthOffset, currentFrameSize.height - cellHeightOffset);
                         }
                         UserActions *tempActionBar = (UserActions *)[self viewWithTag:100];
                         if(tempActionBar)
                             [tempActionBar removeFromSuperview];
                     }
                     completion:nil];

}
-(void)selectCell:(NSInteger)row {
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                        
                         CGSize currentFrameSize = self.postView.frame.size;
                         self.postView.frame = CGRectMake(0.f, 0.f, currentFrameSize.width + cellWidthOffset, currentFrameSize.height + cellHeightOffset);
                         self.message.frame = CGRectMake(18.f, -6.f, self.message.frame.size.width + cellWidthOffset, self.message.frame.size.height + cellHeightOffset);
                         self.postView.backgroundColor = [UIColor colorWithRed:38/255 green:38/255 blue:38/255 alpha:0.8];
                         self.message.textColor = [UIColor whiteColor];
                         
                         UserActions *actionbar = [[UserActions alloc] initWithFrame:CGRectMake(0.f, currentFrameSize.height + 2, 320.f, 32.f)];
                         actionbar.tag = 100;
                         actionbar.delegate = self;
                         actionbar.likeCount.text = [self.post.likes stringValue];
                         actionbar.post = self.post;
                         actionbar.rowNum  = row;
                         
                         //check if this was liked before
                         User *currentUser = [User currentUser];
                         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", self.post.objectId];
                         NSArray *results = [currentUser.likedPosts filteredArrayUsingPredicate:predicate];
                         if ([results count] > 0) {
                             [actionbar.likeButton setImage:[UIImage imageNamed:@"heart_selected_icon.png"] forState:UIControlStateSelected];
                             [actionbar.likeButton setSelected:YES];
                         }
                         
                         NSArray *results_flag = [currentUser.flaggedPosts filteredArrayUsingPredicate:predicate];
                         if ([results_flag count] > 0) {
                             [actionbar.flagButton setImage:[UIImage imageNamed:@"flag_on_icon.png"] forState:UIControlStateSelected];
                             [actionbar.flagButton setSelected:YES];
                         }
                         
                         [self.postView addSubview:actionbar];
                     }
                     completion:^(BOOL finished) {
                     }];

}
- (void)didLikePost:(Post*)post {
    float incremented = [post.likes integerValue] + 1;
    post.likes = [NSNumber numberWithInt:incremented];
}

- (void)didUnlikePost:(Post*)post {
    float decremented = [post.likes integerValue] - 1;
    post.likes = [NSNumber numberWithInt:decremented];
}

-(void)flagThisPost:(Post*)post WithSender:(id)sender {
    [self.delegate showFlagController:post WithSender:sender];
}

- (void)shareThisPost:(Post *)post {
    [self.delegate showShareController:post];
}
@end
