//
//  BNRAssetTypeViewController.h
//  Homepwner
//
//  Created by Dane on 9/5/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface BNRAssetTypeViewController : UITableViewController

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) BNRItem *item;

@end
