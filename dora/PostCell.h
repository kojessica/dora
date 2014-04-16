//
//  PostCell.h
//  dora
//
//  Created by Jessica Ko on 4/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UILabel *message;
- (id)cellWithPost:(Post *)post;

@end
