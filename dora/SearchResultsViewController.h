//
//  SearchResultsViewController.h
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchInputBox;
@property (strong, nonatomic) NSArray *groupObjects;
@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
- (IBAction)onBackButton:(id)sender;

@end
