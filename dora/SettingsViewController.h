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
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel2;

@property (weak, nonatomic) IBOutlet UILabel *hide1;
@property (weak, nonatomic) IBOutlet UIView *hide2;
@property (weak, nonatomic) IBOutlet UILabel *hide3;
@property (weak, nonatomic) IBOutlet UISwitch *hide4;
@property (weak, nonatomic) IBOutlet UILabel *hide5;
@property (weak, nonatomic) IBOutlet UIView *hide6;
@property (weak, nonatomic) IBOutlet UILabel *hide7;
@property (weak, nonatomic) IBOutlet UISwitch *hide8;
@property (weak, nonatomic) IBOutlet UIButton *bgB;
@property (weak, nonatomic) IBOutlet UIButton *bgA;
@property (weak, nonatomic) IBOutlet UIButton *bgC;
- (IBAction)onSelectBgA:(id)sender;
- (IBAction)onSelectBgB:(id)sender;
- (IBAction)onSelectBgC:(id)sender;

- (IBAction)onBackButton:(id)sender;
- (IBAction)triggerNotification:(id)sender;
- (IBAction)triggerLocation:(id)sender;


@end
