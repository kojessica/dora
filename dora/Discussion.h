//
//  Discussion.h
//  dora
//
//  Created by Jessica Ko on 4/7/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discussion : NSObject
@property (nonatomic, strong) NSMutableDictionary *data;
- (id)initWithDictionary:(NSDictionary *)data;

@property (strong, nonatomic) NSString *companyId;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *userId;
@property (assign, nonatomic) NSInteger *likes;
@property (assign, nonatomic) NSInteger *dislikes;
@property (assign, nonatomic) NSInteger *popularity;
@end
