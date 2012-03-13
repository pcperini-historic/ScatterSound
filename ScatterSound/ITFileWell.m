//
//  ITFileWell.m
//  ScatterSound
//
//  Created by Patrick Perini on 3/9/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import "ITFileWell.h"
#import "AppDelegate.h"

NSString *const ITFileWellDidReceiveDraggedFile = @"ITFileWellDidReceiveDraggedFile";

@implementation ITFileWell

@synthesize highlighted;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self registerForDraggedTypes: [NSArray arrayWithObject: NSPasteboardTypeSound]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect: dirtyRect];
    
    if (self.isHighlighted)
    {
        [NSGraphicsContext saveGraphicsState];
        
        NSBezierPath *highlightPath = [NSBezierPath bezierPathWithRoundedRect: self.bounds
                                                                      xRadius: 4.0
                                                                      yRadius: 4.0];
        
        [[NSColor colorWithCalibratedWhite: 0.00 alpha: 0.25] set];
        [highlightPath fill];
        
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    highlighted = YES;
    [self setNeedsDisplay];
    
    [NSApp activateIgnoringOtherApps: YES];
    [[(AppDelegate *)[NSApp delegate] window] makeKeyAndOrderFront: nil];
    
    return NSDragOperationGeneric;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    highlighted = NO;
    [self setNeedsDisplay];
    
    NSURL *fileURL = [NSURL URLFromPasteboard: [sender draggingPasteboard]];
    [[NSNotificationCenter defaultCenter] postNotificationName: ITFileWellDidReceiveDraggedFile
                                                        object: fileURL];
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    highlighted = NO;
    [self setNeedsDisplay];
}

@end
