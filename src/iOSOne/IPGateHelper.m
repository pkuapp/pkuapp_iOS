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
#import "AsyncUdpSocket.h"

@implementation IPGateHelper
@synthesize stringRange,delegate,request,isConnected,numberListenRetry;


#pragma mark - Listening setup

- (void)startListening
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:IPG_HEART_BEAT_INTERVAL  target:self selector:@selector(listenHeartBeat:) userInfo:@"Timer" repeats:YES]; 
    NSLog(@"StartListeningONTimer%@",timer);
}

- (void)listenHeartBeat:(NSTimer *)timer
{
    [self sendHeartBeatForHost:@"202.112.7.13" Port:7777];
    [self sendHeartBeatForHost:@"162.105.129.27" Port:7777];
}
                      
#pragma mark - ASIHttpDelegate

- (void)connectFreeFinished:(ASIHTTPRequest *)Request
{
    NSString *stringResponse = [Request responseString];
    
    if ([self connectAcceptAsExceptForResponse:stringResponse]) {
        NSDictionary *dict = [self dictSuccessForResponse:stringResponse];
        NSMutableDictionary *dictDetail =[NSMutableDictionary dictionaryWithDictionary:[stringResponse dictionaryByMatchingRegex:patternAccountDetail withKeysAndCaptures:@"Type",1,@"Time",2,@"Balance",3, nil]];
        //NSArray *array = [stringResponse captureComponentsMatchedByRegex:patternAccountDetail];
        if (![[dictDetail objectForKey:@"Type"] isEqualToString:@"未包月"]) {
            NSArray *array = [[dictDetail objectForKey:@"Type"] captureComponentsMatchedByRegex:pTime];
            //NSLog(@"%@",array);
            if (array != nil) {
                float timeAll = [[array objectAtIndex:1] floatValue];
                float timeLeft = timeAll - [[dictDetail objectForKey:@"Time"] floatValue];
                [dictDetail setObject:[NSString stringWithFormat:@"%1.2f",timeLeft] forKey:@"timeLeft"];
            }
            else
                [dictDetail setObject:@"∞" forKey:@"timeLeft"];
            
        }
        else [dictDetail setObject:@"NO" forKey:@"Type"];
        [self.delegate connectFreeSuccessWithDict:dict andDetail:dictDetail]; 
    }
    else //连接被拒绝
    {
        NSDictionary *dict = [self dictRefuseForResponse:stringResponse];
        NSString *reason = [dict objectForKey:@"REASON"];
        NSLog(@"%@",reason);
        NSRange range = [reason rangeOfString:@"超过预定值"];
        if (range.location != NSNotFound) {
            if ([self.delegate shouldReConnectWithDisconnectrequest]) {
                [self disConnect];
                [self connectFree];
            }
            else [self.delegate connectFailed:dict];
        }
        else [self.delegate connectFailed:dict];
    }
}
- (void)connectGlobalFinished:(ASIHTTPRequest *)Request
{
    NSString *stringResponse = [Request responseString];
    if ([self connectAcceptAsExceptForResponse:stringResponse]) {
        NSDictionary *dict = [self dictSuccessForResponse:stringResponse];
        NSMutableDictionary *dictDetail =[NSMutableDictionary dictionaryWithDictionary:[stringResponse dictionaryByMatchingRegex:patternAccountDetail withKeysAndCaptures:@"Type",1,@"Time",2,@"Balance",3, nil]];
        //NSArray *array = [stringResponse captureComponentsMatchedByRegex:patternAccountDetail];
        if (![[dictDetail objectForKey:@"Type"] isEqualToString:@"未包月"]) {
            NSArray *array = [[dictDetail objectForKey:@"Type"] captureComponentsMatchedByRegex:pTime];
            //NSLog(@"%@",array);
            if (array != nil) {
                float timeAll = [[array objectAtIndex:1] floatValue];
                float timeLeft = timeAll - [[dictDetail objectForKey:@"Time"] floatValue];
                [dictDetail setObject:[NSString stringWithFormat:@"%1.2f",timeLeft] forKey:@"timeLeft"];
            }
            else
                [dictDetail setObject:@"∞" forKey:@"timeLeft"];
            
        }
        else [dictDetail setObject:@"NO" forKey:@"Type"];
        [self.delegate connectGlobalSuccessWithDict:dict andDetail:dictDetail]; 
    }
    else //连接被拒绝
    {
        NSDictionary *dict = [self dictRefuseForResponse:stringResponse];
        NSString *reason = [dict objectForKey:@"REASON"];
        NSLog(@"%@",reason);
        NSRange range = [reason rangeOfString:@"超过预订值"];
        if (range.location != NSNotFound) {
            if ([self.delegate shouldReConnectWithDisconnectrequest]) {
                [self disConnect];
                [self connectGlobal];
            }
            else [self.delegate connectFailed:dict];
        }
        else [self.delegate connectFailed:dict];
    }
}
- (void)disConnectFinished:(ASIHTTPRequest *)arequest
{
    NSString *stringResponse = [arequest responseString];
    if ([self connectAcceptAsExceptForResponse:stringResponse]){
    
    [self.delegate disconnectSuccess];
    }
    else {
        NSDictionary *dict = [self dictRefuseForResponse:stringResponse];
        [self.delegate connectFailed:dict];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)arequest
{
   NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"连接超时"] forKey:@"REASON"];
    [self.delegate connectFailed:dict];
    NSLog(@"%@",[[arequest error] localizedDescription]);
}

