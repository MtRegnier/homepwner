//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Dane on 9/2/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController () <UIScrollViewDelegate>

@property(nonatomic) CGFloat maximumZoomScale;
@property(nonatomic) CGFloat minimumZoomScale;
@property (nonatomic) UIImageView *imageView;

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
    CGRect viewRect = CGRectMake(0, 0, 600, 600);
    UIScrollView *zoomView = [[UIScrollView alloc] initWithFrame:viewRect];
    zoomView.delegate = self;
    zoomView.maximumZoomScale = 2.0;
    zoomView.minimumZoomScale = 0.5;
    
    self.imageView = [[UIImageView alloc] initWithFrame:viewRect];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    zoomView.contentSize = viewRect.size;
    [zoomView addSubview:self.imageView];
    
    self.view = zoomView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Have to cast the view to UIImageView so the compiler knows it can accept setImage:
    
    self.imageView.image = self.image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
    {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) 
    {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    self.imageView.frame = frameToCenter;
}

@end
