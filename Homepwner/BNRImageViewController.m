//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Dane on 9/2/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Have to cast the view to UIImageView so the compiler knows it can accept setImage:
    UIImageView *imageView = (UIImageView *)self.view;
    
    imageView.image = self.image;
}

@end
