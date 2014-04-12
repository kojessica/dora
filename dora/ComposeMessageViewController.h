//
//  ComposeMessageViewController.h
//  dora
//
//  Created by Benjamin Chang on 4/11/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Parse/Parse.h"
#import "Group.h"
#import "Post.h"
@interface ComposeMessageViewController : UIViewController
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) User *user;
- (IBAction)didClickSend:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *composedText;

@end
