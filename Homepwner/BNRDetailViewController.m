//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Dane on 8/22/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRDateChangeViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@end

@implementation BNRDetailViewController

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self 
                                                                                      action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self 
                                                                                        action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong Initializer" reason:@"Use initForNewItem:" userInfo:nil];
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // Use NSDateFormatter to turn date into string
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey = self.item.itemKey;
    
    // Get the image for the key from the store
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
    
    // Display that image in the imageView
    self.imageView.image = imageToDisplay;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Get rid of first responder
    [self.view endEditing:YES];
    
    // Save changes
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)changeDate:(id)sender {
    
    BNRDateChangeViewController *dateChangeViewController = [[BNRDateChangeViewController alloc] init];
    
    dateChangeViewController.item = self.item;
    
    [self.navigationController pushViewController:dateChangeViewController animated:YES];
    
}
- (IBAction)takePicture:(id)sender {
    
    // Checking to make sure that there isn't a popover still present
    if ([self.imagePickerPopover isPopoverVisible]) {
        // Get rid of it if there is still a popover
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // If there is a camera available, use it, if not grab from library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        CGRect overlayBounds = CGRectMake(87.0, 234.0, 200.0, 200.0);
        UIImageView *crosshairs = [[UIImageView alloc] initWithFrame:overlayBounds];
        crosshairs.image = [UIImage imageNamed:@"Bigger-Small-Crosshairs.png"];
        crosshairs.alpha = 0.5f;
        imagePicker.cameraOverlayView = crosshairs;
        
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.allowsEditing = YES;
    
    imagePicker.delegate = self;
    
    // Commenting out to use Popover on iPad
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // Create a popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        
        // Display the popover, have the sender be the camera bar button item
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Grab the picked image from dictionary
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [self.item setThumbnailFromImage:image];
    
    // Store the image for the key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    
    // Put it on the screen in the image view
    self.imageView.image = image;
    [self.view setNeedsDisplay];
    
    // Take the picker off the screen
    // Updating for popover on iPad
//    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.imagePickerPopover) {
        // Get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)trashImage:(id)sender {
    
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    
    self.imageView.image = nil;
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // If it's an iPad, leave it alone
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // Are we in landscape?
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // If it was cancelled, remove the item from the store
    [[BNRItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

@end
