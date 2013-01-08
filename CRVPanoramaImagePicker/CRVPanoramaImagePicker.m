//
//  CRVPanoramaImagePicker.m
//  PanoramaImagePicker
//
//  Created by Lolcat on 07/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//
#import "CRVPanoramaImagePicker.h"
#import "QuartzCore/CALayer.h"


@interface CRVPanoramaImagePicker ()

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) CGSize scrollViewContentSize;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) CRFindPanoramaImages *panoramaImageFinder;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation CRVPanoramaImagePicker

@synthesize scrollView, mainView, toolBar, scrollViewContentSize, gotPanoramaImage, disablePortraitImages, panoramaImageFinder, hud;

- (id)init
{
    self = [super init];
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
    
    panoramaImageFinder = [[CRFindPanoramaImages alloc] init];
    
    [panoramaImageFinder setDisablePortraitImages:disablePortraitImages];
    
    scrollViewContentSize = [[UIScreen mainScreen] bounds].size;
    
    [self setUpViews];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeAnnularDeterminate];
    [hud setLabelText:@"Searching For Panoramas"];
    [hud setDetailsLabelText:@"In Camera Roll"];
    
    // TODO: See if this can be better implemented within the actual image finder.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // http://stackoverflow.com/questions/2708776/async-call-objective-c-iphone
        // No explicit autorelease pool needed here.
        // The code runs in background, not strangling
        // the main run loop.
        [self openImagePicker];
        
        
    });
    
    
}

-(void)openImagePicker
{
    __block CGFloat margin = 10;
    __block NSInteger scrollViewTop = toolBar.bounds.size.height + toolBar.bounds.origin.y + margin;
    __block CGFloat viewWidth = scrollViewContentSize.width;
    __block CGFloat imageWidth = scrollViewContentSize.width - (margin * 2);
    
    void(^foundImageCallback)(ALAsset *panoramaImageRef) = ^(ALAsset *panoramaImageRef) {
        
        /*  The call to get the image out of the defaultRepresentation is very slow.
         Fast: [panoramaImageRef aspectRatioThumbnail]
         Slower: [[panoramaImageRef defaultRepresentation] fullScreenImage]
         Slowest: [[panoramaImageRef defaultRepresentation] fullResolutionImage]
         */
        // create the thumbnail and image view
        UIImage *thumb = [UIImage imageWithCGImage:[[panoramaImageRef defaultRepresentation] fullScreenImage]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:thumb];
        
        // set the dimensions of the thumbnail
        CGSize dimensions = [[panoramaImageRef defaultRepresentation] dimensions];
        CGFloat aspectRatio = dimensions.height / dimensions.width ;
        CGFloat height = aspectRatio * viewWidth;
        CGRect imageFrame = CGRectMake(10, scrollViewTop, imageWidth, height);
        NSLog(@"%@", NSStringFromCGRect(imageFrame));
        
        // show the thumbnail
        [imageView setFrame:imageFrame];
        [scrollView addSubview:imageView];
        
        [[imageView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [[imageView layer] setBorderWidth:1];
        
        // add the tap action
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanoramaTap:)];
        [imageView addGestureRecognizer:tapRecognizer];
        
        // update the size of the scrollview and the top position of the next image
        scrollViewTop += height + margin;
        scrollViewContentSize.height = scrollViewTop;
        [[self scrollView] setContentSize:scrollViewContentSize];
        
    };

    void(^doneFindingImages)(void) = ^(void) {
        NSLog(@"Done finding images");
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [hud hide:YES];
    };
    
    void(^progressCallback)(float progress) = ^(float progress) {
        NSLog(@"Progress: %f", progress);
        [hud setProgress:progress];
    };
    
    [panoramaImageFinder findPanoramaImagesWithCallback:foundImageCallback
                                   withProgressCallback:progressCallback
                                               WhenDone:doneFindingImages];

}



- (void)setUpViews
{    
    mainView = [self view];
    CGRect screenBounds = mainView.bounds;
    CGFloat screenWidth = mainView.bounds.size.width;
    CGFloat screenHeight = mainView.bounds.size.height;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [activityIndicatorView setCenter:CGPointMake(screenWidth/2.0, screenHeight/2.0)];
    [activityIndicatorView startAnimating];
    [mainView addSubview:activityIndicatorView];
        
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [mainView addSubview:scrollView];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, scrollViewContentSize.width, 44)];
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithTitle:@"Select Panorama"
                                                              style:UIBarButtonItemStylePlain
                                                             target:nil
                                                             action:nil];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self
                                                                            action:@selector(handleCancel)];
    [cancel setTintColor:[UIColor blueColor]];
    
    NSArray *items = [[NSArray alloc] initWithObjects:cancel, spacer, title, spacer, nil];
    
    [toolBar setItems:items];
    [toolBar setUserInteractionEnabled:YES];
    [toolBar setTintColor:[UIColor blackColor]];
    [toolBar setTranslucent:YES];
    
    [mainView addSubview:toolBar];
    
}

- (void)handleCancel
{
    NSLog(@"Cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
    [panoramaImageFinder setStopFindingImages:YES];
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