//
//  ClockWidget.m
//  homer
//
//  Created by Stan Potemkin on 6/11/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "ClockWidget.h"


WallWidget* init()
{
	return [[[ClockWidget alloc] init] autorelease];
}


@interface ClockWidget (Private)
- (void)onTimerSec;
@end


@implementation ClockWidget

#pragma mark - Memory -
- (id)init
{
	if ((self = [super init])) {
		_timeLabel = [[NSText alloc] init];
		_timeLabel.backgroundColor = [NSColor clearColor];
		_timeLabel.textColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.6];
		_timeLabel.alignment = NSCenterTextAlignment;
		_timeLabel.font = [NSFont fontWithName:@"Consolas" size:120];
		[self onTimerSec];
		[self addSubview:_timeLabel];
		
		_clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimerSec) userInfo:nil repeats:YES];
	}
	
	return self;
}

- (void)dealloc
{
	[_clockTimer invalidate];
	[super dealloc];
}


#pragma mark - Widget -
- (CGRect)getBounds
{
	return CGRectMake(0, 0, 360, 135);
}

- (void)resizeSelf
{
	CGSize parentSize = self.superview.frame.size;
	CGPoint edgeOffset = [[self class] edgeOffset];
	
	CGRect selfFrame;
	selfFrame.size = [self getBounds].size;
	selfFrame.origin.x = edgeOffset.x;
	selfFrame.origin.y = parentSize.height - edgeOffset.y - selfFrame.size.height;
	self.frame = selfFrame;
}

- (void)layoutContents
{
	NSDictionary *timeLabelAttribs = [NSDictionary dictionaryWithObject:_timeLabel.font forKey:NSFontAttributeName];
	float timeLabelHeight = [_timeLabel.string sizeWithAttributes:timeLabelAttribs].height;
	
	CGRect timeLabelFrame = self.frame;
	timeLabelFrame.origin.x = 0;
	timeLabelFrame.origin.y = (timeLabelFrame.size.height-timeLabelHeight)*0.5 - 10;
	timeLabelFrame.size.height = timeLabelHeight;
	_timeLabel.frame = timeLabelFrame;
}


#pragma mark - Timers -
- (void)onTimerSec
{
	NSDate *curDate = [NSDate date];
	
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"H:mm"];
	_timeLabel.string = [dateFormat stringFromDate:curDate];
}
@end
