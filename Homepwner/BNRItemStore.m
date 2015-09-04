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
@import CoreData;

@interface BNRItemStore ()

@property (nonatomic)NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)NSManagedObjectModel *model;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];        
//    }
    // Thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
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
        // Pull in the .xcdatamodel
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Setting up the SQLite file location
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType 
                               configuration:nil 
                                         URL:storeURL 
                                     options:nil 
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" 
                                           reason:[error localizedDescription] 
                                         userInfo:nil];
        }
        
        // Create managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)createItem
{
//    BNRItem *item = [BNRItem randomItem];
    // Trying a blank item to see what happens
//    BNRItem *item = [[BNRItem alloc] init];
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", [self.privateItems count], order);
    
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" 
                                                  inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
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
    
    // Figuring out a new orderValue for the moved object
    double lowerBound = 0.0;
    
    // Checking for objects before in the array
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Checking for objects after in the array
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateItems[1] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound)/2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    // Moving to Core Data
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingString:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem" 
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" 
                                                             ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request 
                                                      error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes;
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType" 
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request 
                                                      error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        _allAssetTypes = [result mutableCopy];
    }
    
    // Checking for first run
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" 
                                             inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" 
                                             inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" 
                                             inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    
    return _allAssetTypes;
}

@end
















