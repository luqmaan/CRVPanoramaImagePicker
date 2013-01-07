//
//  CRViewController.m
//  TestAssetLibrary
//
//  Created by Intern on 1/2/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRViewController.h"

@interface CRViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGSize scrollViewContentSize;

@end

@implementation CRViewController

@synthesize scrollViewContentSize, gotPanoramaImage;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"hello");
    
    CRFindPanoramaImages *panoramaImageFinder = [[CRFindPanoramaImages alloc] init];
    
    scrollViewContentSize = [[UIScreen mainScreen] bounds].size;
        
    __block NSInteger top = 0;
    __block CGFloat viewWidth = scrollViewContentSize.width;
    __block CGRect buttonFrame = CGRectMake(viewWidth - 45, 15,35,35);
    
    [panoramaImageFinder findPanoramaImagesAndPerformCallback:^(ALAsset *panoramaImageRef) {
        
        /*  The call to get the image out of the defaultRepresentation is very slow.
            Fast: [panoramaImageRef aspectRatioThumbnail]
            Slower: [panoramaImageRef defaultRepresentation] fullScreenImage]
            Slowest: [panoramaImageRef defaultRepresentation] fullResolutionImage]
         */
        // create the thumbnail and image view
        UIImage *thumb = [UIImage imageWithCGImage:[[panoramaImageRef defaultRepresentation] fullScreenImage]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:thumb];
        
        // set the dimensions of the thumbnail
        CGSize dimensions = [[panoramaImageRef defaultRepresentation] dimensions];
        CGFloat aspectRatio = dimensions.height / dimensions.width ;
        CGFloat height = aspectRatio * viewWidth;
        CGRect imageFrame = CGRectMake(0, top, viewWidth, height);        
        NSLog(@"%@", NSStringFromCGRect(imageFrame));
        
        // show the thumbnail
        [imageView setFrame:imageFrame];
        [[self view] addSubview:imageView];

        // create the action button
        UIButton *button  = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        buttonFrame.origin = CGPointMake(viewWidth - 45, (top + (height / 2)) - 17.5);
        [button setFrame:buttonFrame];
        [button addTarget:self
                   action:@selector(chooseImage)
         forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handlePanoramaTap:)];

        [imageView setUserInteractionEnabled:YES];
        
        [imageView addGestureRecognizer:tapRecognizer];

        // update the size of the scrollview and the top position of the next image
        top += height;
        scrollViewContentSize.height = top;
        [[self scrollView] setContentSize:scrollViewContentSize];
        
    }];

}
- (void)handlePanoramaTap:(UIGestureRecognizer *)gr
{
    NSLog(@"recognized tap");
    
    UIImageView *imageView = (UIImageView *)[gr view];
    
    UIImage *image = [imageView image];

    if (gotPanoramaImage != NULL)
    {
        gotPanoramaImage(image);
    }
    else
    {
        NSLog(@"Warning: gotPanoramaImage has not been set. No action to perform on the selected image.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)chooseImage
{
    NSLog(@"clicked on button");
}

@end
