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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[SettingForm alloc] init];
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

- (NSUInteger)numberOfSections {
    return 1;
}

- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section {
    return 3;
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
}

- (void)saveAge:(UITableViewCell<FXFormFieldCell> *)cell
{
    [User setUserAge:cell.field.value];
}

@end
