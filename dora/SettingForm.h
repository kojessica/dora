//
//  SettingForm.h
//  dora
//
//  Created by Jessica Ko on 4/18/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

typedef NS_ENUM(NSInteger, Gender)
{
    Unknown = 0,
    Female = 1,
    Male = 2
};

@interface SettingForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) NSUInteger age;

@end
