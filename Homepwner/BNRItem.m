//
//  BNRItem.m
//  RandomItems
//
//  Created by Dane on 8/17/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem 

+ (instancetype)randomItem
{
    // Creating an immutable array of some adjectives
    NSArray *randomAdjectiveList = @[@"Fluffly", @"Rusty", @"Shiny"];
    
    // Getting some rad noun action in here
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // Getting index of a random item in those lists
    // % used for modulo, gives you the remainder
    // No pointers here, I'm an idiot
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex], randomNounList[nounIndex]];
    
    int randomValue = arc4random() % 1000;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    return newItem;
}

- (void)setDateCreated:(NSDate *)date
{
    _dateCreated = date;
}
- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@(%@): Worth %d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}

#pragma mark Designated Initializer for BNRItem
// Designated Initializer for BNRItem!
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    // Getting the superclasses DI
    self = [super init];
    
    // Did that DI work?
    if (self) {
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        // Setting the date created to today
        _dateCreated = [[NSDate alloc] init];
        
        // Creating a unique identifier for each item
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
        
    }
    // Returning the address of our new object
    return self;
}

- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name
                   valueInDollars:0 
                     serialNumber:sNumber];
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
    
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"Destroyed: %@", self);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder  encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder  encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
}

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

@end
