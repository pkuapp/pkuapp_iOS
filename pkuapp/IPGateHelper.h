//
//  IPGateHelper.h
//  IPGateForMac
//
//  Created by wuhaotian on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation+ASIHTTPRequest.h"
//#import "AsyncUdpSocket.h"

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

typedef enum IPGateConnectError{
    IPGateErrorTimeout, 
    IPGateErrorOverCount, // 超过连接数
    IPGateErrorNotPermitted,
    IPGateErrorLimitted,
    //
    IPGateErrorUnknown,
    IPGateErrorRawReason
    
}IPGateConnectError;

typedef enum IPGateConnectingStatus{
    IPGateConnectingFree,
    IPGateConnectingGlobal,
    IPGateDisconnecting,
    IPGateConnectPending
}IPGateConnectingStatus;

typedef enum IPGateResult{
    IPGateResultNone,
    IPGateResultFree,
    IPGateResultGlobal,
}IPGateResult;

@protocol IPGateListenDelegate <NSObject>

- (void)didConnectToIPGate;
- (void)didLoseConnectToIpGate;

@end

@protocol IPGateConnectDelegate <NSObject>

@required
- (NSString*)Username;
- (NSString*)Password;
- (void)connectFreeSuccess;
- (void)connectGlobalSuccess;
- (void)disconnectSuccess;
- (void)connectFailed;

@end

@interface IPGateHelper : NSObject<ASIHTTPRequestDelegate> {
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
@property (assign, atomic) IPGateConnectError error;
@property (assign, atomic) IPGateConnectingStatus connectingStatus;
@property (assign, atomic) IPGateResult connectionResult;
@property (retain, atomic) NSDictionary *dictResult;
@property (retain, atomic) NSDictionary *dictDetail;


- (void)connectFree;

- (void)connectGlobal;
- (void)disConnect;
- (void)startListening;
- (void)reConnect;

@end

