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

@interface BNRItemsViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
//         No longer needed, use new button instead
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

// Table view setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
            if (loopItem.valueInDollars > 50) {
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // Reusing cells instead
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Setting cell text (description)
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    
    // Doing the item split    
    NSMutableArray *workingItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
    NSMutableArray *highValueItems = [[NSMutableArray alloc] init];
    NSMutableArray *lowValueItems = [[NSMutableArray alloc] init];
    if ([workingItems count]) {
        for (int i = 0; i < [workingItems count]; i++) {
            BNRItem *loopItem = workingItems[i];
            if (loopItem.valueInDollars > 50) {
                [highValueItems addObject:loopItem];
            } else {
                [lowValueItems addObject:loopItem];
            }
        }
    }
    // If one section, use the constant row, set label explicitly
    if (tableView.numberOfSections == 1) {
        cell.textLabel.text = @"No more items!";
    } else if (tableView.numberOfSections == 2) {
    // If two sections, use description, then constant label
        if (indexPath.section == 0) {
            item = workingItems[indexPath.row];
            cell.textLabel.text = [item description];
            // Gold Challenge
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        } else {
            cell.textLabel.text = @"No more items!";
        }
    } else if (tableView.numberOfSections == 3) {
    // If three sections, split by value high then low, then constant
        if (indexPath.section == 0) {
            item = highValueItems[indexPath.row];
            cell.textLabel.text = [item description];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        } else if (indexPath.section == 1) {
            item = lowValueItems[indexPath.row];
            cell.textLabel.text = [item description];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        } else {
            cell.textLabel.text = @"No more items!";
        }
    }
    
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
//    NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    
    // Creating a new item instead
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow
                                                inSection:0];
    
    // Adding this row to the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath] 
                          withRowAnimation:UITableViewRowAnimationTop];
    
}

- (IBAction)toggleEditMode:(id)sender
{
    // Checking to see if editing is in progress
    if (self.isEditing) {
        // Change the text of the button to let the user know they are no longer editing
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change title to show user editing has begun
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [self setEditing:YES animated:YES];
    }
}

- (UIView *)headerView
{
    if (!_headerView) {
        // Loading up the XIB
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" 
                                      owner:self 
                                    options:nil];
    }
    return _headerView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check to see if the view wants to commit a delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        //Get rid of the item on the table veiw as well
        [tableView deleteRowsAtIndexPaths:@[indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)tableView:UITableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row 
                                        toIndex:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}


@end
// The following white space is brought to you by Dane's disdain for staring at the bottom of his screen














