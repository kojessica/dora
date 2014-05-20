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

@property (strong,nonatomic) NSArray *groupObjs;
@property (strong,nonatomic) NSArray *suggestedGroups;
@property (nonatomic,assign) BOOL hasResults;
@property (nonatomic,strong) NSString *needToCreate;
- (void)reloadResults;
- (void)createNewGroup;
- (void)fetchAutoComplete:(NSString *)searchString;

@end

@implementation SearchResultsViewController

static unsigned int maximumNumCharacters = 20;

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
    _hasResults = YES;
    
    UINib* myCellNib = [UINib nibWithNibName:@"CustomSearchCell" bundle:nil];
    [self.resultsTable registerNib:myCellNib forCellReuseIdentifier:@"CustomSearchCell"];
    
    [self reloadResults];
    [self allGroups];
    
    self.resultsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.searchInputBox becomeFirstResponder];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.searchInputBox.leftView = paddingView;
    self.searchInputBox.leftViewMode = UITextFieldViewModeAlways;
    self.searchInputBox.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.searchInputBox becomeFirstResponder];
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
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [string rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    [self fetchAutoComplete:newString];
    NSLog(@"%@", newString);
    
    if (newString.length + string.length > maximumNumCharacters){
        if (location != NSNotFound){
            [textField resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)fetchAutoComplete:(NSString *)searchString
{
    NSArray* words = [searchString componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    NSString* searchStringWithNoSpace = [words componentsJoinedByString:@""];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", searchStringWithNoSpace];
    self.suggestedGroups = [self.groupObjs filteredArrayUsingPredicate:predicate];
    
    if ([self.suggestedGroups count] == 0) {
        if ([searchString length] > 0) {
            self.hasResults = NO;
            self.needToCreate = searchStringWithNoSpace;
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
    NSMutableArray *groupObjects = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    [query whereKeyExists:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            for (PFObject *object in objects) {
                [groupObjects addObject:object];
            }
            self.groupObjs = [NSArray arrayWithArray:groupObjects];

        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    self.suggestedGroups = self.groupObjects;
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
        return (NSInteger)[self.suggestedGroups count];
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
    if (self.hasResults) {
        [self performSelectorOnMainThread:@selector(presentGroupDetailViewAtIndexPath:) withObject:indexPath waitUntilDone:NO];
    }
    
}

- (void)presentGroupDetailViewAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *groupSelected = [self.suggestedGroups objectAtIndex:(NSUInteger)indexPath.row];
    
    Group *group = [Group object];
    GroupDetailViewController *groupDetailView = [[GroupDetailViewController alloc] init];
    group.objectId = groupSelected.objectId;
    group.name = [groupSelected objectForKey:@"name"];
    groupDetailView.group = group;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
    [self presentViewController:groupDetailView animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hasResults) {
        CustomSearchCell *cell = (CustomSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomSearchCell"];
        cell.name.text = [[self.suggestedGroups objectAtIndex:(NSUInteger)indexPath.row] objectForKey:@"name"];
        cell.totalPost.text = [[[self.suggestedGroups objectAtIndex:(NSUInteger)indexPath.row] objectForKey:@"totalPosts"] stringValue];
        NSLog(@"%@", [self.suggestedGroups objectAtIndex:(NSUInteger)indexPath.row]);
        cell.backgroundColor = [UIColor clearColor];
        cell.name.textColor = [UIColor whiteColor];
        cell.name.font = [UIFont fontWithName:@"ProximaNovaRegular" size:16];
        cell.totalPost.font = [UIFont fontWithName:@"ProximaNovaRegular" size:11];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
        
        UILabel *noResultsText = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, 50.f))];
        [noResultsText setText:[NSString stringWithFormat:@"We can't find %@", self.needToCreate]];
        noResultsText.textColor = [UIColor colorWithRed:146/255.f green:146/255.f blue:146/255.f alpha:1];
        noResultsText.textAlignment = NSTextAlignmentCenter;
        noResultsText.font = [UIFont fontWithName:@"ProximaNovaRegular" size:13];
        
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [createButton setTitle:[NSString stringWithFormat:@"Create @%@", self.needToCreate] forState:UIControlStateNormal];
        createButton.backgroundColor = [UIColor colorWithRed:40/255.f green:169/255.f blue:188/255.f alpha:1];
        [createButton addTarget:self action:@selector(createNewGroup) forControlEvents:UIControlEventTouchUpInside];
        createButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:16];
        
        
        [createButton sizeToFit];
        CGRect frame = createButton.frame;
        frame.size.width += 30;
        frame.size.height += 10;
        frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
        frame.origin.y = 50;
        createButton.frame = frame;
        
        [cell addSubview:noResultsText];
        [cell addSubview:createButton];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
- (void)createNewGroup
{
    [Group createGroupWithName:self.needToCreate location:[[LocationController sharedLocationController] locationManager].location completion:^(PFObject *object, NSError *error){
        
        GroupDetailViewController *groupDetailView = [[GroupDetailViewController alloc] init];
        groupDetailView.group = (Group*)object;
        [self presentViewController:groupDetailView animated:YES completion:nil];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
}


@end
