//
//  CRViewController.m
//  TestAssetLibrary
//
//  Created by Intern on 1/2/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRViewController.h"

@interface CRViewController ()

@property (nonatomic) BOOL presentedImagePicker;

@end

@implementation CRViewController

@synthesize presentedImagePicker, selectedImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    presentedImagePicker = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    // prevent the image picker from appearing every time the view appears
    if (!presentedImagePicker)
    {
        presentedImagePicker = YES;
        
        [self presentImagePicker];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentImagePicker
{
    CRVPanoramaImagePicker *panoramaImagePicker = [[CRVPanoramaImagePicker alloc] init];
    [panoramaImagePicker setDisablePortraitImages:YES];
    
    [self presentViewController:panoramaImagePicker animated:YES completion:nil];
    
    
    [panoramaImagePicker setGotPanoramaImage:^(UIImage * image) {
        NSLog(@"Got the image: %@", image);
        [selectedImage setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)btnOpenImagePicker:(id)sender {
    [self presentImagePicker];
}
@end
