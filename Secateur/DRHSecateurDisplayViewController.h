//
//  DRHSecateurDisplayViewController.h
//  Secateur
//
//  Created by Lee Walsh on 17/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRHSecateurDisplayViewController : NSViewController <NSTableViewDataSource> {
    IBOutlet NSTableView *pottingHistoryView;
}

@end
