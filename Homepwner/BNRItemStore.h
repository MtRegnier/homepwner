//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Dane on 8/19/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly)NSArray *allItems;

+ (instancetype)sharedStore;
- (BNRItem *)createItem;

@end
