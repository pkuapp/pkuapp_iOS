/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

/*
 Thanks to Kevin Ballard for suggesting the UITextField as subview approach
 All credit to Kenny TM. Mistakes are mine. 
 To Do: Ensure that only one runs at a time -- is that possible?
 */

#import "ModalAlert.h"

@interface ModalAlertDelegate : NSObject <UIAlertViewDelegate>
{
	CFRunLoopRef currentLoop;
	NSUInteger index;
}
@property (readonly) NSUInteger index;
@end

@implementation ModalAlertDelegate
@synthesize index;

// Initialize with the supplied run loop
-(id) initWithRunLoop: (CFRunLoopRef)runLoop 
{
    self = [super init];
	if (self) currentLoop = runLoop;
	return self;
}

// User pressed button. Retrieve results
-(void) alertView: (UIAlertView*)aView clickedButtonAtIndex: (NSInteger)anIndex 
{
	index = anIndex;
	CFRunLoopStop(currentLoop);
}
@end

@implementation ModalAlert
+(NSUInteger) queryWith: (NSString *)question withMessage:(NSString *)message button1: (NSString *)button1 button2: (NSString *)button2
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:message delegate:madelegate cancelButtonTitle:button1 otherButtonTitles:button2, nil];
	[alertView show];
	
	// Wait for response
	CFRunLoopRun();
	
	// Retrieve answer
	NSUInteger answer = madelegate.index;
	[alertView release];
	[madelegate release];
	return answer;
}

+ (BOOL) ask: (NSString *) question withMessage:(NSString *)message
{
	return	([ModalAlert queryWith:question withMessage:message button1: @"No" button2: @"Yes"]);
}

+ (BOOL) confirm: (NSString *) statement withMessage:(NSString *)message
{
	return	[ModalAlert queryWith:statement withMessage:message button1: @"Cancel" button2: @"OK"];
}
@end

