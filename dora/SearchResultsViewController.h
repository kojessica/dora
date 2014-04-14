//
//  SearchResultsViewController.h
//  dora
//
//  Created by Jessica Ko on 4/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@interface SearchResultsViewController : UIViewController <MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *searchInputBox;
@property (strong, nonatomic) NSArray *groupObjects;
@property (assign) BOOL simulateLatency;
@property (assign) BOOL testWithAutoCompleteObjectsInsteadOfStrings;

- (IBAction)onBackButton:(id)sender;

@end
