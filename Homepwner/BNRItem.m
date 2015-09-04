//
//  BNRItem.m
//  Homepwner
//
//  Created by Dane on 9/4/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRItem.h"
@import CoreData;

@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic itemKey;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // Make the rectangle for the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Find a scaling ratio to keep the aspect ratio
    float ratio = MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    // Transparent bitmap context with scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    // Make all other drawing clip to the rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width)/2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height)/2.0;
    
    [image drawInRect:projectRect];
    
    // Get the image from the context and save as the thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Clean the context
    UIGraphicsEndImageContext();
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    // Setting up a new NSUUID object and getting it's string rep
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}

@end
