//
//  GroupPickerViewController.m
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupPickerViewController.h"
#import "GroupDetailViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "CustomAutocompleteCell.h"
#import "CustomAutocompleteObject.h"
#import "ListViewController.h"
#import "PopularListViewController.h"
#import "TabsController.h"
#import <Parse/Parse.h>
#import "User.h"

@interface GroupPickerViewController ()

- (NSArray *)setAllGroups;
- (void)loadHomeView;
- (void)createNewGroup:(NSString *)needToCreate;
@property (strong,nonatomic) NSArray *groupsNames;

@end


@implementation GroupPickerViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    _autocompleteTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _autocompleteTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _testWithAutoCompleteObjectsInsteadOfStrings = YES;
    [self setAllGroups];
    
    [_autocompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    [_autocompleteTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_autocompleteTextField setAutoCompleteTableBackgroundColor:[UIColor whiteColor]];
    [_autocompleteTextField setAutoCompleteTableCellTextColor:[UIColor colorWithRed:50/255 green:50/255 blue:50/255 alpha:1]];
    _totally.font = [UIFont fontWithName:@"ProximaNovaBold" size:20.f];
    _anonymous.font = [UIFont fontWithName:@"ProximaNovaRegular" size:20.f];
    [self setBackgroundImage];
    
    //set location of the textfield
    _autocompleteTextField.frame = CGRectMake(self.autocompleteTextField.frame.origin.x, self.view.frame.size.height, self.autocompleteTextField.frame.size.width, self.autocompleteTextField.frame.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"goHome"
                                               object:nil];
}

-(void)setBackgroundImage {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
}

- (void) receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"goHome"])
        [self loadHomeView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //NSLog(@"%@", textField.text);
    
    NSArray* words = [textField.text componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    NSString* searchStringWithNoSpace = [words componentsJoinedByString:@""];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches[cd] %@", searchStringWithNoSpace];
    NSArray *matching = [self.groupsNames filteredArrayUsingPredicate:predicate];
    
    if ([textField.text length] > 0 && [matching count] == 0) {
        words = [textField.text componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
        searchStringWithNoSpace = [words componentsJoinedByString:@""];
        [self createNewGroup:searchStringWithNoSpace];
    } else {
        NSLog(@"matching: %@", [matching objectAtIndex:0]);
        [User setUserGroup:[matching objectAtIndex:0]];
        [User updateRelevantGroupsByName:[matching objectAtIndex:0] WithSubscription:YES];
        [self loadHomeView];
    }
    return YES;
}

- (void)createNewGroup:(NSString *)needToCreate
{
    Group *group = [Group createGroupWithName:needToCreate location:[[LocationController sharedLocationController] locationManager].location];
    
    [Group getGroupWithName:needToCreate completion:^(PFObject *object, NSError *error) {
        GroupDetailViewController *groupDetailView = [[GroupDetailViewController alloc] init];
        group.name = needToCreate;
        groupDetailView.group = group;
        groupDetailView.parentController = @"GroupPicker";
        [self presentViewController:groupDetailView animated:YES completion:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep((unsigned int)seconds);
        }
        
        NSArray *completions;
        if(self.testWithAutoCompleteObjectsInsteadOfStrings){
            completions = [self allGroupObjects];
        } else {
            completions = [self allGroups];
        }
        
        handler(completions);
    });
}

- (NSArray *)allGroupObjects
{
    if(!self.groupObjects){
        NSArray *groupNames = [self allGroups];
        NSMutableArray *mutableGroups = [NSMutableArray new];
        for(NSString *groupName in groupNames){
            CustomAutocompleteObject *group = [[CustomAutocompleteObject alloc] initWithGroup:groupName];
            [mutableGroups addObject:group];
        }
        [self setGroupObjects:[NSArray arrayWithArray:mutableGroups]];
    }
    return self.groupObjects;
}

- (NSArray *)setAllGroups
{
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    [query whereKeyExists:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            for (PFObject *object in objects) {
                [groups addObject:object[@"name"]];
            }
            self.groupsNames = [NSArray arrayWithArray:groups];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return self.groupsNames;
}

- (NSArray *)allGroups
{
    return self.groupsNames;
}

- (void)loadHomeView
{
    ListViewController *listViewController1 = [[ListViewController alloc] init];
    PopularListViewController *listViewController2 = [[PopularListViewController alloc] init];
    
    listViewController1.title = @"FOLLOWING";
    listViewController2.title = @"POPULAR";
    
    NSArray *viewControllers = @[listViewController1, listViewController2];
    TabsController *tabBarController = [[TabsController alloc] init];
    
    //tabBarController.delegate = self;
    tabBarController.viewControllers = viewControllers;
    
    [self.navigationController pushViewController:tabBarController animated:YES];
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    [cell.imageView setImage:[UIImage imageNamed:filename]];
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
    
    NSLog(@"%@", [selectedObject autocompleteString]);
    [User setUserGroup:[selectedObject autocompleteString]];
    [User updateRelevantGroupsByName:selectedString WithSubscription:YES];
    [self loadHomeView];
}

- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, -60);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                     }
                     completion:nil];
}


- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, 60);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                     }
                     completion:nil];
    
    
    [self.autocompleteTextField setAutoCompleteTableViewHidden:NO];
}



@end
