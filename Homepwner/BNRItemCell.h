//
//  BNRItemCell.h
//  Homepwner
//
//  Created by Dane on 9/1/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (nonatomic, copy) void (^actionBlock)(void);

@end
