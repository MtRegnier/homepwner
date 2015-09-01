//
//  BNRItem.h
//  RandomItems
//
//  Created by Dane on 8/17/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic)NSString *itemName;
@property (strong, nonatomic)NSString *serialNumber;
@property (nonatomic)int valueInDollars;
@property (nonatomic, copy)NSString *itemKey;

+ (instancetype)randomItem;

// Designated Initializer
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;
- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;

// Read Only
- (void)setDateCreated:(NSDate *)date;

@end
