//
//  CRFindPanoramaImages.m
//  TestAssetLibrary
//
//  Created by Lolcat on 05/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRFindPanoramaImages.h"

@interface CRFindPanoramaImages ()

- (void)findPanoramasInGroup:(ALAssetsGroup *)group withCallback:(void(^)(ALAssetRepresentation *panoramaImageRef))completion;

@end

@implementation CRFindPanoramaImages

- (NSObject *) init
{
    NSLog(@"did init");
    
    library = [[ALAssetsLibrary alloc] init];
    
    return self;
}

- (void)findPanoramaImagesAndPerformCallback:(void(^)(ALAssetRepresentation
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

- (void)findPanoramasInGroup:(ALAssetsGroup *)group withCallback:(void(^)(ALAssetRepresentation *panoramaImageRef))completion
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
                
                NSLog(@"Is custom rendered");
                
                completion(representation);
            }
            
        }        
    }];
    
    
}


@end
