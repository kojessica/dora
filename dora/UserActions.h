//
//  UserActions.h
//  dora
//
//  Created by Jessica Ko on 4/19/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserActionsDelegate <NSObject>

@optional

-(void)didLikePost;

@end

@interface UserActions : UIView <UserActionsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) id<UserActionsDelegate> delegate;
- (IBAction)onLikeButton:(id)sender;

@end
