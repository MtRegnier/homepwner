//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Dane on 8/23/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage; // Forward Declared UIImage here to clear warning, but not mentioned in book. 

@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
