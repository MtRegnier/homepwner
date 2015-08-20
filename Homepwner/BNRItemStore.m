//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Dane on 8/19/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()

@property (nonatomic)NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];        
    }
    
    return sharedStore;
}

// Keep people away from the wrong initializer with an exception
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" 
                                   reason:@" Use + [BNRItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Secret initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

@end
