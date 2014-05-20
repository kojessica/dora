//
//  FlagViewController.h
//  dora
//
//  Created by Jessica Ko on 5/2/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;
#import "Group.h"
#import "Post.h"

@interface FlagViewController : UIViewController

@property (nonatomic) Group *group;
@property (nonatomic) Post *post;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;

- (IBAction)isSpam:(id)sender;
- (IBAction)isBullying:(id)sender;
- (IBAction)isBadContent:(id)sender;
- (IBAction)isOther:(id)sender;

@end
