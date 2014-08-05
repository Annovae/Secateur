//
//  DRHSecateurEditingViewController.m
//  Secateur
//
//  Created by Lee Walsh on 17/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurEditingViewController.h"
#import "DRHSecateurDocument.h"
#import "DRHSecateurTree.h"
#import "DRHPottingHistoryItem.h"
#import "DRHGalleryItem.h"

@interface DRHSecateurEditingViewController (){
    BOOL tableIsDatePicking;
    NSDatePicker *tableDatePicker;
    NSInteger tableDatePickerRow;
    NSTableView *datePickingTable;
    id eventMonitor;
}
-(void)clearDatePicker;

@end

@implementation DRHSecateurEditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DRHSecateurEditingView" bundle:nil];
    if (self) {
        // Initialization code here.
        tableIsDatePicking = NO;
        tableDatePicker = nil;
        tableDatePickerRow = -1;
        datePickingTable = nil;
        eventMonitor = nil;
    }
    return self;
}

-(NSTextField *)nameField{
    return nameField;
}

-(NSTextField *)speciesField{
    return speciesField;
}

-(NSTextField *)sourceField{
    return sourceField;
}

-(NSDatePicker *)startDatePicker{
    return startDatePicker;
}

-(NSDatePicker *)potUpDatePicker{
    return potUpDatePicker;
}


#pragma mark NSTableViewDataSource methods
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if ([[tableView identifier] isEqualToString:@"pottingHistoryTable"])
        return [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] count];
    else if ([[tableView identifier] isEqualToString:@"galleryTable"])
        return [[[[self.view.window.windowController document] selectedTree] galleryArray] count];
    return 0;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableView identifier] isEqualToString:@"pottingHistoryTable"]){
        DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:row];
        if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date"])
            return currentItem.date;
        else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Pot"])
            return currentItem.pot;
        else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Soil"])
            return currentItem.soil;
        else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Fertiliser"])
            return currentItem.fertiliser;
    } else if ([[tableView identifier] isEqualToString:@"galleryTable"]){
        DRHGalleryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] galleryArray] objectAtIndex:row];
        if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date"])
            return currentItem.date;
        else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Photo"])
            return currentItem.image;
    }
    return nil;
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableView identifier] isEqualToString:@"pottingHistoryTable"]){
        DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:row];
        if ([[tableColumn.headerCell stringValue] isEqualToString:@"Pot"])
            currentItem.pot = object;
        else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Soil"])
            currentItem.soil = object;
        else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Fertiliser"])
            currentItem.fertiliser = object;
        [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
    }
}

#pragma mark NSTableViewDelegate methods
-(BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    NSLog(@"Column: %@",[tableColumn.headerCell stringValue]);
    if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date"]) {
        if (!tableIsDatePicking) {
            datePickingTable = tableView;
            NSRect cellFrame = [tableView frameOfCellAtColumn:0 row:row];
            tableDatePicker = [[NSDatePicker alloc] init];
            [tableDatePicker setDatePickerStyle:NSClockAndCalendarDatePickerStyle];
            [tableDatePicker setFrameOrigin:cellFrame.origin];
            [tableDatePicker setFrameSize:NSMakeSize(139.0, 148.0)];
            [tableDatePicker setDrawsBackground:YES];
//            DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:row];
            id currentItem = nil;
            if ([[tableView identifier] isEqualToString:@"pottingHistoryTable"])
                currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:row];
            else if ([[tableView identifier] isEqualToString:@"galleryTable"])
                currentItem = [[[[self.view.window.windowController document] selectedTree] galleryArray] objectAtIndex:row];
            [tableDatePicker bind:@"value" toObject:currentItem withKeyPath:@"date" options:nil];
            [currentItem addObserver:self forKeyPath:@"date" options:0 context:nil];
            [tableView addSubview:tableDatePicker];
            tableIsDatePicking = YES;
            tableDatePickerRow = row;
            [self.view setNeedsDisplay:YES];
            
            //Monitor for event that should close (cancel) the NSDatePicker
            eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask | NSRightMouseDownMask | NSOtherMouseDownMask | NSKeyDownMask handler:^(NSEvent *incomingEvent) {
                NSEventType eventType = [incomingEvent type];
                if (eventType == NSKeyDown) {
                    if ([incomingEvent keyCode] == 53) {
                        // Escape
                        [self clearDatePicker];
 //                       result = nil; // Don't process the event
                    }
                } else  if (eventType == NSLeftMouseDown || eventType == NSRightMouseDown || eventType == NSOtherMouseDown){
                    NSPoint mouseLocation = [incomingEvent locationInWindow];
                    mouseLocation = [self.view convertPoint:mouseLocation fromView:nil];
                    mouseLocation = [self.view convertPoint:mouseLocation toView:tableDatePicker];
                    NSSize datePickerSize = [tableDatePicker frame].size;
                    if (mouseLocation.x<0 || mouseLocation.x>datePickerSize.width || mouseLocation.y<0 || mouseLocation.y>datePickerSize.height)
                        [self clearDatePicker];
//                    NSLog(@"Size: %lf,%lf; point: %f,%lf",datePickerSize.width,datePickerSize.height,mouseLocation.x,mouseLocation.y);
                }
                return incomingEvent;
            }];
            return NO;
        }
        return NO;
    }
    return YES;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSIndexSet *selectedTreeIndexes = [notification.object selectedRowIndexes];
    if ([selectedTreeIndexes count] > 0) {
        DRHGalleryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] galleryArray] objectAtIndex:[selectedTreeIndexes firstIndex]];
        [galleryImageView setImage:currentItem.image];
        [galleryImageView setNeedsDisplay:YES];
        [galleryImageView setEditable:YES];
    } else
        [galleryImageView setEditable:NO];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
}


