//
//  SettingOptionsViewController.h
//  dora
//
//  Created by Jessica Ko on 4/18/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface SettingOptionsViewController : FXFormViewController

- (IBAction)onBackToSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UILabel *header;

@end
