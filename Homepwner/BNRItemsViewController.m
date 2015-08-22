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
        // No longer needed, use new button instead
//        for (int i = 0; i < 5; i++) {
//            [[BNRItemStore sharedStore] createItem];
//        }
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
#pragma clang diagnostic pop

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

// Table view setup

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Setting up an instance of the cell
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // Reusing cells instead
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Setting cell text (description)
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    return cell;
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














