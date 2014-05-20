//
//  CustomAutocompleteCell.m
//  dora
//
//  Created by Jessica Ko on 4/8/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import QuartzCore;
#import "CustomAutocompleteCell.h"

@implementation CustomAutocompleteCell

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    [self setSelectedBackgroundView:[self orangeSelectedBackgroundView]];
}


- (UIView *)orangeSelectedBackgroundView
{
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = selectedBackgroundView.bounds;
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor],
                        (id)[[UIColor colorWithRed:225/255 green:100/255 blue:0/255 alpha:1.0] CGColor]];
    
    [selectedBackgroundView.layer insertSublayer:gradient atIndex:0];
    
    return selectedBackgroundView;
}


@end
