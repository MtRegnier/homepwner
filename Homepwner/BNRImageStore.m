//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Dane on 8/23/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRImageStore.h"
#import <UIKit/UIKit.h>

@interface BNRImageStore ()

@property (nonatomic, strong)NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
    // Time to get thread safe!
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
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
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self 
               selector:@selector(clearCache:) 
                   name:UIApplicationDidReceiveMemoryWarningNotification 
                 object:nil];
    }
    
    return self;
}

- (void)setImage:(id)image forKey:(NSString *)key
{
//    [self.dictionary setObject:image forKey:key];
    // Short hand!
//    self.dictionary[key] = image;
    NSString *imagePath = [self imagePathForKey:key];
    
    // Turn the image into JPEG
    NSData *data = UIImagePNGRepresentation(image);
    
    // Writing it to path
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
//    return [self.dictionary objectForKey:key];
    // Short hand again!
//    return self.dictionary[key];
    // Loading from file system
    // Try finding it in the dictionary
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        // Create a UIImage from the file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    } 
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}
@end

















