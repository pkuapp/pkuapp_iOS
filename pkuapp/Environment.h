/*
 *  Environment.h
 *  iOSOne
 *
 *  Created by wuhaotian on 11-6-14.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#define iOSVersionNum 90
#define url_iOS_version @"http://www.pkucada.org:8082/Server/app/iOS_version"

#define urlImgDean @"http://dean.pku.edu.cn/student/yanzheng.php?act=init"
#define urlImgEle @"http://elective.pku.edu.cn/elective2008/DrawServlet?Rand=1898"

#define urlLoginDean @"http://www.pkucada.org:8082/Server/login"
#define urlLoginEle @"http://www.pkucada.org:8082/Server/login_elective"

#define urlUpdateLocation @"http://www.pkucada.org:8082/Server/classroom/jsonlocation"
#define urlProfile @"http://www.pkucada.org:8082/Server/account/jsonprofile"
#define urlCourse @"http://www.pkucada.org:8082/Server/account/jsonmycourse"
#define urlClassroom [NSURL URLWithString: @"http://www.pkucada.org:8082/Server/classroom/json"]
#define urlCourseAll @"http://www.pkucada.org:8082/Server/course/all"
#define urlCourseCategory @"http://www.pkucada.org:8082/Server/course/category"

#define pathLocation [NSHomeDirectory() stringByAppendingString:@"/Documents/location.plist"]
#define pathUserPlist [NSHomeDirectory() stringByAppendingString:@"/Documents/User.plist"]
#define pathClassroomQueryCache [NSHomeDirectory() stringByAppendingString:@"/Documents/ClassroomQueryCache.plist"]
#define pathsql2 [NSHomeDirectory() stringByAppendingString:@"/Documents/coredata2.sqlite"]
#define pathSQLCore [NSHomeDirectory() stringByAppendingString:@"/Documents/coredata.sqlite"]
#define VersionReLogin 3
//Global Color here. Will move to other place in future build
#define navigationBgColor nil //[[UIColor alloc] initWithRed:228/255.0 green:231/255.0 blue:233/255.0 alpha:1.0]


#define tableBgColor [[UIColor alloc] initWithRed:239/255.0 green:234/255.0 blue:222/255.0 alpha:1.0]
#define navBarBgColor [[UIColor alloc] initWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0]


///////////////////////////////
#define test_username @"pkttus#42$"
