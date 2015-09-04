//
//  BNRItem.h
//  Homepwner
//
//  Created by Dane on 9/4/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSManagedObject;

@interface BNRItem : NSManagedObject

@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, strong) NSString * serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate * dateCreated;
@property (nonatomic, strong) NSString * itemKey;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
