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

@synthesize disablePortraitImages;

- (NSObject *) init
{
    NSLog(@"did init");
    
    library = [[ALAssetsLibrary alloc] init];
    
    disablePortraitImages = NO;
    
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
    } failureBlock:^(NSError *error) {
        NSLog(@"Failure: Could not enumerate groups.");
        NSLog(@"Error: %@", error);
    }];
}

- (void)findPanoramasInGroup:(ALAssetsGroup *)group withCallback:(void(^)(ALAsset *panoramaImageRef))completion
{
    NSLog(@"wanna do something with group: %@", group);
    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil)
        {
            
            ALAssetRepresentation *representation = [result defaultRepresentation];
            
            NSDictionary *metadata = [representation metadata];
            
            id customRendered = [[metadata objectForKey:@"{Exif}"] objectForKey:@"CustomRendered"];
            
            if (customRendered)
            {
                if (disablePortraitImages)
                {
                    NSNumber *height = [metadata objectForKey:@"PixelHeight"];                    
                    BOOL landscape = [height compare:[NSNumber numberWithInt:3500]] == NSOrderedAscending;
                    
                    if (landscape)
                    {
                        completion(result);
                    }
                }
                else
                {
                    completion(result);
                }
            }
            
        }        
    }];
    
    
}


@end
