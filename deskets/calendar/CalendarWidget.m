//
//  CalendarWidget.m
//  homer
//
//  Created by Stan Potemkin on 6/11/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "CalendarWidget.h"


WallWidget* init()
{
	return [[[CalendarWidget alloc] init] autorelease];
}


enum {
	ECalendarDayTypePrevMonth	= 1<<1,
	ECalendarDayTypeRegularDay	= 1<<2,
	ECalendarDayTypeWeekEnd		= 1<<3,
	ECalendarDayTypeNextMonth	= 1<<4,
	ECalendarDayTypeToday		= 1<<7
};


@interface CalendarWidget (Private)
- (float)genCalendar;
- (void)genDay:(int)dayNum ofType:(unsigned int)type inRect:(CGRect)rect;
- (void)onTimerSec;
@end


@implementation CalendarWidget

#pragma mark - Memory -
- (id)init
{
	if ((self = [super init])) {
//		_calTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimerSec) userInfo:nil repeats:YES];
	}
	
	return self;
}

- (void)dealloc
{
	[_calTimer invalidate];
	[super dealloc];
}


#pragma mark - Widget -
- (CGRect)getBounds
{
	float calHeight = [self genCalendar];
	return CGRectMake(0, 0, 600, calHeight);
}

- (void)resizeSelf
{
	CGSize parentSize = self.superview.frame.size;
	CGPoint edgeOffset = [[self class] edgeOffset];
	
	CGRect selfFrame;
	selfFrame.size = [self getBounds].size;
	selfFrame.origin.x = parentSize.width - edgeOffset.x - selfFrame.size.width;
	selfFrame.origin.y = parentSize.height - edgeOffset.y - selfFrame.size.height;
	self.frame = selfFrame;
}

- (void)layoutContents
{
	[self genCalendar];
}


#pragma mark - Calendar -
- (float)genCalendar
{
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	// Coords
	const int daysPerWeek = 7;
	const float xoffset = 10.0;
	const float startx = xoffset;
	const float endx = self.frame.size.width - startx - xoffset;
	const float step = (endx - startx) / (float)daysPerWeek;
	
	const float calheight = self.frame.size.height;
	const float yoffset = 28.0;
	const float ytitsize = 50;
	const float ytitoffset = 0.0; //20.0;
	const float ydaysize = ytitsize;
	const float ydayoffset = 38.0;
	const float ybaseline = calheight - yoffset - ytitsize;
	
	// Gen weekdays titles
	NSArray *dayTitles = [NSArray arrayWithObjects:@"Пн", @"Вт", @"Ср", @"Чт", @"Пт", @"Сб", @"Вс", nil];
	
	for (int i=0, cnt=dayTitles.count; i<cnt; i++) {
		NSText *day = [[[NSText alloc] initWithFrame:CGRectMake(step*i, ybaseline, step, ytitsize)] autorelease];
		day.backgroundColor = [NSColor clearColor];
		day.textColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.6];
		day.alignment = NSCenterTextAlignment;
		day.font = [NSFont fontWithName:@"Consolas" size:15];
		day.string = [dayTitles objectAtIndex:i];
		[self addSubview:day];
	}
	
	// Gen days
	NSDate *todayDate = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *prevMonthComponents = [[NSDateComponents new] autorelease];
	prevMonthComponents.month = -1;
	NSDate *prevMonthDate = [calendar dateByAddingComponents:prevMonthComponents toDate:todayDate options:0];
	
	NSDateComponents *nextMonthComponents = [[NSDateComponents new] autorelease];
	nextMonthComponents.month = -1;
	NSDate *nextMonthDate = [calendar dateByAddingComponents:nextMonthComponents toDate:todayDate options:0];
	
	NSDateComponents *todayComponents = [calendar components:(NSWeekdayCalendarUnit | NSDayCalendarUnit) fromDate:todayDate];
	NSRange thisMonthDaysRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:todayDate];
	NSRange prevMonthDaysRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:prevMonthDate];
	NSRange nextMonthDaysRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:nextMonthDate];
	
	int today = todayComponents.day;
	
	int weekday = todayComponents.weekday;
	weekday = (weekday<2 ? weekday+5 : weekday-2);
	
	int startWeekday = weekday;
	
	int loopCounter = today;
	while (loopCounter > 1) {
		loopCounter--;
		startWeekday--;
		
		if (startWeekday == -1) {
			startWeekday = daysPerWeek - 1;
		}
	}
	
	bool isInitRow = true;
	int daysLeft = thisMonthDaysRange.length;
	int curday = 0;
	int curweek = 0;
	
	while (true) {
		int curMonthDay = curweek * daysPerWeek + curday + 1;
		CGRect dayRect = CGRectMake(step*curday, ybaseline-ytitoffset-ydaysize-curweek*ydayoffset, step, ydaysize);
		
		// Prev month, if need
		if (isInitRow && curday<startWeekday) {
			int prevMonthDay = prevMonthDaysRange.length - (weekday-curday);
			[self genDay:prevMonthDay ofType:ECalendarDayTypePrevMonth inRect:dayRect];
			curday++;
		}
		
		// Next month, if need
		else if (daysLeft == 0) {
			if (curday < daysPerWeek) {
				int nextMonthDay = nextMonthDaysRange.location + (curMonthDay-thisMonthDaysRange.length) - 1;
				[self genDay:nextMonthDay ofType:ECalendarDayTypeNextMonth inRect:dayRect];
				curday++;
			}
			else {
				return calheight - dayRect.origin.y;
			}
		}
		
		// Current month
		else {
			curMonthDay -= startWeekday;
			
			unsigned int dayType = (curday<5 ? ECalendarDayTypeRegularDay : ECalendarDayTypeWeekEnd);
			if (today == curMonthDay) {
				dayType |= ECalendarDayTypeToday;
			}
			
			[self genDay:curMonthDay ofType:dayType inRect:dayRect];
			
			// Prepare for the next loop
			isInitRow = false;
			daysLeft--;
			
			if (++curday == daysPerWeek) {
				curday = 0;
				curweek++;
			}
		}
	}
	
	return 0;
}

