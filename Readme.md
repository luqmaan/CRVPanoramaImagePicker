CRVPanoramaImagePicker
===

A custom image picker designed for picking Panorama images in iOS6.

<span style="border:1px solid #ddd; border-radius: 3px;">![](https://raw.github.com/createch/CRVPanoramaImagePicker/master/Screenshots/loading.png)</span> &nbsp; <span style="border:1px solid #ddd; border-radius: 3px;">!![](https://raw.github.com/createch/CRVPanoramaImagePicker/master/Screenshots/picker.png)</span>

Usage
--

To use it, add the `CRVPanoramaImagePicker` folder to your project. Be sure to `#import "CRVPanoramaImagePicker.h"`.

To initialize the picker:

``` Objective-C
    panoramaImagePicker = [[CRVPanoramaImagePicker alloc] init];
    
    [panoramaImagePicker setDisablePortraitImages:NO];
    [panoramaImagePicker setGotPanoramaImage:^(UIImage * image) {
        NSLog(@"Got the image: %@", image);
        [myImageView setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
```

`setGotPanoramaImage:^(UIImage * image){}` to set the callback performed on the image the user has selected.

You can also disable portrait panoramas via `setDisablePortraitImages`.

To present the image picker:

``` Objective-C
    [self presentViewController:panoramaImagePicker animated:YES completion:nil];
```