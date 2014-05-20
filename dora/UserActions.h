//
//  UserActions.h
//  dora
//
//  Created by Jessica Ko on 4/19/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;
#import "Post.h"

@protocol UserActionsDelegate <NSObject>

@optional

-(void)didLikePost:(Post*)post;
-(void)didUnlikePost:(Post*)post;
-(void)shareThisPost:(Post *)post;
-(void)flagThisPost:(Post*)post WithSender:(id)sender;

@end

@interface UserActions : UIView <UserActionsDelegate>

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *flagButton;
@property (nonatomic, weak) id<UserActionsDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *likeCount;
@property (nonatomic, weak) IBOutlet UILabel *shareCount;
@property (nonatomic) Post *post;
@property (nonatomic, assign) int rowNum;

- (IBAction)onLikeButton:(id)sender;
- (IBAction)onShareButton:(id)sender;
- (IBAction)onFlagButton:(id)sender;

@end
