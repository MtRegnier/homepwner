//
//  BNRDateChangeViewController.m
//  Homepwner
//
//  Created by Dane on 8/22/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRDateChangeViewController.h"
#import "BNRItem.h"

@interface BNRDateChangeViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *itemDatePicker;

@end

@implementation BNRDateChangeViewController

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BNRItem *item;
    item = self.item;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
//    NSDate *newItemDate = self.itemDatePicker.date;
    [[self item] setDateCreated: self.itemDatePicker.date];
}

@end
