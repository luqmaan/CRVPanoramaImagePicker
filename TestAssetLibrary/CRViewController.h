//
//  CRViewController.h
//  TestAssetLibrary
//
//  Created by Intern on 1/2/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CRViewController : UIViewController

@property (strong, nonatomic) ALAssetsLibrary *library;
@property (strong, nonatomic) NSMutableDictionary *assetsGroupById;
@property (strong, nonatomic) ALAssetsGroup *panoramaPhotos;

@end
