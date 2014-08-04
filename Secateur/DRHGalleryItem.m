//
//  DRHGalleryItem.m
//  Secateur
//
//  Created by Lee Walsh on 1/08/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHGalleryItem.h"

@implementation DRHGalleryItem

-(id)init{
    if (self = [super init]) {
        _date = [NSDate date];
        _image = nil;
    }
    return self;
}

+(DRHGalleryItem *)galleryItem{
    return [[DRHGalleryItem alloc] init];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        if(!(_date = [aDecoder decodeObjectForKey:@"date"]))
            _date = [NSDate date];
        if(!(_image = [aDecoder decodeObjectForKey:@"image"]))
            _image = nil;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_image forKey:@"image"];
}

-(void)setImageFromImageView:(NSImageView *)sender{
    if (_image) {
        NSAlert *confirmOverwriteImageAlert = [NSAlert alertWithMessageText:@"Are you sure you want to overwrite the exisiting image?" defaultButton:@"No" alternateButton:@"Yes" otherButton:nil informativeTextWithFormat:@"If you overwrite this image you can't get it back."];
        [confirmOverwriteImageAlert beginSheetModalForWindow:[sender window] completionHandler:^(NSModalResponse returnCode){
            //        NSLog(@"%ld",returnCode);
            if (returnCode == 0)
                _image = [sender image];
            else
                [sender setImage:_image];
        }];
    } else {
        _image = [sender image];
    }
}

@end
