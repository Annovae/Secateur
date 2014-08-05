//
//  DRHSecateurDisplayView.m
//  Secateur
//
//  Created by Lee Walsh on 5/08/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurDisplayView.h"
#import "DRHSecateurTree.h"
#import "DRHSecateurDocument.h"

@implementation DRHSecateurDisplayView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _currentTree = nil;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGFloat padding = 20.0;
    NSDictionary *headingAttr = [NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Arial" size:22] forKey:NSFontAttributeName];
    NSRect headingRect;
    headingRect.size = [[_currentTree treeName] sizeWithAttributes:headingAttr];
    headingRect.origin.x = padding * 2.0;
    headingRect.origin.y = _frame.size.height - headingRect.size.height - padding;
    [[_currentTree treeName] drawInRect:headingRect withAttributes:headingAttr];
    
    NSDictionary *subheadingAttr = [NSDictionary dictionaryWithObject:[[NSFontManager sharedFontManager] fontWithFamily:@"Times New Roman" traits:NSItalicFontMask weight:0 size:18] forKey:NSFontAttributeName];
    NSRect subheadingRect;
    subheadingRect.size = [[_currentTree species] sizeWithAttributes:subheadingAttr];
    subheadingRect.origin.x = padding * 2.0;
    subheadingRect.origin.y = headingRect.origin.y - subheadingRect.size.height - padding/2.0;
    [[[_currentTree species] lowercaseString] drawInRect:subheadingRect withAttributes:subheadingAttr];
}

@end
