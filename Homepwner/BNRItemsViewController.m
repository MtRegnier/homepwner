//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Dane on 8/19/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemsViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
#pragma clang diagnostic pop

// Table view setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < [workingItems count]; i++) {
        BNRItem *loopItem = workingItems[i];
        if (loopItem.valueInDollars > 50) {
            [highValueItems addObject:loopItem];
        }
    }
    
    if (section == 0) {
        return [highValueItems count];
        workingItems = nil;
        highValueItems = nil;
    } else {
        return [[[BNRItemStore sharedStore] allItems] count] - [highValueItems count];
        workingItems = nil;
        highValueItems = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Setting up an instance of the cell
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // Reusing cells instead
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Setting cell text (description)
    // Split into two arrays?
    
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    NSMutableArray *lowValueItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < [workingItems count]; i++) {
        BNRItem *loopItem = workingItems[i];
        if (loopItem.valueInDollars > 50) {
            [highValueItems addObject:loopItem];
        } else {
            [lowValueItems addObject:loopItem];
        }
    }
    BNRItem *item = [[BNRItem alloc] init];
    if (indexPath.section == 0) {
        item = highValueItems[indexPath.row];
    } else if (indexPath.section == 1) {
        item = lowValueItems[indexPath.row];
    }
    
    cell.textLabel.text = [item description];
    
    return cell;
}


@end
