//
//  SettingOptionsViewController.h
//  dora
//
//  Created by Jessica Ko on 4/18/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;
#import "FXForms.h"

@interface SettingOptionsViewController : FXFormViewController

- (IBAction)onBackToSetting:(id)sender;
@property (nonatomic, weak) IBOutlet UILabel *selectLabel;
@property (nonatomic, weak) IBOutlet UILabel *header;

@end
