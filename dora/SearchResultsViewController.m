//
//  SearchResultsViewController.m
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "CustomAutocompleteCell.h"
#import "CustomAutocompleteObject.h"
#import <Parse/Parse.h>

@interface SearchResultsViewController ()

- (NSArray *)setAllGroups;
@property (strong,nonatomic) NSArray *groupsNames;

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
    [self setAllGroups];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotificationInMainVC:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotificationInMainVC:) name:UIKeyboardDidHideNotification object:nil];
    self.searchInputBox.autocorrectionType = UITextAutocorrectionTypeNo;
    self.testWithAutoCompleteObjectsInsteadOfStrings = YES;
    [self.searchInputBox setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    [self.searchInputBox setBorderStyle:UITextBorderStyleNone];
    [self.searchInputBox becomeFirstResponder];
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

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
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
    return self.groupsNames;
}

- (NSArray *)allGroups
{
    return self.groupsNames;
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    
    /*NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    [cell.imageView setImage:[UIImage imageNamed:filename]];*/
    
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
}

- (void)keyboardDidShowWithNotificationInMainVC:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                     }
                     completion:nil];
}


- (void)keyboardDidHideWithNotificationInMainVC:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                     }
                     completion:nil];
    
    
    [self.searchInputBox setAutoCompleteTableViewHidden:NO];
}

@end
