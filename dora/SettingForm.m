//
//  SettingForm.m
//  dora
//
//  Created by Jessica Ko on 4/18/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "SettingForm.h"

@implementation SettingForm


- (NSArray *)fields
{
    return @[
             //we want to add another group header here, and modify the auto-capitalization
             
             @{FXFormFieldKey: @"nickname", 
               @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)},
             
             //this is a multiple choice field, so we'll need to provide some options
             //because this is an enum property, the indexes of the options should match enum values
             
             @{FXFormFieldKey: @"gender", FXFormFieldOptions: @[@"Unknown", @"Female", @"Male"],
               FXFormFieldViewController: @"SettingOptionsViewController"},
             
             //we want to use a stepper control for this value, so let's specify that
             
             @{FXFormFieldKey: @"age", FXFormFieldCell: [FXFormStepperCell class],
               FXFormFieldAction: @"saveAge:"},
             ];
}

@end
