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
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"
#import "BNRImageViewController.h"
#import "BNRImageStore.h"

@interface BNRItemsViewController () <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation BNRItemsViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
//    if (self) {
////         No longer needed, use new button instead
//        for (int i = 0; i < 5; i++) {
//            [[BNRItemStore sharedStore] createItem];
//        }
//    }
    // Setting up the nav bar
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Homepwner";
    
    // Create a bar button for adding new items
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self 
                                                                         action:@selector(addNewItem:)];
    navItem.rightBarButtonItem = bbi;
    navItem.leftBarButtonItem = self.editButtonItem;
    
    return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
#pragma clang diagnostic pop

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

// Table view setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    NSMutableArray *lowValueItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < [workingItems count]; i++) {
        BNRItem *loopItem = workingItems[i];
        if (loopItem.valueInDollars > 100) {
            [highValueItems addObject:loopItem];
        } else {
            [lowValueItems addObject:loopItem];
        }
    }
    
    int sectionCount = 1;
    
    if (highValueItems.count) {
        sectionCount++;
    }
    if (lowValueItems.count) {
        sectionCount++;
    }
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    NSMutableArray *lowValueItems = [[NSMutableArray alloc] init];
    if ([workingItems count]) {
        for (int i = 0; i < [workingItems count]; i++) {
            BNRItem *loopItem = workingItems[i];
            if (loopItem.valueInDollars > 100) {
                [highValueItems addObject:loopItem];
            } else {
                [lowValueItems addObject:loopItem];
            }
        }
    }
    // Put sectionCount here to make sure the right number of sections were being created
//    int sectionCount = tableView.numberOfSections;
    // If there is only one section, only the constant row is needed
    if (tableView.numberOfSections == 2) {
    
    // If there are two sections, one row for all items (either high or low) and constant row
    
        if (section == 0) {
            return [[[BNRItemStore sharedStore] allItems] count];
        } else {
            return 1;
        }
    } else if (tableView.numberOfSections == 3) {
    
    // If three sections, high value, low value, constant
    
        if (section == 0) {
            return [highValueItems count];
        } else if (section == 1) {
            return [lowValueItems count];
        } else {
            return 1;
        }
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Setting up an instance of the cell
    // Using custom cell instead
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    // Register the nib with the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    // Reusing cells instead
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    BNRItem *item;
    // Setting cell text (description)
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    if ([items count]) {
        item = items[indexPath.row];
    }
    
    
    // Doing the item split    
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    NSMutableArray *lowValueItems = [[NSMutableArray alloc] init];
    if ([workingItems count]) {
        for (int i = 0; i < [workingItems count]; i++) {
            BNRItem *loopItem = workingItems[i];
            if (loopItem.valueInDollars > 100) {
                [highValueItems addObject:loopItem];
            } else {
                [lowValueItems addObject:loopItem];
            }
        }
    }
    // If one section, use the constant row, set label explicitly
    if (tableView.numberOfSections == 1) {
        cell.nameLabel.text = @"No more items!";
        cell.serialNumberLabel.text = @"";
        cell.valueLabel.text = @"";
        cell.thumbnailView.image = nil;
    } else if (tableView.numberOfSections == 2) {
    // If two sections, use description, then constant label
        if (indexPath.section == 0) {
            item = workingItems[indexPath.row];
            cell.nameLabel.text = item.itemName;
            cell.serialNumberLabel.text = item.serialNumber;
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
            cell.thumbnailView.image = item.thumbnail;
            
            // Gold Challenge
//            cell.nameLabel.font = [UIFont systemFontOfSize:20];
        } else {
            cell.nameLabel.text = @"No more items!";
            cell.serialNumberLabel.text = @"";
            cell.valueLabel.text = @"";
            cell.thumbnailView.image = nil;
        }
    } else if (tableView.numberOfSections == 3) {
    // If three sections, split by value high then low, then constant
        if (indexPath.section == 0) {
            item = highValueItems[indexPath.row];
            cell.nameLabel.text = item.itemName;
//            cell.textLabel.font = [UIFont systemFontOfSize:20];
            cell.serialNumberLabel.text = item.serialNumber;
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
            cell.thumbnailView.image = item.thumbnail;
            
        } else if (indexPath.section == 1) {
            item = lowValueItems[indexPath.row];
            cell.nameLabel.text = item.itemName;
//            cell.textLabel.font = [UIFont systemFontOfSize:20];
            cell.serialNumberLabel.text = item.serialNumber;
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
            cell.thumbnailView.image = item.thumbnail;
        } else {
            cell.nameLabel.text = @"No more items!";
            cell.serialNumberLabel.text = @"";
            cell.valueLabel.text = @"";
            cell.thumbnailView.image = nil;
        }
    }
    
    if (!cell.thumbnailView.image) {
        return cell;
    }
    
    __weak BNRItemCell *weakCell = cell;
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item.itemName);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            
            // If no image, no need to display anything
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            
            // Make a rectangle for the frame of the thumbnail relative to the table view
            BNRItemCell *strongCell = weakCell;
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            // Set up a BNRImageViewController
            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect 
                                               inView:self.view 
                             permittedArrowDirections:UIPopoverArrowDirectionAny 
                                             animated:YES];
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.numberOfSections == 1) {
        return 44.0;
    } else if (tableView.numberOfSections == 2) {
        if (indexPath.section == 0) {
            return 60.0;
        } else {
            return 44.0;
        }
    } else if (tableView.numberOfSections == 3) {
        if (indexPath.section == 2) {
            return 44.0;
        } else {
            return 60.0;
        }
    } else {
        return 0.0;
    }
}
  
