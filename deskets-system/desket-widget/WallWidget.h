//
//  WallWidget.h
//  homer
//
//  Created by Stan Potemkin on 6/11/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSView+Wallsheet.h"
#import "NSColor+CGColor.h"


@protocol WallWidgetProtocol <NSObject>
@required
- (CGRect)getBounds;
- (void)resizeSelf;
- (void)layoutContents;
@end


@interface WallWidget : NSView
+ (WallWidget *)widget;
+ (CGPoint)edgeOffset;
@end