#pragma mark - Interface Method
- (void)connectFree
{
    stringRange = @"2";
    request = [ASIHTTPRequest requestWithURL:[self urlConnect]];

    [request setValidatesSecureCertificate:NO];
    [request setShouldRedirect:NO];
    request.delegate = self;

    request.shouldAttemptPersistentConnection = NO;
    [request setDidFinishSelector:@selector(connectFreeFinished:)];
    [request startAsynchronous];
}
- (void)connectGlobal
{
    stringRange = @"1";
    request = [ASIHTTPRequest requestWithURL:[self urlConnect]];
    [request setValidatesSecureCertificate:NO];
    [request setShouldRedirect:NO];
    request.delegate = self;
    
    [request setDidFinishSelector:@selector(connectGlobalFinished:)];
    [request startAsynchronous];

}

- (void)disConnect{
    request = [ASIHTTPRequest requestWithURL:[self urlDisconnect]];
    [request setValidatesSecureCertificate:NO];
    [request setShouldRedirect:NO];
    request.delegate = self;
    [request setDidFinishSelector:@selector(disConnectFinished:)];
    [request startAsynchronous];
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
    [super dealloc];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (keyPath == @"numberListenRetry") {
        NSNumber *numberRetry = [change objectForKey:@"new"];
        if ([numberRetry intValue] >= Max_Listen_Rounds) {
            if (self.isConnected == YES) {
                self.isConnected = NO;
            }
        }
    }
    if (keyPath == @"isConnected") {
        BOOL valueNew = [[change objectForKey:@"new"] boolValue];
        if (valueNew == YES) {
            [self.delegate didConnectToIPGate];
        }
        else [self.delegate didLoseConnectToIpGate];
    }
}
#pragma mark - AsyUDPDelegate

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    self.numberListenRetry = self.numberListenRetry + 1;
    //NSLog(@"FailedSendData:%@",error);
    
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    self.numberListenRetry = self.numberListenRetry + 1;
    //NSLog(@"FailedRound:%d",self.numberListenRetry);
}
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    self.numberListenRetry = 0;
    if (self.isConnected == NO) {
        self.isConnected = YES;

    }
    //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    return YES;
}
#pragma mark - private

- (BOOL)connectAcceptAsExceptForResponse:(NSString *)stringResponse
{
    NSArray *array = [stringResponse captureComponentsMatchedByRegex:patternResponse];
    return [[array objectAtIndex:2] isEqualToString:@"YES"];
}

-(BOOL)sendHeartBeatForHost:(NSString *)host Port:(UInt16)port
{
    
    NSError *error;
    AsyncUdpSocket *socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSData *dataSend = [@"HeartBeatFromiOS" dataUsingEncoding:NSUTF8StringEncoding];
    [socket connectToHost:host onPort:port error:&error];
    
    [socket sendData:dataSend withTimeout:2 tag:102];
    [socket receiveWithTimeout:2 tag:103];
    if (error) {
        //NSLog(@"%@",error);
        return 1;
    }
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
   
    result = [Target dictionaryByMatchingRegex:patternConnectSuccess withKeysAndCaptures:@"SUCCESS",1,@"连接状态",2,@"用户名",3,@"包月",4,@"连接范围",5,@"欠费",6,@"连接数",7,@"余额",8,@"IP",9, nil];
    
   
    //result = [[responseArray objectAtIndex:1] dictionaryByMatchingRegex:patternFailure withKeysAndCaptures:@"SUCCESS",1,@"REASON",2, nil];
    
    return result;
}

-(NSDictionary *)dictDisconnectResponse:(NSString *)Target
{
    NSDictionary *result;
    NSArray* responseArray = [Target captureComponentsMatchedByRegex:patternResponse];
    NSString* success = [responseArray objectAtIndex:2];
    if ([success isEqualToString:@"YES"]) {
        result = [[responseArray objectAtIndex:1] dictionaryByMatchingRegex:patternDisconnectSuccess withKeysAndCaptures:@"SUCCESS",1,@"IP",2,@"连接数",3, nil];
    }
    else {
        result = [[[NSDictionary alloc] initWithObjectsAndKeys:@"NO",@"SUCCESS", nil] autorelease];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@?uid=%@&password=%@&timeout=2&range=%@&operation=%@",HOST,PORT,page,[self.delegate Username],[self.delegate Password],stringRange,arg]];
    return url;
 
}
-(BOOL)terminate
{
    request = [ASIHTTPRequest requestWithURL:[self urlDisconnect]];
    [request setValidatesSecureCertificate:NO];
    [request setShouldRedirect:NO];
    request.delegate = self.delegate;
    [request setDidFinishSelector:@selector(disConnectFinished:)];
    [request startSynchronous];
    return [[[self dictDisconnectResponse:[request responseString]] objectForKey:@"SUCCESS"] isEqualToString:@"YES"];

}
@end
