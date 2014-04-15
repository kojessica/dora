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
#import "GroupDetailViewController.h"
#import "Group.h"

@interface SearchResultsViewController ()

@property (strong,nonatomic) NSArray *groupsNames;
@property (strong,nonatomic) NSArray *suggestedGroups;
@property (nonatomic,assign) BOOL hasResults;
@property (nonatomic,strong) NSString *needToCreate;
- (void)reloadResults;
- (void)createNewGroup;
- (void)fetchAutoComplete:(NSString *)searchString;

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
    self.hasResults = YES;
    
    UINib* myCellNib = [UINib nibWithNibName:@"CustomSearchCell" bundle:nil];
    [self.resultsTable registerNib:myCellNib forCellReuseIdentifier:@"CustomSearchCell"];
    
    [self reloadResults];
    [self allGroups];
    
    self.resultsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.searchInputBox becomeFirstResponder];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.searchInputBox.leftView = paddingView;
    self.searchInputBox.leftViewMode = UITextFieldViewModeAlways;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"ending");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self fetchAutoComplete:newString];
    NSLog(@"%@", newString);
    return YES;
}

- (void)fetchAutoComplete:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", searchString];
    self.suggestedGroups = [self.groupsNames filteredArrayUsingPredicate:predicate];
    
    if ([self.suggestedGroups count] == 0) {
        if ([searchString length] > 0) {
            self.hasResults = NO;
            self.needToCreate = searchString;
        } else {
            self.hasResults = YES;
        }
    } else {
        self.hasResults = YES;
    }
    NSLog(@"%@", self.suggestedGroups);
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
    self.suggestedGroups = self.groupsNames;
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
    if (self.hasResults) {
        return [self.suggestedGroups count];
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hasResults) {
        return 60;
    } else {
        return 200;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hasResults) {
        CustomSearchCell *cell = (CustomSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomSearchCell"];
        cell.name.text = [self.suggestedGroups objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.name.textColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
        
        UILabel *noResultsText = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, 50.f))];
        [noResultsText setText:[NSString stringWithFormat:@"We can't find %@", self.needToCreate]];
        noResultsText.textColor = [UIColor colorWithRed:146/255.f green:146/255.f blue:146/255.f alpha:1];
        noResultsText.textAlignment = NSTextAlignmentCenter;
        
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        createButton.frame = CGRectMake(70.f, 50.f, 180.f, 40.f);
        [createButton setTitle:[NSString stringWithFormat:@"Create @%@", self.needToCreate] forState:UIControlStateNormal];
        createButton.backgroundColor = [UIColor colorWithRed:40/255.f green:169/255.f blue:188/255.f alpha:1];
        [createButton addTarget:self action:@selector(createNewGroup) forControlEvents:UIControlEventTouchUpInside];
        createButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        [cell addSubview:noResultsText];
        [cell addSubview:createButton];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (void)createNewGroup
{
    //TODO(jessica): create a new group in Parse
    Group *groupToCreate = [[Group alloc] init];
    groupToCreate.name = self.needToCreate;
    GroupDetailViewController *groupDetailView = [[GroupDetailViewController alloc] init];
    groupDetailView.group = groupToCreate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
    [self presentViewController:groupDetailView animated:YES completion:nil];
}


@end
