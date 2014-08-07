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
#import "DRHPottingHistoryItem.h"

@interface DRHSecateurDisplayView() {
    IBOutlet NSTableView *pottingHistoryView;
}
@end

@implementation DRHSecateurDisplayView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _currentTree = nil;
/*        pottingHistoryView = [[NSTableView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 0.0, 0.0)];
        [pottingHistoryView setDataSource:self];
//        [pottingHistoryView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
        NSTableColumn *newColumn = [[NSTableColumn alloc] initWithIdentifier:@"Date"];
        [newColumn setResizingMask:NSTableColumnUserResizingMask];
        [newColumn setWidth:95.0];
        [pottingHistoryView addTableColumn:newColumn];
        newColumn = [[NSTableColumn alloc] initWithIdentifier:@"Pot"];
        [newColumn setResizingMask:NSTableColumnAutoresizingMask];
        [pottingHistoryView addTableColumn:newColumn];
        newColumn = [[NSTableColumn alloc] initWithIdentifier:@"Soil"];
        [newColumn setResizingMask:NSTableColumnAutoresizingMask];
        [pottingHistoryView addTableColumn:newColumn];
        newColumn = [[NSTableColumn alloc] initWithIdentifier:@"Fertiliser"];
        [newColumn setResizingMask:NSTableColumnAutoresizingMask];
        [pottingHistoryView addTableColumn:newColumn];
        [self addSubview:pottingHistoryView];*/
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor whiteColor] setFill];
    [[NSColor grayColor] setStroke];
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRect:_frame];
//    [bgPath fill];
    [bgPath stroke];
    
    CGFloat padding = 20.0;
    NSDictionary *textAttr = [NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Arial" size:22] forKey:NSFontAttributeName];
    NSRect textRect;
    textRect.size = [[_currentTree treeName] sizeWithAttributes:textAttr];
    textRect.origin.x = padding;
    textRect.origin.y = _frame.size.height - textRect.size.height - padding;
    [[_currentTree treeName] drawInRect:textRect withAttributes:textAttr];
    
    textAttr = [NSDictionary dictionaryWithObject:[[NSFontManager sharedFontManager] fontWithFamily:@"Times New Roman" traits:NSItalicFontMask weight:0 size:18] forKey:NSFontAttributeName];
    textRect.size = [[_currentTree species] sizeWithAttributes:textAttr];
    textRect.origin.y -= (textRect.size.height + padding/2.0);
    [[[_currentTree species] lowercaseString] drawInRect:textRect withAttributes:textAttr];
    
    NSRect mainSpaceRect = _frame;
    mainSpaceRect.size.height -= 4.0;
    mainSpaceRect.size.width -= 2.0*padding;
    mainSpaceRect.origin.x = padding;
    mainSpaceRect.origin.y = padding;
    mainSpaceRect.size.height = textRect.origin.y - padding;
    NSRect currentDrawSpace;
    currentDrawSpace.size = _currentTree.displayImage.size;
    currentDrawSpace.origin.x = currentDrawSpace.size.width / currentDrawSpace.size.height;
    currentDrawSpace.size.height = (mainSpaceRect.size.height - 2.0*padding) / 3.0;
    currentDrawSpace.size.width = currentDrawSpace.size.height;
    if (_currentTree.displayImage)
        currentDrawSpace.size.width *= currentDrawSpace.origin.x;
    currentDrawSpace.origin.x = padding;
    currentDrawSpace.origin.y = currentDrawSpace.size.height*2.0 + 2.0*padding;
    [_currentTree.displayImage drawInRect:currentDrawSpace];
    
    textAttr = [NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Times New Roman" size:18] forKey:NSFontAttributeName];
    textRect.origin.x = currentDrawSpace.origin.x + currentDrawSpace.size.width + 2.0*padding;
    textRect.size.height = [@"A" sizeWithAttributes:textAttr].height;
    textRect.origin.y = currentDrawSpace.origin.y;
    textRect.origin.y += (currentDrawSpace.size.height - textRect.size.height*3.0 - padding) / 2.0;
    NSString *textString = @"Last potting date:";
    textRect.size = [textString sizeWithAttributes:textAttr];
    NSRect dataTextRect = textRect;
    dataTextRect.origin.x += padding + textRect.size.width;
    [textString drawInRect:textRect withAttributes:textAttr];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    textString = [dateFormat stringFromDate:_currentTree.potUpDate];
    dataTextRect.size = [textString sizeWithAttributes:textAttr];
    [textString drawInRect:dataTextRect withAttributes:textAttr];
    
    textString = @"Start date:";
    textRect.size = [textString sizeWithAttributes:textAttr];
    textRect.origin.y += textRect.size.height + padding/2.0;
    dataTextRect.origin.y = textRect.origin.y;
    [textString drawInRect:textRect withAttributes:textAttr];
    textString = [dateFormat stringFromDate:_currentTree.startDate];
    dataTextRect.size = [textString sizeWithAttributes:textAttr];
    [textString drawInRect:dataTextRect withAttributes:textAttr];
    
    textString = @"Source:";
    textRect.size = [textString sizeWithAttributes:textAttr];
    textRect.origin.y += textRect.size.height + padding/2.0;
    dataTextRect.origin.y = textRect.origin.y;
    [textString drawInRect:textRect withAttributes:textAttr];
    textString = _currentTree.source;
    dataTextRect.size = [textString sizeWithAttributes:textAttr];
    [textString drawInRect:dataTextRect withAttributes:textAttr];
    
    currentDrawSpace.origin.y -= currentDrawSpace.size.height + padding;
    currentDrawSpace.size.width = mainSpaceRect.size.width;
}

@end