-(void)bindToTree:(DRHSecateurTree *)tree{
    [nameField unbind:@"value"];
    [nameField bind:@"value" toObject:tree withKeyPath:@"treeName" options:nil];
    [speciesField unbind:@"value"];
    [speciesField bind:@"value" toObject:tree withKeyPath:@"species" options:nil];
    [sourceField unbind:@"value"];
    [sourceField bind:@"value" toObject:tree withKeyPath:@"source" options:nil];
    [startDatePicker unbind:@"value"];
    [startDatePicker bind:@"value" toObject:tree withKeyPath:@"startDate" options:nil];
    [potUpDatePicker unbind:@"value"];
    [potUpDatePicker bind:@"value" toObject:tree withKeyPath:@"potUpDate" options:nil];
    [pottingHistoryTable reloadData];
    [galleryTable reloadData];
}

-(IBAction)addPottingHistory:(id)sender{
    [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] addObject:[DRHPottingHistoryItem pottingHistoryItem]];
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
    [pottingHistoryTable reloadData];
}

-(IBAction)removePottingHistory:(id)sender{
    NSMutableArray *historyArray = [[[self.view.window.windowController document] selectedTree] pottingHistoryArray];
    if ([historyArray count] > 0)
        [historyArray removeObjectsAtIndexes:[pottingHistoryTable selectedRowIndexes]];
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
    [pottingHistoryTable reloadData];
}

-(void)clearDatePicker{
    [tableDatePicker removeFromSuperview];
    [tableDatePicker unbind:@"value"];
//    DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:pottingHistoryTableDatePickerRow];
    id currentItem = nil;
    if ([[datePickingTable identifier] isEqualToString:@"pottingHistoryTable"])
        currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:tableDatePickerRow];
    else if ([[datePickingTable identifier] isEqualToString:@"galleryTable"])
        currentItem = [[[[self.view.window.windowController document] selectedTree] galleryArray] objectAtIndex:tableDatePickerRow];
    [currentItem removeObserver:self forKeyPath:@"date"];
    tableDatePickerRow = -1;
    tableDatePicker = nil;
    tableIsDatePicking = NO;
    datePickingTable = nil;
    [self.view setNeedsDisplay:YES];
    if (eventMonitor) {
        [NSEvent removeMonitor:eventMonitor];
        eventMonitor = nil;
    }
}

-(IBAction)addGalleryItem:(id)sender{
    [[[[self.view.window.windowController document] selectedTree] galleryArray] addObject:[DRHGalleryItem galleryItem]];
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
    [galleryTable reloadData];
}

-(IBAction)removeGalleryItem:(id)sender{
    NSMutableArray *galleryArray = [[[self.view.window.windowController document] selectedTree] galleryArray];
    if ([galleryArray count] > 0){
        [galleryArray removeObjectsAtIndexes:[galleryTable selectedRowIndexes]];
        [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
        [galleryTable reloadData];
    }
}

-(IBAction)newGalleryImage:(id)sender{
//    NSLog(@"newGalleryImage:");
    NSMutableArray *galleryArray = [[[self.view.window.windowController document] selectedTree] galleryArray];
    if ([galleryArray count] > 0) {
        DRHGalleryItem *currentItem = [galleryArray objectAtIndex:[[galleryTable selectedRowIndexes] firstIndex]];
        [currentItem setImageFromImageView:sender];
        [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
        [galleryTable reloadData];
    }
}

-(IBAction)updateDisplayImage:(id)sender{
    [[[self.view.window.windowController document] selectedTree] setDisplayImage:[galleryImageView image]];
}

@end
