//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Dane on 8/19/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

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

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex 
                toIndex:(NSUInteger)toIndex;
{
    if (fromIndex == toIndex) {
        return;
    }
    // Pointer for object being moved, for reinsertion
    BNRItem *item = self.privateItems[fromIndex];
    // Take it out of the array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Place item in the new position in the array
    [self.privateItems insertObject:item atIndex:toIndex];
}


@end
