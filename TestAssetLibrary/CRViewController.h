//
//  CRViewController.h
//  TestAssetLibrary
//
//  Created by Intern on 1/2/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
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

@interface CRViewController : UIViewController

@property (strong, nonatomic) void(^gotPanoramaImage)(UIImage *panoramaImage);


- (void)handlePanoramaTap:(UIGestureRecognizer *)gestureRecognizer;


@end
