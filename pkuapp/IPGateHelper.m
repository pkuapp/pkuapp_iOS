//
//  IPGateHelper.m
//  IPGateForMac
//
//  Created by wuhaotian on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "IPGateHelper.h"
#import "RegexKitLite.h"
#import "ASIHTTPRequest.h"
#import "AFNetworking.h"

@interface IPGateHelper (Private)
- (BOOL)connectionSucceed:(NSString *)stringResponse;

- (NSDictionary *)dictSuccessForResponse:(NSString*) Target;
- (NSDictionary *)dictDisconnectResponse:(NSString*) Target;
- (NSDictionary *)dictRefuseForResponse:(NSString*)Target;

- (void)connectFreeFinished:(ASIHTTPRequest *)Request;
- (void)connectGlobalFinished:(ASIHTTPRequest *)Request;

- (NSURL* )urlConnect;
- (NSURL* )urlDisconnect;
- (NSURL* )urlWithOperation:(NSString* )arg;
- (BOOL)terminate;
- (BOOL)sendHeartBeatForHost:(NSString *)host Port:(UInt16)port;
- (BOOL)connectAcceptAsExceptForResponse:(NSString *)stringResponse;
@end

@implementation IPGateHelper
@synthesize stringRange,delegate,request = _request;
@synthesize isConnected,numberListenRetry;
@synthesize error = _error;
@synthesize connectingStatus = _status;
@synthesize connectionResult = _result;
@synthesize dictResult = _dictResult;
@synthesize dictDetail = _dictDetail;

#pragma mark - Listening setup

- (void)startListening
{
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:IPG_HEART_BEAT_INTERVAL  target:self selector:@selector(listenHeartBeat:) userInfo:@"Timer" repeats:YES]; 
//    NSLog(@"StartListeningONTimer%@",timer);
}

- (void)listenHeartBeat:(NSTimer *)timer
{   
    [self sendHeartBeatForHost:@"202.112.7.13" Port:7777];
    [self sendHeartBeatForHost:@"162.105.129.27" Port:7777];
}

- (BOOL)connectionSucceed:(NSString *)stringResponse {
    
    BOOL _succeeded = [self connectAcceptAsExceptForResponse:stringResponse];
    
    if (_succeeded) {
        
        NSDictionary *dict = [self dictSuccessForResponse:stringResponse];
        
        self.dictResult = dict;
        
        NSMutableDictionary *dictDetail =[NSMutableDictionary dictionaryWithDictionary:[stringResponse dictionaryByMatchingRegex:patternAccountDetail withKeysAndCaptures:@"Type",1,@"Time",2,@"Balance",3, nil]];
        if (dictDetail.allKeys.count == 0) {
            dictDetail = [NSMutableDictionary dictionaryWithDictionary:[stringResponse dictionaryByMatchingRegex:patternAccountFree withKeysAndCaptures:@"Type",1, @"Balance",2, nil]];
        }
        
        if (![dictDetail[@"Type"] isEqualToString:@"未包月"]) {
            
            NSArray *array = [dictDetail[@"Type"] captureComponentsMatchedByRegex:pTime];
            
            if (array != nil) {
                
                float timeAll = [array[1] floatValue];
                
                float timeLeft = timeAll - [dictDetail[@"Time"] floatValue];
                dictDetail[@"timeLeft"] = [NSString stringWithFormat:@"包月剩余%1.2f小时",timeLeft];
            }
            else
                dictDetail[@"timeLeft"] = @"不限时";
            
        }
        else dictDetail[@"Type"] = @"NO";
        
        self.dictDetail = dictDetail;
        
        return YES;
    }
    else {
        NSDictionary *dict = [self dictRefuseForResponse:stringResponse];
        self.dictResult = dict;
        NSString *reason = dict[@"REASON"];
        
        NSLog(@"%@",reason);
        
        NSRange range = [reason rangeOfString:@"超过预定值"];
        if (range.location != NSNotFound) {
            self.error = IPGateErrorOverCount;
        }
        else self.error = IPGateErrorRawReason;

    }
    return NO;
}

#pragma mark - Interface Method
- (void)reConnect {
//    _request = [ASIHTTPRequest requestWithURL:[self urlDisconnect]];
//    [_request setValidatesSecureCertificate:NO];
//    [_request setShouldRedirect:NO];
//    _request.delegate = self;
//    [_request startSynchronous];
//    
    
    switch (_status) {
        case IPGateConnectingFree:
            [self connectFree];
            break;
            
        case IPGateConnectingGlobal:
            [self connectGlobal];
            break;
            
        default:
            break;
    }
    
}

- (void)connectFree
{
    _status = IPGateConnectingFree;
    stringRange = @"2";
//    _request = [ASIHTTPRequest requestWithURL:[self urlConnect]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self urlConnect]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __weak IPGateHelper *weak = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
//        NSString *text = [NSString stringwith]
        if ([weak connectionSucceed:operation.responseString]) {
            
            if ([weak connectionSucceed:operation.responseString]) {
                [weak.delegate connectFreeSuccess];
            }
            else [weak.delegate connectFailed];
        }
        else [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weak.delegate connectFailed];
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [weak.delegate connectFailed];
        }];
    }];
    [operation start];
}
- (void)connectGlobal
{
    
    
    _status = IPGateConnectingGlobal;
    
    stringRange = @"1";
    NSURLRequest *request = [NSURLRequest requestWithURL:[self urlConnect]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __weak IPGateHelper *weak = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        if ([weak connectionSucceed:operation.responseString]) {
            
            if ([weak connectionSucceed:operation.responseString]) {
                
                [weak.delegate connectGlobalSuccess];
            }
            else [weak.delegate connectFailed];
        }
        else [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weak.delegate connectFailed];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [weak.delegate connectFailed];
        }];
    }];
    [operation start];

}

