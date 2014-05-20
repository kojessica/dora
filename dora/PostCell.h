//
//  PostCell.h
//  dora
//
//  Created by Jessica Ko on 4/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;

#import "Post.h"
#import "UserActions.h"

@protocol DoraCollectionViewDelegate <NSObject>

@optional

-(void)showShareController:(Post *)post;
-(void)showFlagController:(Post*)post WithSender:(id)sender;

@end

@interface PostCell : UICollectionViewCell <UserActionsDelegate>

@property (nonatomic, weak) IBOutlet UIView *postView;
@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UILabel *gender;
@property (nonatomic, weak) IBOutlet UILabel *age;
@property (nonatomic, weak) IBOutlet UILabel *posted;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) Post *post;
@property (nonatomic, weak) id<DoraCollectionViewDelegate> delegate;
- (id)cellWithPost:(Post *)post;
-(void)unselectCell;
-(void)selectCell:(NSInteger)row;
@end
