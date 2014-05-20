//
//  SettingsViewController.m
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingForm.h"
#import "User.h"

@interface SettingsViewController ()

- (void)saveAge:(UITableViewCell<FXFormFieldCell> *)cell;
@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f];
        [_hide1 removeFromSuperview];
        [_hide2 removeFromSuperview];
        [_hide3 removeFromSuperview];
        [_hide4 removeFromSuperview];
        [_hide5 removeFromSuperview];
        [_hide6 removeFromSuperview];
        [_hide7 removeFromSuperview];
        [_hide8 removeFromSuperview];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _formController = [[FXFormController alloc] init];
    _formController.tableView = self.tableView;
    _formController.delegate = self;
    _formController.form = [[SettingForm alloc] init];
    [_notifySwitch setOn:YES animated:YES];
    [_locationSwitch setOn:YES animated:YES];
    _header.font = [UIFont fontWithName:@"ProximaNovaBold" size:16];
    _showLabel.font = [UIFont fontWithName:@"ProximaNovaRegular" size:13];
    _showLabel2.font = [UIFont fontWithName:@"ProximaNovaRegular" size:13];
    _bgA.layer.cornerRadius = 13;
    _bgA.clipsToBounds = YES;
    _bgB.layer.cornerRadius = 13;
    _bgB.clipsToBounds = YES;
    _bgC.layer.cornerRadius = 13;
    _bgC.clipsToBounds = YES;
    
    User *currentUser = [User currentUser];
    if ([currentUser.backgroundImage isEqualToString:@"C"])
        [self onSelectBgC:self.bgC];
    else if ([currentUser.backgroundImage isEqualToString:@"B"])
        [self onSelectBgB:self.bgB];
    else
        [self onSelectBgA:self.bgA];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSelectBgA:(id)sender {
    [sender setSelected:YES];
    [self.bgB setSelected:NO];
    [self.bgC setSelected:NO];
    self.bgA.layer.borderWidth = 5.f;
    self.bgA.layer.borderColor = [[UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:0.5] CGColor];
    self.bgB.layer.borderWidth = 0.f;
    self.bgC.layer.borderWidth = 0.f;
    [User setUserBackground:@"A"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBackground" object:nil];
}

- (IBAction)onSelectBgB:(id)sender {
    [sender setSelected:YES];
    [self.bgA setSelected:NO];
    [self.bgC setSelected:NO];
    self.bgB.layer.borderWidth = 5.f;
    self.bgB.layer.borderColor = [[UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:0.5] CGColor];
    self.bgA.layer.borderWidth = 0.f;
    self.bgC.layer.borderWidth = 0.f;
    [User setUserBackground:@"B"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBackground" object:nil];
}

- (IBAction)onSelectBgC:(id)sender {
    [sender setSelected:YES];
    [self.bgA setSelected:NO];
    [self.bgB setSelected:NO];
    self.bgC.layer.borderWidth = 5.f;
    self.bgC.layer.borderColor = [[UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:0.5] CGColor];
    self.bgA.layer.borderWidth = 0.f;
    self.bgB.layer.borderWidth = 0.f;
    [User setUserBackground:@"C"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBackground" object:nil];
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
}

- (IBAction)triggerNotification:(id)sender {
    NSLog(@"%d", self.notifySwitch.on);
}

- (IBAction)triggerLocation:(id)sender {
    NSLog(@"%d", self.locationSwitch.on);
}

- (void)saveAge:(UITableViewCell<FXFormFieldCell> *)cell
{
    [User setUserAge:cell.field.value];
}

- (void)saveNickname:(UITableViewCell<FXFormFieldCell> *)cell
{
    NSLog(@"%@", cell.field.value);
    [User setUserNickname:cell.field.value];
}

@end
