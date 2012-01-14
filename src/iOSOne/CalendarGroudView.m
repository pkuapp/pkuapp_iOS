//
//  CalendarGroudView.m
//  iOSOne
//
//  Created by wuhaotian on 11-7-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//



#import "CalendarGroudView.h"
#import "QuartzCore/CALayer.h"
#import "SystemHelper.h"
#import <EventKit/EventKit.h>
#import "SystemHelper.h"
#import "Course.h"
#import "ModelsAddon.h"

@implementation CalendarGroundView

- (void)setupForDisplay
{
    for (int i = 0; i < 12 ; i++) {
    float start = [Course starthourForClass:i+1];
    CGRect tagFrame = CGRectMake(widthHourTag, heightOffset + start*heightHour, widthClassTag, heightClassTag);
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:tagFrame];
    tagLabel.textAlignment = UITextAlignmentCenter;
    tagLabel.text = [NSString stringWithFormat:@"%d",i+1];
    tagLabel.font = fontHourTag;
    tagLabel.backgroundColor = [UIColor clearColor];
    [tagLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:tagLabel];
    }
}

-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
    
    CGContextSetRGBStrokeColor(context, 145/255, 145/255, 145/255, 1.0);
    
    //for (NSString *familyName in [UIFont familyNames]) { NSLog(@"%@, %@", familyName, [UIFont fontNamesForFamilyName:familyName]); }    
	CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSetLineWidth(context, 0.3);
    float x = widthOffsetDayView;
    float y = heightOffset;
    const CGFloat  patterns[1] = {1};
    for (int i = 0;i < 25 ; i++, y += heightHour) {
        CGContextSetRGBFillColor(context, 145/255, 145/255, 145/255, 1.0);
        CGContextSetLineDash(context, 0, NULL, 0);
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, widthTotal, y);
        CGContextStrokePath(context);
        
        CGContextMoveToPoint(context, x, y+heightHour/2.0);
        CGContextAddLineToPoint(context, widthTotal, y+heightHour/2.0);
        
        CGContextSetLineDash(context, 0, patterns, 1);
        CGContextStrokePath(context);
        
        
        [[NSString stringWithFormat:@"%d:00",i] drawInRect:CGRectMake(0.0, y-sizeFontHourTag/2.0, widthHourTag, 24) withFont:fontHourTag lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentRight];
        //int length = [[NSString stringWithFormat:@"%d:00",i] length];
        //CGContextShowTextAtPoint(context, 5.0, y + sizeFont / 2,kstring ,length);
        
    }
    
    const CGFloat *colorTagComp = CGColorGetComponents([colorClassTag CGColor]);
    const CGFloat *colorTagBgComp = CGColorGetComponents([colorClassTaBg CGColor]);
    
    CGContextSetRGBFillColor(context, colorTagBgComp[0], colorTagBgComp[1], colorTagBgComp[2], 1.0);
    CGContextFillRect(context, CGRectMake(widthHourTag, 0, widthClassTag, heightTotal));
    CGContextSetRGBFillColor(context, colorTagComp[0], colorTagComp[1], colorTagComp[2], 1.0);
    for (int i = 0; i < 12; i ++) {
        float start = [Course starthourForClass:i+1];
        CGRect tagFrame = CGRectMake(widthHourTag, heightOffset + start*heightHour, widthClassTag, heightClassTag);
        CGContextFillRect(context,tagFrame);
        }
    /*CGContextSetRGBFillColor(context, 0.5, 1.0, 1.0, 1.0);
     
     for (int i ; i < 12; i++) {
     float start =  [Course starthourForClass:i+1];
     NSString *tag = [NSString stringWithFormat:@"%d",i+1];
     [tag drawInRect:CGRectMake(widthHourTag, heightOffset + start*heightHour, widthClassTag, heightClassTag) withFont:fontHourTag lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
     
     }*/
}

@end

@implementation CalendarWeekGroundView


-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
	}
	return self;
}

-(void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];

}

-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}
@end


#pragma mark - DayGroundView

@implementation CalendarDayGroundView

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
    }
	return self;
}

-(void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];

}
-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

@end

#pragma mark - EventView -

@implementation EventView

@synthesize EventName;
@synthesize groundType;
@synthesize weight;
@synthesize numDay;
@synthesize startHour,endHour,xIndent,viewType,stringLocation,identifier,objIndex,delegate;

