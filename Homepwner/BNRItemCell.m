//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Dane on 9/1/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
