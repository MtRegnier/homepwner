//
//  BNRItem.h
//  RandomItems
//
//  Created by Dane on 8/17/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
// I miss properties
{
    NSString *_itemName;
    NSString *_serialNumber;
    int _valueInDollars;
    NSDate *_dateCreated;
    
}

+ (instancetype)randomItem;

// Designated Initializer
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;
- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;

- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)v;
- (int)valueInDollars;

// Read Only
- (NSDate *)dateCreated;


@end
