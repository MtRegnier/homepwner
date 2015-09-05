//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by Dane on 9/5/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRAssetTypeViewController

#pragma mark Initializers
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
#pragma clang diagnostic pop

#pragma mark TableView Setup
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Asset Types";
    }
    
    return @"Assets of Selected Type";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSManagedObject *assetType = self.item.assetType;
    NSSet *items = [assetType valueForKey:@"items"];
    
    if (section == 0) {
        return [[[BNRItemStore sharedStore] allAssetTypes] count];
    } else {
        return [items count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    
    
    
    
    if (indexPath.section == 0) {
        NSManagedObject *assetType = allAssets[indexPath.row];
        // Use KVC to get the label
        NSString *assetLabel = [assetType valueForKey:@"label"];
        cell.textLabel.text = assetLabel;
        
        // Put a checkmark by the one that is currently selected
        if (assetType == self.item.assetType) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        NSManagedObject *assetType = self.item.assetType;
        NSSet *items = [assetType valueForKey:@"items"];
        NSArray *sortedItems = [items sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES]]];
        BNRItem *displayItem = sortedItems[indexPath.row];
        cell.textLabel.text = displayItem.itemName;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    [self.tableView reloadData];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.dismissBlock();
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end















