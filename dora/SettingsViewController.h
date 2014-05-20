//
//  SettingsViewController.h
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;

#import "FXForms.h"

@interface SettingsViewController : UIViewController <FXFormControllerDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISwitch *notifySwitch;
@property (nonatomic) FXFormController *formController;
@property (nonatomic, weak) IBOutlet UISwitch *locationSwitch;
@property (nonatomic, weak) IBOutlet UILabel *header;
@property (nonatomic, weak) IBOutlet UILabel *showLabel;
@property (nonatomic, weak) IBOutlet UILabel *showLabel2;

@property (nonatomic, weak) IBOutlet UILabel *hide1;
@property (nonatomic, weak) IBOutlet UIView *hide2;
@property (nonatomic, weak) IBOutlet UILabel *hide3;
@property (nonatomic, weak) IBOutlet UISwitch *hide4;
@property (nonatomic, weak) IBOutlet UILabel *hide5;
@property (nonatomic, weak) IBOutlet UIView *hide6;
@property (nonatomic, weak) IBOutlet UILabel *hide7;
@property (nonatomic, weak) IBOutlet UISwitch *hide8;
@property (nonatomic, weak) IBOutlet UIButton *bgB;
@property (nonatomic, weak) IBOutlet UIButton *bgA;
@property (nonatomic, weak) IBOutlet UIButton *bgC;
- (IBAction)onSelectBgA:(id)sender;
- (IBAction)onSelectBgB:(id)sender;
- (IBAction)onSelectBgC:(id)sender;

- (IBAction)onBackButton:(id)sender;
- (IBAction)triggerNotification:(id)sender;
- (IBAction)triggerLocation:(id)sender;


@end
