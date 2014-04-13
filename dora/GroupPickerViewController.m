//
//  GroupPickerViewController.m
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupPickerViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "CustomAutocompleteCell.h"
#import "CustomAutocompleteObject.h"
#import "ListViewController.h"
#import "TabsController.h"
#import <Parse/Parse.h>
#import "User.h"

@interface GroupPickerViewController ()

- (NSArray *)setAllGroups;
- (void)loadHomeView;
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
    
    self.autocompleteTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.testWithAutoCompleteObjectsInsteadOfStrings = YES;
    [self setAllGroups];
    
    [self.autocompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    [self.autocompleteTextField setBorderStyle:UITextBorderStyleRoundedRect];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (void)loadHomeView
{
    
    ListViewController *listViewController1 = [[ListViewController alloc] init];
    ListViewController *listViewController2 = [[ListViewController alloc] init];
    
    listViewController1.title = @"RELEVANT";
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
            forRowAtIndexPath:(NSIndexPath *)indexPath;
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
    [User setUserGroup:[selectedObject autocompleteString]];
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
