//
//  GroupPickerViewController.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@class MLPAutoCompleteTextField;
@interface GroupPickerViewController : UIViewController <UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>

@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;
@property (nonatomic, weak) IBOutlet UILabel *totally;
@property (nonatomic, weak) IBOutlet UILabel *anonymous;

@property (nonatomic) NSArray *groupObjects;

//Set this to true to prevent auto complete terms from returning instantly.
@property (assign) BOOL simulateLatency;

//Set this to true to return an array of autocomplete objects to the autocomplete textfield instead of strings.
//The objects returned respond to the MLPAutoCompletionObject protocol.
@property (assign) BOOL testWithAutoCompleteObjectsInsteadOfStrings;


@end