- (void)didSelectSelfView
{
    if (self.viewType == EventViewNone) {
        NSLog(@"%d",self.objIndex);
        [self.delegate didSelectEKEventForIndex:self.objIndex];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x+1, frame.origin.y, frame.size.width-2, frame.size.height)];
    if (nil != self) {
        //self.layer.cornerRadius = 6.0;
        //self.layer.masksToBounds = YES;
        //self.layer.borderWidth = 1.0;
        //self.layer.borderColor = colorBorder;
        //self.clearsContextBeforeDrawing = YES;
        //self.backgroundColor = colorCourseBg;
    }
    return self;
}

- (void)drawInWeekContext:(CGContextRef)context
{
    /*
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    CGContextSelectFont(context, "Helvetica", 7.0, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSetLineWidth(context, 0.3);
    CGContextShowTextAtPoint(context,3.0,10.0,[self.EventName UTF8String], 7);
    */
    
    
    CGContextSetRGBFillColor(context,1.0 , 1.0, 1.0, 1.0);
    CGRect frame = CGRectMake( 5,5 , self.bounds.size.width-10, self.bounds.size.height-10);
    [self.EventName drawInRect:frame withFont:fontTitleWeek lineBreakMode:UILineBreakModeWordWrap];
}

- (void)drawInDayContext:(CGContextRef)context
{
    CGPoint titlePoint,subtitlePoint;
    float titleWidth;
    CGContextSetRGBFillColor(context,1.0 , 1.0, 1.0, 1.0);
    float lineWidthOffset = 0;
    if (self.viewType == EventViewCourse) {
        lineWidthOffset = widthClassTag;
    }
    titlePoint = CGPointMake(5+lineWidthOffset,5);
    titleWidth = self.bounds.size.width - lineWidthOffset -10;
    subtitlePoint = CGPointMake(5+lineWidthOffset, 5+18);
    float fulltitleWidth = [self.EventName sizeWithFont:fontTitle].width;
    if (fulltitleWidth > titleWidth) {
        //rangeString = NSString stringWithFormat:@"{%d,%d}",widthTotal / sizeFont -1,NSString
        //NSRangeFromString(@"");
        NSInteger index = self.EventName.length * titleWidth/fulltitleWidth -2;
        if (index > 0) {
            self.EventName = [[self.EventName substringToIndex:index] stringByAppendingFormat:@"..."];   
        }
    }
    [self.EventName drawAtPoint:titlePoint forWidth:titleWidth withFont:fontTitle lineBreakMode:UILineBreakModeWordWrap];
    [self.stringLocation drawAtPoint:subtitlePoint forWidth:titleWidth withFont:fontTitle lineBreakMode:UILineBreakModeWordWrap];
    
}

- (void)drawRect:(CGRect)rect

{
    if (self.groundType == CalendarGroundTypeDay) {
        [self drawInDayContext:UIGraphicsGetCurrentContext()];
    }
    else if (self.groundType == CalendarGroundTypeWeek)
    [self drawInWeekContext:UIGraphicsGetCurrentContext()];
}


- (id)initWithDict:(NSDictionary *)dict ForGroundType:(CalendarGroundType)thegroundType ViewType:(EventViewType)theViewType
{
    float start  = [[dict objectForKey:@"start"] floatValue];
    float end  = [[dict objectForKey:@"end"] floatValue];
    int day = [[dict objectForKey:@"day"] intValue];
    
    NSString *name = [dict objectForKey:@"name"];
    NSString *location = [dict objectForKey:@"place"];
    
    if (thegroundType == CalendarGroundTypeWeek) {
        CGRect  frame = CGRectMake(widthHourTag+ widthOffset + (day-1)*widthColumn ,heightOffset + start * heightHour, widthColumn,heightHour * (end - start));
        self = [self initWithFrame:frame];

    }
    self = [super init];
    if (self) {
        self.weight = 1.0;
        self.EventName = name;
        self.xIndent = 0;
        self.startHour = start;
        self.endHour = end;
        self.groundType = thegroundType;
        self.viewType = theViewType;
        self.stringLocation = location;
        self.identifier = [[dict objectForKey:@"identifier"] intValue];
        self.numDay = day;
    }
    return self;
    
}