- (void)genDay:(int)dayNum ofType:(unsigned int)type inRect:(CGRect)rect
{
	NSText *day = [[[NSText alloc] initWithFrame:rect] autorelease];
	day.backgroundColor = [NSColor clearColor];
	day.alignment = NSCenterTextAlignment;
	day.font = [NSFont fontWithName:@"Consolas" size:20];
	day.string = [NSString stringWithFormat:@"%i", dayNum];
	
	unsigned int colortype = (type & ~ECalendarDayTypeToday);
	switch (colortype) {
		case ECalendarDayTypePrevMonth:
			//			day.textColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.4];
			day.textColor = [NSColor clearColor];
			break;
			
		case ECalendarDayTypeRegularDay:
			day.textColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.6];
			break;
			
		case ECalendarDayTypeWeekEnd:
			day.textColor = [NSColor colorWithDeviceRed:1.0 green:0.4 blue:0.4 alpha:0.8];
			break;
			
		case ECalendarDayTypeNextMonth:
			//			day.textColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.4];
			day.textColor = [NSColor clearColor];
			break;
	}
	
	if (type & ECalendarDayTypeToday) {
		const float deltab = -5;
		
		CGRect outrect = rect;
		outrect.origin.x -= deltab * 2.5;
		outrect.origin.y -= deltab - 17;
		outrect.size.width += deltab*2.5 * 2;
		outrect.size.height += deltab * 2;
		
		NSView *border = [[[NSView alloc] initWithFrame:outrect] autorelease];
		border.wantsLayer = YES;
		border.layer.borderWidth = 2.0;
		border.layer.borderColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.2].CGColor;
		border.layer.cornerRadius = 10.0;
		[self addSubview:border];
	}
	
	[self addSubview:day];
}


#pragma mark - Timers -
- (void)onTimerSec
{
//	NSDate *curDate = [NSDate date];
}
@end
