//
//  PostCell.h
//  dora
//
//  Created by Jessica Ko on 4/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "UserActions.h"

@protocol DoraCollectionViewDelegate <NSObject>

@optional

-(void)showShareController:(Post *)post;
-(void)showFlagController:(Post*)post WithSender:(id)sender;

@end

@interface PostCell : UICollectionViewCell <UserActionsDelegate>

@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *posted;
@property (assign, nonatomic) BOOL isSelected;
@property (weak, nonatomic) Post *post;
@property (nonatomic, weak) id<DoraCollectionViewDelegate> delegate;
- (id)cellWithPost:(Post *)post;
-(void)unselectCell;
-(void)selectCell:(NSInteger)row;
@end
