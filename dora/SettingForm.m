//
//  SettingForm.m
//  dora
//
//  Created by Jessica Ko on 4/18/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "SettingForm.h"
#import "User.h"

@implementation SettingForm

- (NSArray *)fields
{
    User *currentUser = [User currentUser];
    self.gender = [currentUser.gender intValue];
    self.age = [currentUser.age intValue];
    self.nickname = currentUser.nickname;
    
    return @[
             
             @{FXFormFieldKey: @"nickname", 
               @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords),
               FXFormFieldAction: @"saveNickname:"},
             
             
             @{FXFormFieldKey: @"gender", FXFormFieldOptions: @[@"Unknown", @"Female", @"Male"],
               FXFormFieldViewController: @"SettingOptionsViewController"},
             
             
             @{FXFormFieldKey: @"age", FXFormFieldCell: [FXFormStepperCell class],
               FXFormFieldAction: @"saveAge:"},

             ];
}

@end
