//
//  IPGateHelper.h
//  IPGateForMac
//
//  Created by wuhaotian on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "AsyncUdpSocket.h"

#define Max_Listen_Rounds 4
#define PORT @"5428"
#define HOST @"https://its.pku.edu.cn"
#define page @"/ipgatewayofpku"
#define rangeFree @"2"
#define rangeGlobal @"1"
#define IPG_HEART_BEAT_INTERVAL 3
#define IPG_HeartBeatServer
#define patternResponse @"<!--IPGWCLIENT_START.+(SUCCESS=([^ ]+).+)IPGWCLIENT_END-->"
#define patternFailure @"SUCCESS=([^ ]+).+REASON=([^ ]+).+"
#define patternConnectSuccess @"SUCCESS=([^ ]+) STATE=([^ ]+) USERNAME=([^ ]+) FIXRATE=([^ ]+) SCOPE=([^ ]+) DEFICIT=([^ ]+) CONNECTIONS=([^ ]+) BALANCE=([^ ]+) IP=([^ ]+) MESSAGE=(.+)"
#define patternDisconnectSuccess @"SUCCESS=([^ ]+) IP=([^ ]+) CONNECTIONS=([^ ]+)"
#define patternAccountDetail @"包月状态：</td><td>([^ ]+?)<[^#]+?([0-9.]+)小时[^#]+>([0-9.]+)"
#define pTime @"([0-9]+)小时"

@protocol IPGateListenDelegate <NSObject>

- (void)didConnectToIPGate;
- (void)didLoseConnectToIpGate;

@end

@protocol IPGateConnectDelegate <NSObject>

@required
- (NSString*)Username;
- (NSString*)Password;
- (void)connectFreeSuccessWithDict:(NSDictionary *)dict andDetail:(NSDictionary *)dictDetail;
- (void)connectGlobalSuccessWithDict:(NSDictionary *)dict andDetail:(NSDictionary *)dictDetail;
;
- (void)disconnectSuccess;
- (void)connectFailed:(NSDictionary *)dict;

- (BOOL)shouldReConnectWithDisconnectrequest;
@end

@interface IPGateHelper : NSObject<AsyncUdpSocketDelegate> {
@private
    NSObject <IPGateConnectDelegate> *delegate;
    NSString *stirngRange;
    BOOL isConnected;
}
@property (assign) NSString *stringRange;
@property (assign) id<IPGateConnectDelegate> delegate;
@property (retain, nonatomic)ASIHTTPRequest* request;
@property BOOL isConnected;
@property NSInteger numberListenRetry;
- (void)connectFree;
- (void)connectFreeFinished:(ASIHTTPRequest *)Request;

- (void)connectGlobal;
- (void)connectGlobalFinished:(ASIHTTPRequest *)Request;
- (void)disConnect;
- (void)startListening;
- (NSDictionary *)dictSuccessForResponse:(NSString*) Target;
- (NSDictionary *)dictDisconnectResponse:(NSString*) Target;
- (NSDictionary *)dictRefuseForResponse:(NSString*)Target;

- (BOOL)connectAcceptAsExceptForResponse:(NSString *)stringResponse;

- (NSURL* )urlConnect;
- (NSURL* )urlDisconnect;
- (NSURL* )urlWithOperation:(NSString* )arg;
- (BOOL)terminate;
- (BOOL)sendHeartBeatForHost:(NSString *)host Port:(UInt16)port;
@end

