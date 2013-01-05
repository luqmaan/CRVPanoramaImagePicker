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
    
    __block NSInteger top = 0;
    
    [panoramaImageFinder findPanoramaImagesAndPerformCallback:^(ALAsset *panoramaImageRef) {
        
        NSLog(@"%p", panoramaImageRef);
        
        /*  The call to get the image out of the defaultRepresentation is very slow.
            Fast: [panoramaImageRef aspectRatioThumbnail]
            Slower: [panoramaImageRef defaultRepresentation] fullScreenImage]
            Slowest: [panoramaImageRef defaultRepresentation] fullResolutionImage]
         */
        UIImage *thumb = [UIImage imageWithCGImage:[[panoramaImageRef defaultRepresentation] fullScreenImage]];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:thumb];
        
        CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width  / 2;
        CGSize dimensions = [[panoramaImageRef defaultRepresentation] dimensions];
        CGFloat aspectRatio = dimensions.height / dimensions.width ;
        CGFloat height = aspectRatio * viewWidth;
        
        NSLog(@"aspectRatio: %f", aspectRatio);
        
        CGRect frame = CGRectMake(0, top, viewWidth, height);
        
        NSLog(@"%@", NSStringFromCGRect(frame));
        
        [imageView setFrame:frame];
        [[self view] addSubview:imageView];
        
        top += height;
        
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
