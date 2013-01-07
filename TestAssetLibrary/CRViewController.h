//
//  CRViewController.h
//  TestAssetLibrary
//
//  Created by Intern on 1/2/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRVPanoramaImagePicker.h"

@interface CRViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

- (IBAction)btnOpenImagePicker:(id)sender;

@end
