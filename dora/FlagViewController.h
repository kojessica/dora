//
//  FlagViewController.h
//  dora
//
//  Created by Jessica Ko on 5/2/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "Post.h"

@interface FlagViewController : UIViewController

@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;

- (IBAction)isSpam:(id)sender;
- (IBAction)isBullying:(id)sender;
- (IBAction)isBadContent:(id)sender;
- (IBAction)isOther:(id)sender;

@end
