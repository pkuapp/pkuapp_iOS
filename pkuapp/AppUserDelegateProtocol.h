//
//  AppUserDelegateProtocol.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppUser;

@protocol AppUserDelegateProtocol <NSObject>
@property(nonatomic, weak, readonly) AppUser *appUser;
- (BOOL)authUserForAppWithUsername:(NSString *)username password:(NSString *)password deanCode:(NSString *)deanCode sessionid:(NSString *)sid error:(NSString *)stringError;
- (BOOL)refreshAppSession;
- (BOOL)isLoggedin;
- (void)updateAppUserProfile;
- (void)updateServerCourses;
- (void)logout;
- (void)showWithLoginView;
@end
