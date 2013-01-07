//
//  CRViewController.m
//  TestAssetLibrary
//
//  Created by Intern on 1/2/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRViewController.h"

@interface CRViewController ()

@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    CRVPanoramaImagePicker *panoramaImagePicker = [[CRVPanoramaImagePicker alloc] init];
    [self presentViewController:panoramaImagePicker animated:YES completion:nil];
    
    [panoramaImagePicker setGotPanoramaImage:^(UIImage * image) {
        NSLog(@"Got the image: %@", image);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