- (id)initWithEKEvent:(EKEvent *)event ForGroudType:(CalendarGroundType)thegroundType inDate:(NSDate *)date
{
    NSString *name = event.title;
    
    NSString *location = event.location;
    
    if (thegroundType == CalendarGroundTypeDay) {
    
    float start = [self floatHourForDate:event.startDate inDate:date];
    float end = [self floatHourForDate:event.endDate inDate:date];
    
    NSNumber *daynum = [NSNumber numberWithInt:[SystemHelper getDayForDate:event.startDate]];
        
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",[NSNumber numberWithFloat:start],@"start",[NSNumber numberWithFloat:end],@"end",daynum,@"day" ,location,@"place",nil];
        
    return [self initWithDict:dict ForGroundType:CalendarGroundTypeDay ViewType:EventViewNone];
    }
    else if (thegroundType == CalendarGroundTypeWeek){
        if ([event.endDate timeIntervalSinceDate:event.startDate] < 86400) {
            float start = [self floatHourForDate:event.startDate inDate:date];
            float end = [self floatHourForDate:event.endDate inDate:date];

            NSNumber *daynum = [NSNumber numberWithInt:[SystemHelper getDayForDate:event.startDate]];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",[NSNumber numberWithFloat:start],@"start",[NSNumber numberWithFloat:end],@"end",daynum,@"day" ,location,@"place",nil];
            
            return [self initWithDict:dict ForGroundType:CalendarGroundTypeDay ViewType:EventViewNone];
        }
    }
    return nil;
    
}
//call this method after you determined property xIndent and weight
- (void)setupForDayDisplay
{
    float width = widthNormalDayView * weight;
    float offset;
    if (self.xIndent == 0 && self.viewType == EventViewCourse) {
        offset = widthOffsetDayView - widthClassTag;
    }
    else offset = widthOffsetDayView;
    
    [self setFrame:CGRectMake(offset + xIndent*width+1 ,heightOffset+self.startHour*heightHour, width-2, heightHour*(self.endHour-startHour))];
    self.layer.cornerRadius = 6.0;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    
    self.clearsContextBeforeDrawing = YES;
       if (self.viewType == EventViewCourse) {
        self.layer.borderColor = colorCourseBorder;
        self.backgroundColor = colorCourseBg;

        UIButton *buttonDiz = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIButton *buttonAssign = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonDiz setFrame:CGRectMake(widthClassTag+5, self.bounds.size.height-heightButton-5, widthButton, heightButton)];
        
        [buttonAssign setFrame:CGRectMake(widthClassTag+5+widthButton, self.bounds.size.height-heightButton-5, widthButton, heightButton)];
        
        buttonDiz.layer.cornerRadius = radius;
        buttonAssign.layer.cornerRadius = radius;
        buttonDiz.layer.borderColor = colorCourseBorder;
        buttonDiz.backgroundColor = colorCourseBg;
        buttonAssign.layer.borderColor = colorCourseBorder;
        buttonAssign.backgroundColor = colorCourseBg;
        buttonAssign.titleLabel.font = fontTitle;
        buttonDiz.titleLabel.font = fontTitle;
        
        buttonDiz.layer.borderWidth = 1.0;
        buttonAssign.layer.borderWidth = 1.0;
        
        [buttonAssign addTarget:self action:@selector(didHitDizButtonInEventView:) forControlEvents:UIControlEventTouchUpInside];
        
        //buttonAssign.highlighted = YES;
        
        [buttonDiz setTitle:@"讨论" forState:UIControlStateNormal];
        [buttonAssign setTitle:@"作业" forState:UIControlStateNormal];
        [self addSubview:buttonAssign];
        [self addSubview:buttonDiz];
    }
    else {
        self.layer.borderColor = colorLocalBorder;
        self.backgroundColor = colorLocalBg;
        [self addTarget:self action:@selector(didSelectSelfView) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupForWeekDisplay{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    float width = widthNormalWeekView * weight;
    [self setFrame:CGRectMake((self.numDay-1)*widthNormalWeekView +widthOffsetWeekView + xIndent*width ,heightOffset+self.startHour*heightHour, width, heightHour*(self.endHour-startHour))];
    if (self.viewType == EventViewCourse) {
        self.layer.borderColor = colorCourseBorder;
        self.backgroundColor = colorCourseBg;

    }
    else {
        self.layer.borderColor = colorLocalBorder;
        self.backgroundColor = colorLocalBg;
        [self addTarget:self action:@selector(didSelectSelfView) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (float)floatHourForDate:(NSDate *)date inDate:(NSDate *)dayDate
{
    if ([date compare:dayDate] == NSOrderedAscending) {
        return 0.0;
    }
    else if ([date compare:[dayDate dateByAddingTimeInterval:86400]] == NSOrderedDescending)
    {
        return 24.0;
    }
    NSCalendar *calender = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *component = [[[NSDateComponents alloc] init] autorelease];
    unsigned unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    component = [calender components:unitFlags fromDate:date];
    float hour = [component hour] + [component minute] / 60.0;
    return hour;
}

- (void)didHitDizButtonInEventView:(UIButton *)dizButton
{
    EventView *eventView = (EventView *)dizButton.superview;
    NSLog(@"%@",eventView.EventName);
}
@end

