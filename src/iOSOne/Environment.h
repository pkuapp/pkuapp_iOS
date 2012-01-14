/*
 *  Environment.h
 *  iOSOne
 *
 *  Created by wuhaotian on 11-6-14.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#define urlImgDean @"http://dean.pku.edu.cn/student/yanzheng.php?act=init"
#define urlLogin @"http://www.pkucada.org:8082/Server/login"

#define urlUpdateLocation @"http://www.pkucada.org:8082/Server/classroom/jsonlocation"
#define urlProfile @"http://www.pkucada.org:8082/Server/account/jsonprofile"
#define urlCourse @"http://www.pkucada.org:8082/Server/account/jsonmycourse"
#define urlClassroom [NSURL URLWithString: @"http://www.pkucada.org:8082/Server/classroom/json"]
#define urlCourseAll @"http://www.pkucada.org:8082/Server/course/all"
#define urlCourseCategory @"http://www.pkucada.org:8082/Server/course/category"

#define pathLocation [NSHomeDirectory() stringByAppendingString:@"/Documents/location.plist"]
#define pathUserPlist [NSHomeDirectory() stringByAppendingString:@"/Documents/User.plist"]

#define pathsql2 [NSHomeDirectory() stringByAppendingString:@"/Documents/coredata2.sqlite"]
#define pathSQLCore [NSHomeDirectory() stringByAppendingString:@"/Documents/coredata.sqlite"]
#define VersionReLogin 3