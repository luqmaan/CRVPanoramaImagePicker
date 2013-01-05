//
//  CRFindPanoramaImages.h
//  TestAssetLibrary
//
//  Created by Lolcat on 05/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//
// Adapted from: https://github.com/pierrotsmnrd/grabKit/blob/master/grabKit/grabKit/grabKitSources/serviceGrabbers/deviceGrabber/GRKDeviceGrabber.m

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface CRFindPanoramaImages : NSObject {
    ALAssetsLibrary *library;
    NSMutableDictionary *assetsGroupById;
}

/**
 * Method name: findPanoramaImagesWithCallback
 * Description: Performs the specified callback on each image that is a panorama 
 * Parameters: A callback that recevies a UIImage
 */
- (void)findPanoramaImagesAndPerformCallback:(void(^)(ALAssetRepresentation
                                                      *panoramaImageRef))completion;

@end
