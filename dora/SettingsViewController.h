//
//  SettingsViewController.h
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface SettingsViewController : UIViewController <FXFormControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *notifySwitch;
@property (nonatomic, strong) FXFormController *formController;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
- (IBAction)onBackButton:(id)sender;
- (IBAction)triggerNotification:(id)sender;
- (IBAction)triggerLocation:(id)sender;


@end
