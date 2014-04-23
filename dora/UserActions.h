//
//  UserActions.h
//  dora
//
//  Created by Jessica Ko on 4/19/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserActions;

@protocol UserActionsDelegate <NSObject>

@optional

-(void)didLikePost:(NSString *)postId;

@end

@interface UserActions : UIView <UserActionsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) id<UserActionsDelegate> delegate;
@property (strong, nonatomic) NSString *postId;
- (IBAction)onLikeButton:(id)sender;

@end
