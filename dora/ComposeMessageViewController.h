//
//  ComposeMessageViewController.h
//  dora
//
//  Created by Benjamin Chang on 4/11/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;
#import "User.h"
#import "Parse/Parse.h"
#import "Group.h"
#import "Post.h"
@interface ComposeMessageViewController : UIViewController <UITextViewDelegate>
@property (nonatomic) Group *group;
@property (nonatomic) User *user;
- (IBAction)didClickSend:(id)sender;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, weak) IBOutlet UITextView *composedText;
- (IBAction)onCancelButton:(id)sender;

@end
