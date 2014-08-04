//
//  DRHGalleryItem.h
//  Secateur
//
//  Created by Lee Walsh on 1/08/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRHGalleryItem : NSObject <NSCoding>

@property NSDate *date;
@property (readonly) NSImage *image;

+(DRHGalleryItem *)galleryItem;
-(void)setImageFromImageView:(NSImageView *)sender;

@end