//
//  CRViewController.m
//  TestAssetLibrary
//
//  Created by Intern on 1/2/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRViewController.h"

@interface CRViewController ()

@property (nonatomic) BOOL hasPresentedImagePicker; // not needed anymore, since picker doesn't open automatically
@property (strong, nonatomic) CRVPanoramaImagePicker *panoramaImagePicker;

@end

@implementation CRViewController

@synthesize hasPresentedImagePicker, selectedImage, panoramaImagePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasPresentedImagePicker = NO;
    panoramaImagePicker = [[CRVPanoramaImagePicker alloc] init];
    
    [panoramaImagePicker setDisablePortraitImages:YES];
    [panoramaImagePicker setGotPanoramaImage:^(UIImage * image) {
        NSLog(@"Got the image: %@", image);
        [selectedImage setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    // prevent the image picker from appearing every time the view appears
    if (!hasPresentedImagePicker)
    {
        hasPresentedImagePicker = YES;
        
//        [self presentImagePicker];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentImagePicker
{
    [self presentViewController:panoramaImagePicker animated:YES completion:nil];
}

- (IBAction)btnOpenImagePicker:(id)sender {
    [self presentImagePicker];
}
@end
