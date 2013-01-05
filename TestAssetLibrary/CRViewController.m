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
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"hello");
    
    CRFindPanoramaImages *panoramaImageFinder = [[CRFindPanoramaImages alloc] init];
    
    [panoramaImageFinder findPanoramaImagesAndPerformCallback:^(ALAssetRepresentation *panoramaImageRef) {
        NSLog(@"%p", panoramaImageRef);
        
        CGFloat width = [panoramaImageRef dimensions].width;
        
        
        NSLog(@"%f", width);
    }];

    
}

- (void)presentPanoramasWithGroup:(ALAssetsGroup *) groupOfPanoramas
{
    NSLog(@"hai");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
