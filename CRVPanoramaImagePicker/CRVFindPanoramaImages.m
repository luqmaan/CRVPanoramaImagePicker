//
//  CRFindPanoramaImages.m
//  TestAssetLibrary
//
//  Created by Lolcat on 05/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRVFindPanoramaImages.h"

@interface CRFindPanoramaImages ()

- (void)findPanoramasInGroup:(ALAssetsGroup *)group withCallback:(void(^)(ALAsset *panoramaImageRef))completion;

@end

@implementation CRFindPanoramaImages

@synthesize disablePortraitImages, stopFindingImages;

- (NSObject *) init
{
    NSLog(@"did init");
    
    library = [[ALAssetsLibrary alloc] init];
    
    disablePortraitImages = NO;
    stopFindingImages = NO;
    
    return self;
}

- (void)findPanoramaImagesAndPerformCallback:(void(^)(ALAsset
                                                      *panoramaImageRef))completion
{
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil)
        {
            [self findPanoramasInGroup:group
                          withCallback:completion];
        }
        stop = &(stopFindingImages);
    } failureBlock:^(NSError *error) {
        NSLog(@"Failure: Could not enumerate groups.");
        NSLog(@"Error: %@", error);
    }];
}

- (void)findPanoramasInGroup:(ALAssetsGroup *)group withCallback:(void(^)(ALAsset *panoramaImageRef))completion
{    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil)
        {
            
            ALAssetRepresentation *representation = [result defaultRepresentation];
            NSDictionary *metadata = [representation metadata];
            
//          NSLog(@"%@", metadata);

            id PixelHeight = [metadata objectForKey:@"PixelHeight"];
            
            if (PixelHeight != nil)
            {
                NSNumber *height = PixelHeight;
                NSNumber *width = [metadata objectForKey:@"PixelWidth"];
                
                float h = [height floatValue];
                float w = [width floatValue];
                
                if (w > 3500 || (!disablePortraitImages && h > 3500))
                {
                    float r = w / h;
                    
                    BOOL isLandscape = r > 2.5;
                    BOOL isPortrait = r < 0.55;
                    
                    if (isLandscape || (!disablePortraitImages && isPortrait))
                    {
//                        NSLog(@"%@ %@ %f || %@ %@ %f || %f", height, [metadata objectForKey:@"PixelHeight"], h, width, [metadata objectForKey:@"PixelWidth"], w, r);
                        completion(result);
               
                    }
                }
            }
            
            stop = &(stopFindingImages);
        }        
    }];
    
    
}


@end
