//
//  SearchResultsViewController.h
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;

@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *searchInputBox;
@property (nonatomic) NSArray *groupObjects;
@property (nonatomic, weak) IBOutlet UITableView *resultsTable;
- (IBAction)onBackButton:(id)sender;

@end
