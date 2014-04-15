//
//  SearchResultsViewController.m
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "SearchResultsViewController.h"
#import <Parse/Parse.h>
#import "CustomSearchCell.h"

@interface SearchResultsViewController ()

@property (strong,nonatomic) NSArray *groupsNames;
@property (strong,nonatomic) NSArray *suggestedGroups;
- (void)reloadResults;
- (void)fetchAutoComplete;

@end

@implementation SearchResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resultsTable.delegate = self;
    self.resultsTable.dataSource = self;
    self.searchInputBox.delegate = self;
    
    
    UINib* myCellNib = [UINib nibWithNibName:@"CustomSearchCell" bundle:nil];
    [self.resultsTable registerNib:myCellNib forCellReuseIdentifier:@"CustomSearchCell"];
    
    [self allGroups];
    [self reloadResults];
    
    
    [self.searchInputBox becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"typing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"ending");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@", newString);
    
    [self fetchAutoComplete];
    
    return YES;
}

- (void)fetchAutoComplete
{
    [self reloadResults];
}

- (void)reloadResults
{
    [self.resultsTable reloadData];
}

- (void)allGroups
{
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    [query whereKeyExists:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            for (PFObject *object in objects) {
                [groups addObject:object[@"name"]];
            }
            NSLog(@"%@", groups);
            self.groupsNames = [NSArray arrayWithArray:groups];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomSearchCell *cell = (CustomSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomSearchCell"];
    cell.name.text = @"Test";
    
    return cell;
}


@end