- (IBAction)addNewItem:(id)sender
{
    // Setting up index path for 0th section, last row
    // Not doing this any more!
    BNRItem *newItem;
    newItem = [[BNRItemStore sharedStore] createItem];
    // Commented out for modal view
    /*
    // Creating a new item instead
    
    NSUInteger sectionPath = 0;
    NSUInteger lastRow = 0;
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    NSMutableArray *lowValueItems = [[NSMutableArray alloc] init];
    if ([workingItems count]) {
        for (int i = 0; i < [workingItems count]; i++) {
            BNRItem *loopItem = workingItems[i];
            if (loopItem.valueInDollars > 100) {
                [highValueItems addObject:loopItem];
                lastRow = [highValueItems indexOfObjectIdenticalTo:loopItem];
                sectionPath = 0;
            } else {
                [lowValueItems addObject:loopItem];
                if (self.tableView.numberOfSections == 3) {
                    sectionPath = 1;
                }
                lastRow = [lowValueItems indexOfObjectIdenticalTo:loopItem];
                if (lastRow > 1) {
                    lastRow -= 1;
                }
            }
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow
                                                inSection:sectionPath];
    
    // Adding this row to the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath] 
                          withRowAnimation:UITableViewRowAnimationTop];
    
     */
    
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check to see if the view wants to commit a delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        //Get rid of the item on the table view as well
        [tableView deleteRowsAtIndexPaths:@[indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)tableView:UITableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row 
                                        toIndex:destinationIndexPath.row];
//    NSLog(@"section: %ld, row:%ld", (long)destinationIndexPath.section, (long)destinationIndexPath.row);
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.numberOfSections == 2) {
        if (indexPath.section == 0) {
            return YES;
        } else {
            return NO;
        }
    } else if (tableView.numberOfSections == 3) {
        if (indexPath.section == 2) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Setting up for modal view on iPad for new items
//    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    NSMutableArray *lowValueItems = [[NSMutableArray alloc] init];
    if ([workingItems count]) {
        for (int i = 0; i < [workingItems count]; i++) {
            BNRItem *loopItem = workingItems[i];
            if (loopItem.valueInDollars > 100) {
                [highValueItems addObject:loopItem];
            } else {
                [lowValueItems addObject:loopItem];
            }
        }
    }
    BNRItem *selectedItem;
    
    if (tableView.numberOfSections == 2) {
         selectedItem = workingItems[indexPath.row];
    } else if (tableView.numberOfSections == 3) {
        if (indexPath.section == 0) {
            selectedItem = highValueItems[indexPath.row];
        } else if (indexPath.section == 1) {
            selectedItem = lowValueItems[indexPath.row];
        }
    }
    detailViewController.item = selectedItem;    
    if (tableView.numberOfSections == 2) {
        if (indexPath.section == 0) {
            // Place on top of navController's stack
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    } else if (tableView.numberOfSections == 3) {
        if (indexPath.section < 2) {
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine if row is selectable based on the NSIndexPath.
    
    if (tableView.numberOfSections == 2) {
        if (indexPath.section == 0) {
            // Place on top of navController's stack
            return indexPath;
        }
    } else if (tableView.numberOfSections == 3) {
        if (indexPath.section < 2) {
            return indexPath;
        }
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
    
    [self.tableView reloadData];
}

@end
// The following white space is brought to you by Dane's disdain for staring at the bottom of his screen














