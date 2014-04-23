//
//  UserActions.h
//  dora
//
//  Created by Jessica Ko on 4/19/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol UserActionsDelegate <NSObject>

@optional

-(void)didLikePost:(int)rowNum;
-(void)didUnlikePost:(int)rowNum;
-(void)shareThisPost:(Post *)post;

@end

@interface UserActions : UIView <UserActionsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) id<UserActionsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *shareCount;
@property (strong, nonatomic) Post *post;
@property (nonatomic, assign) int rowNum;

- (IBAction)onLikeButton:(id)sender;
- (IBAction)onShareButton:(id)sender;

@end