- (void)disConnect{

    NSURLRequest *request = [NSURLRequest requestWithURL:[self urlDisconnect]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __weak IPGateHelper *weak = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        
        NSString *stringResponse = [operation responseString];
        
        if ([weak connectAcceptAsExceptForResponse:stringResponse]){
            
            [weak.delegate disconnectSuccess];
            
        }
        else {
            
            NSDictionary *dict = [weak dictRefuseForResponse:stringResponse];
            
            weak.dictResult = dict;
            
            weak.error = IPGateErrorUnknown;
            
            [weak.delegate connectFailed];
        }

       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [weak.delegate connectFailed];
        }];
    }];
    [operation start];
}

#pragma mark - lifecycle method setup 
- (id)init
{
    self = [super init];
    if (self) {
        stringRange = @"2";
        self.isConnected = NO;
        self.numberListenRetry = 0;
        [self addObserver:self forKeyPath:@"numberListenRetry" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"numberListenRetry"];
    [self removeObserver:self forKeyPath:@"isConnected"];
}

#pragma mark - KVO
//
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (keyPath == @"numberListenRetry") {
//        NSNumber *numberRetry = [change objectForKey:@"new"];
//        if ([numberRetry intValue] >= Max_Listen_Rounds) {
//            if (self.isConnected == YES) {
//                self.isConnected = NO;
//            }
//        }
//    }
//    if (keyPath == @"isConnected") {
//        BOOL valueNew = [[change objectForKey:@"new"] boolValue];
//        if (valueNew == YES) {
//            [self.delegate didConnectToIPGate];
//        }
//        else [self.delegate didLoseConnectToIpGate];
//    }
//}
#pragma mark - AsyUDPDelegate
//
//-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
//{
//    self.numberListenRetry = self.numberListenRetry + 1;
//    //NSLog(@"FailedSendData:%@",error);
//    
//}
//
//-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
//{
//    self.numberListenRetry = self.numberListenRetry + 1;
//    //NSLog(@"FailedRound:%d",self.numberListenRetry);
//}
//-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
//{
//    self.numberListenRetry = 0;
//    if (self.isConnected == NO) {
//        self.isConnected = YES;
//
//    }
//    //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    return YES;
//}
#pragma mark - private

- (BOOL)connectAcceptAsExceptForResponse:(NSString *)stringResponse
{
    NSArray *array = [stringResponse captureComponentsMatchedByRegex:patternResponse];
    return [array[2] isEqualToString:@"YES"];
}

-(BOOL)sendHeartBeatForHost:(NSString *)host Port:(UInt16)port
{
    
//    NSError *error;
//    AsyncUdpSocket *socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
//    NSData *dataSend = [@"HeartBeatFromiOS" dataUsingEncoding:NSUTF8StringEncoding];
//    [socket connectToHost:host onPort:port error:&error];
//    
//    [socket sendData:dataSend withTimeout:2 tag:102];
//    [socket receiveWithTimeout:2 tag:103];
//    if (error) {
//        //NSLog(@"%@",error);
//        return 1;
//    }
    return 0;
}

- (NSDictionary *)dictRefuseForResponse:(NSString*)Target;
{
    NSDictionary *dict = [Target dictionaryByMatchingRegex:patternFailure withKeysAndCaptures:@"REASON",2, nil];
    return dict;
}

-(NSDictionary *)dictSuccessForResponse:(NSString*) Target
{
    NSDictionary *result;
   
    result = [Target dictionaryByMatchingRegex:patternConnectSuccess withKeysAndCaptures:@"SUCCESS",1,@"连接状态",2,@"用户名",3,@"包月",4,@"连接范围",5,@"余额",6,@"IP",7, nil];
    
   
    //result = [[responseArray objectAtIndex:1] dictionaryByMatchingRegex:patternFailure withKeysAndCaptures:@"SUCCESS",1,@"REASON",2, nil];
    return result;
}

-(NSDictionary *)dictDisconnectResponse:(NSString *)Target
{
    NSDictionary *result;
    NSArray* responseArray = [Target captureComponentsMatchedByRegex:patternResponse];
    NSString* success = responseArray[2];
    if ([success isEqualToString:@"YES"]) {
        result = [responseArray[1] dictionaryByMatchingRegex:patternDisconnectSuccess withKeysAndCaptures:@"SUCCESS",1,@"IP",2,@"连接数",3, nil];
    }
    else {
        result = @{@"SUCCESS": @"NO"};
    }
    return result;
}

- (NSURL* )urlConnect  
{
    return [self urlWithOperation:@"connect"];
}

- (NSURL* )urlDisconnect
{
    return [self urlWithOperation:@"disconnectall"];
}
- (NSURL* )urlWithOperation:(NSString* )arg
{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@?uid=%@&password=%@&timeout=2&range=%@&operation=%@",HOST,PORT,ippage,[self.delegate Username],[self.delegate Password],stringRange,arg]];
    return url;
 
}
-(BOOL)terminate
{
    _request = [ASIHTTPRequest requestWithURL:[self urlDisconnect]];
    [_request setValidatesSecureCertificate:NO];
    [_request setShouldRedirect:NO];
    _request.delegate = self.delegate;
    [_request setDidFinishSelector:@selector(disConnectFinished:)];
    [_request startSynchronous];
    return [[self dictDisconnectResponse:[_request responseString]][@"SUCCESS"] isEqualToString:@"YES"];

}
@end
