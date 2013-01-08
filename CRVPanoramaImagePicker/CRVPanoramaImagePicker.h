//
//  CRVPanoramaImagePicker.h
//  PanoramaImagePicker
//
//  Created by Lolcat on 07/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CRVFindPanoramaImages.h"


/* A custom Image Picker that searches for and presents only panorama images.
 *
 * After initializing, you must set the callback for gotPanoramaImage.
 *
 * This isn't correct yet:
 * [panoramaImagePicker setGotPanoramaImage:void(^gotPanoramaImage)(UIImage *panoramaImage)
 {
 NSLog("%@", panoramaImage);
 }
 *
 */

@interface CRVPanoramaImagePicker : UIViewController

@property (strong, nonatomic) void(^gotPanoramaImage)(UIImage *panoramaImage);
@property (nonatomic) BOOL disablePortraitImages;

- (void)handlePanoramaTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleCancel;

@end