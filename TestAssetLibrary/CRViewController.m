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

@synthesize library, assetsGroupById, panoramaPhotos;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"hello");
    
    library = [[ALAssetsLibrary alloc] init];
    assetsGroupById = [[NSMutableDictionary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil)
        {            
            NSLog(@"usingBlocks");
            
            NSLog(@"group: %@", group);
            NSLog(@"numberOfAssets: %d", group.numberOfAssets);
            
            NSString *albumName = [group valueForProperty:ALAssetsGroupPropertyName];
            NSString *albumId = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
            NSUInteger count = [group numberOfAssets];
            
            NSLog(@"%u %@ %@", count, albumId, albumName);
            
            [self findPanoramasInGroup:group
                          withCallback:
             ^(ALAssetsGroup *groupOfPanoramas) {
                 [self presentPanoramasWithGroup:groupOfPanoramas];
            }];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"failureBlock");
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


- (void)findPanoramasInGroup:(ALAssetsGroup *)group withCallback:(void(^)(ALAssetsGroup *groupOfPanoramas) )completion
{
    NSLog(@"wanna do something with group: %@", group);
    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result != nil)
        {
                                    
            NSDictionary *metadata = [[result defaultRepresentation] metadata];
            
            id customRendered = [[metadata objectForKey:@"{Exif}"] objectForKey:@"CustomRendered"];
            
            NSLog(@"%@", customRendered);
            
            if (customRendered)
            {
                [panoramaPhotos addAsset:result];
                
                UIImage *thumb = [UIImage imageWithCGImage:[result thumbnail]];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:thumb];
                
                CGRect frame = CGRectMake(index * 20, index * 30, 50, 60);
                [imageView setFrame:frame];
                
                [[self view] addSubview:imageView];

            }
        
        }
        else
        {
            completion(group);
        }
     
    }];
    
    
}

@end
