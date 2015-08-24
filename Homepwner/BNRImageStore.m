//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Dane on 8/23/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong)NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [BNRImageStore sharedStore]" 
                                 userInfo:nil];
    return nil;
}

// Secret DI
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setImage:(id)image forKey:(NSString *)key
{
//    [self.dictionary setObject:image forKey:key];
    // Short hand!
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
//    return [self.dictionary objectForKey:key];
    // Short hand again!
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    } 
    [self.dictionary removeObjectForKey:key];
}


@end

















