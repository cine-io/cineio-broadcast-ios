//
//  arenacloud_broadcast_iosTests.m
//  broadcast-iosTests
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCTAsyncTestCase/XCTAsyncTestCase.h>
#import <OHHTTPStubs.h>
#import "ACBRClient.h"

const NSString *StreamName = @"my stream";

@interface arenacloud_broadcast_iosTests : XCTAsyncTestCase
{
    ACBRClient *_client;
    __block ACBRStream *_stream;
}
@end

@implementation arenacloud_broadcast_iosTests

- (void)setUp
{
    [super setUp];
    
    _client = [[ACBRClient alloc] init];
    _client.masterKey = @"IGNORE";
    _client.projectSecretKey = @"IGNORE";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (NSString *)jsonPathForResource:(NSString *)resourceName
{
    return [[NSBundle bundleForClass:[self class]] pathForResource:resourceName ofType:@"json"];
}

- (void)stubAPICall:(NSString *)url forHTTPMethod:(NSString *)method withContentsOfJSONResource:(NSString *)resourceName
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return ([request.URL.absoluteString rangeOfString:url].location != NSNotFound &&
                [request.HTTPMethod isEqualToString:method]);
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:[self jsonPathForResource:resourceName]
                                                statusCode:200 headers:@{@"Content-Type":@"text/json"}];
    }];
}

- (void)createStream
{
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/stream" forHTTPMethod:@"POST" withContentsOfJSONResource:@"createStream"];
    [_client createStream:@{ @"name" : StreamName, @"record" : @"true" }
    withCompletionHandler:^(NSError* error, ACBRStream* stream) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssertEqualObjects(stream.name, StreamName);
            _stream = stream;
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetProjects
{
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/projects" forHTTPMethod:@"GET" withContentsOfJSONResource:@"getProjects"];
    [_client getProjectsWithCompletionHandler:^(NSError *error, NSArray *projects) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssert([projects count] > 0);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetProject
{
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/project" forHTTPMethod:@"GET" withContentsOfJSONResource:@"getProject"];
    [_client getProjectWithCompletionHandler:^(NSError *error, ACBRProject *project) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssertNotNil(project);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testCreateStream
{
    [self createStream];
    XCTAssertNotNil(_stream);
    XCTAssertEqualObjects(_stream.name, StreamName);
    XCTAssertEqual(_stream.record, YES);
}

- (void)testGetAllStreams
{
    [self createStream];
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/streams" forHTTPMethod:@"GET" withContentsOfJSONResource:@"getAllStreams"];
    [_client getStreamsWithCompletionHandler:^(NSError *error, NSArray *streams) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssert(streams.count > 0);
            BOOL found = false;
            for (ACBRStream *stream in streams) {
                found = found || ([stream.streamId isEqualToString:_stream.streamId]);
            }
            XCTAssert(found);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetNamedStreams
{
    [self createStream];
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/streams" forHTTPMethod:@"GET" withContentsOfJSONResource:@"getNamedStreams"];
    [_client getStreamsForName:(NSString *)StreamName withCompletionHandler:^(NSError *error, NSArray *streams) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssert(streams.count > 0);
            BOOL found = false;
            for (ACBRStream *stream in streams) {
                found = found || ([stream.streamId isEqualToString:_stream.streamId]);
            }
            XCTAssert(found);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetStream
{
    [self createStream];
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/stream" forHTTPMethod:@"GET" withContentsOfJSONResource:@"getStream"];
    [_client getStream:_stream.streamId withCompletionHandler:^(NSError *error, ACBRStream *stream) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssertEqualObjects(stream.streamId, _stream.streamId);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testUpdateStream
{
    [self createStream];
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/stream" forHTTPMethod:@"PUT" withContentsOfJSONResource:@"updateStream"];
    [_client updateStream:@{ @"id" : _stream.streamId, @"name" : @"my other stream" } withCompletionHandler:^(NSError *error, ACBRStream *stream) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssertEqualObjects(stream.name, @"my other stream");
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testDeleteStream
{
    [self createStream];
    [self prepare];
    [self stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/stream" forHTTPMethod:@"DELETE" withContentsOfJSONResource:@"deleteStream"];
    [_client deleteStream:_stream.streamId withCompletionHandler:^(NSError *error, NSHTTPURLResponse *response) {
        if (error || response.statusCode != 200) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetStreamRecordings
{
    [self createStream];
    [self prepare];
    [self            stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/stream/recordings"
                   forHTTPMethod:@"GET"
      withContentsOfJSONResource:@"getStreamRecordings"];
    [_client getStreamRecordings:_stream.streamId withCompletionHandler:^(NSError *error, NSArray *recordings) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssertTrue([recordings count] > 0);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
   [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0];
}

- (void)testDeleteStreamRecording
{
    [self createStream];
    [self prepare];
    [self            stubAPICall:@"https://api.arenacloud.com/broadcast/1/-/stream/recording"
                   forHTTPMethod:@"DELETE"
      withContentsOfJSONResource:@"deleteStreamRecording"];
    [_client deleteStreamRecording:_stream.streamId withName:@"lJ76m4sfXx.3.mp4" andCompletionHandler:^(NSError *error, NSHTTPURLResponse *response) {
        XCTAssertNil(error);
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

@end
