//
//  CalendarGroudView.h
//  iOSOne
//
//  Created by wuhaotian on 11-7-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

//  This file define CalendarWeekGroundView,CalendarDayGroundView ANNND EventView
//  1. CalendarWeekGroundView is the ground in the scroll view for week display and *DayGroundView for day display. They both inherits CalendarGroundView to share its drawing code.

#import <Foundation/Foundation.h>
@class EKEvent;
#pragma mark - appearance params

#define heightHour 48.0
#define widthHourTag 35
#define heightWeekNumber 20.0
#define heightOffset 24.0
#define widthOffset 5.0
#define widthColumn   (320.0 - widthHourTag) / 7

#define heightTotal   (24 * heightHour + heightOffset *2)
#define widthTotal   (widthColumn *7 + widthHourTag)

#define sizeFont 14.0
#define colorCourseBorder [UIColorFromRGB(0x3265B2) CGColor]
#define colorCourseBg UIColorFromRGB(0x3886CF)

#define colorLocalBorder [UIColorFromRGB(0x7A52BA) CGColor]
#define colorLocalBg UIColorFromRGB(0x9581E3)

#define fontNameHourTag @"HelveticaNeue-Bold" //Neue-CondensedBold
#define fontNameClassTag @"HelveticaNeue-Bold"
#define fontTitle [UIFont fontWithName:@"Helvetica-Bold" size:12]
#define sizeFontHourTag 10
#define fontHourTag [UIFont fontWithName:fontNameHourTag size:sizeFontHourTag]
//define For DayView
#define heightClassTag (heightHour * 5/6.0)
#define widthClassTag 14
#define colorClassTag UIColorFromRGB(0xC8E8FA)
#define colorClassTaBg UIColorFromRGB(0xE0F4FF)
#define widthOffsetDayView  widthHourTag + widthClassTag
#define widthNormalDayView  (320.0 - widthOffsetDayView-14)

//define For WeekView
#define widthNormalWeekView (320.0 - widthHourTag) / 7
#define widthOffsetWeekView widthHourTag + widthClassTag
#define fontTitleWeek [UIFont fontWithName:@"Helvetica-Bold" size:10]

//定义课程按钮外观
#define yOffsetAboveBottom 5
#define widthButton 60
#define heightButton 30
#define radius 5.0

typedef enum{
    CalendarGroundTypeDay,
    CalendarGroundTypeWeek,
}CalendarGroundType;

typedef enum {
    EventViewCourse,
    EventViewNone
    
}EventViewType;

#pragma mark - CalendarGroundView defination

@interface CalendarGroundView : UIView {
@private
    
}
-(void)drawInContext:(CGContextRef)context;
-(void)setupForDisplay;
@end

@interface CalendarWeekGroundView : CalendarGroundView {
    
}

-(void)drawInContext:(CGContextRef)context;
@end



@interface CalendarDayGroundView : CalendarGroundView {
@private
    
}
-(void)drawInContext:(CGContextRef)context;
@end

@protocol EventViewDelegate <NSObject>

- (void) didSelectCourseForIndex:(NSInteger)index;
- (void) didSelectEKEventForIndex:(NSInteger)index;
- (void) didSelectDizBtnForCourseIndex:(NSInteger)index;
- (void) didSelectAssignBtnForCourseIndex:(NSInteger)index;

@end

#pragma mark - EventView defination

@interface EventView : UIControl {
    
}

@property (nonatomic, assign) NSObject<EventViewDelegate> *delegate;
@property (nonatomic, retain)NSString *EventName;
@property (nonatomic, retain)NSString *stringLocation;
@property (nonatomic)NSInteger objIndex;
@property (nonatomic) float startHour;
@property (nonatomic) float endHour;
@property (nonatomic) float weight;
@property (nonatomic) NSInteger xIndent;
@property (nonatomic) CalendarGroundType groundType;
@property (nonatomic) EventViewType viewType;
@property (nonatomic) NSInteger numDay;
@property (nonatomic) NSInteger identifier;

-(id) initWithDict:(NSDictionary *)dict ForGroundType:(CalendarGroundType)thegroundType ViewType:(EventViewType) theViewType;

-(void) drawInWeekContext:(CGContextRef)context;

-(void) drawInDayContext:(CGContextRef)context;

- (id)initWithEKEvent:(EKEvent *)event ForGroudType:(CalendarGroundType)thegroundType inDate:(NSDate *)date;

- (void)setupForDayDisplay;

- (void)setupForWeekDisplay;

- (float)floatHourForDate:(NSDate *)date inDate:(NSDate*)dayDate;

- (void)didHitDizButtonInEventView:(UIButton *)dizButton;
//
- (void)didSelectSelfView;

@end