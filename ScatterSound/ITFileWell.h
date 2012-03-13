//
//  ITFileWell.h
//  ScatterSound
//
//  Created by Patrick Perini on 3/9/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const ITFileWellDidReceiveDraggedFile;

@interface ITFileWell : NSImageView

@property (nonatomic, getter = isHighlighted) BOOL highlighted;

@end
