//
//  CRVPanoramaImagePicker.m
//  PanoramaImagePicker
//
//  Created by Lolcat on 07/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//
#import "CRVPanoramaImagePicker.h"

@interface CRVPanoramaImagePicker ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGSize scrollViewContentSize;

@end

@implementation CRVPanoramaImagePicker

@synthesize scrollViewContentSize, gotPanoramaImage, disablePortraitImages;

- (id)init
{
    // If no nib is specified, use the default
    self = [super initWithNibName:@"CRVPanoramaImagePicker" bundle:nil];
    if (self) {
        [self customInitialization];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customInitialization];
    }
    return self;
}

- (void)customInitialization
{
    disablePortraitImages = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CRFindPanoramaImages *panoramaImageFinder = [[CRFindPanoramaImages alloc] init];
    
    [panoramaImageFinder setDisablePortraitImages:disablePortraitImages];
    
    scrollViewContentSize = [[UIScreen mainScreen] bounds].size;
    
    __block NSInteger top = 0;
    __block CGFloat viewWidth = scrollViewContentSize.width;
    
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
        
        
        // add the tap action
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanoramaTap:)];
        [imageView addGestureRecognizer:tapRecognizer];
        
        // update the size of the scrollview and the top position of the next image
        top += height;
        scrollViewContentSize.height = top;
        [[self scrollView] setContentSize:scrollViewContentSize];
        
    }];
    
}

- (void)handlePanoramaTap:(UIGestureRecognizer *)gr
{
    UIImageView *imageView = (UIImageView *)[gr view];
    UIImage *image = [imageView image];
    
    [self done:image];
}


- (void)done:(UIImage *)image
{
    if (gotPanoramaImage != NULL)
    {
        gotPanoramaImage(image);
    }
    else
    {
        NSLog(@"Warning: gotPanoramaImage has not been set. No action to perform on the selected image.");
    }
}

@end