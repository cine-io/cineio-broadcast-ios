//
//  cineio_iosTests.m
//  cineio-iosTests
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCTAsyncTestCase/XCTAsyncTestCase.h>
#import "CineClient.h"

const NSString *StreamName = @"my stream";

@interface cineio_iosTests : XCTAsyncTestCase
{
    CineClient *_client;
    __block CineStream *_stream;
}
@end

@implementation cineio_iosTests

- (void)setUp
{
    [super setUp];
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    _client = [[CineClient alloc] init];
    _client.masterKey = settings[@"CINE_IO_ACCOUNT_MASTER_KEY"];
    _client.projectSecretKey = settings[@"CINE_IO_PROJECT_SECRET_KEY"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)createStream
{
    [self prepare];
    [_client createStream:@{ @"name" : StreamName, @"record" : @"true" }
    withCompletionHandler:^(NSError* error, CineStream* stream) {
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
    [_client getProjectWithCompletionHandler:^(NSError *error, CineProject *project) {
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

- (void)testGetStream
{
    [self createStream];
    [self prepare];
    [_client getStream:_stream.streamId withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssertEqualObjects(stream.streamId, _stream.streamId);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetNamedStreams
{
    [self createStream];
    [self prepare];
    [_client getStreamsForName:(NSString *)StreamName withCompletionHandler:^(NSError *error, NSArray *streams) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssert(streams.count > 0);
            BOOL found = false;
            for (CineStream *stream in streams) {
                found = found || ([stream.streamId isEqualToString:_stream.streamId]);
            }
            XCTAssert(found);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetAllStreams
{
    [self createStream];
    [self prepare];
    [_client getStreamsWithCompletionHandler:^(NSError *error, NSArray *streams) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssert(streams.count > 0);
            BOOL found = false;
            for (CineStream *stream in streams) {
                found = found || ([stream.streamId isEqualToString:_stream.streamId]);
            }
            XCTAssert(found);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)testUpdateStream
{
    [self createStream];
    [self prepare];
    [_client updateStream:@{ @"id" : _stream.streamId, @"name" : @"my other stream" } withCompletionHandler:^(NSError *error, CineStream *stream) {
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
    [_client getStreamRecordings:_stream.streamId withCompletionHandler:^(NSError *error, NSArray *recordings) {
        if (error) {
            [self notify:kXCTUnitWaitStatusFailure];
        } else {
            XCTAssertEqual([recordings count], 0);
            [self notify:kXCTUnitWaitStatusSuccess];
        }
    }];
   [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0];
}

- (void)testDeleteStreamRecording
{
    // since we're using a newly-created stream, we'll just make sure the endpoint exists
    // and test for the negative case
    [self createStream];
    [self prepare];
    [_client deleteStreamRecording:_stream.streamId withName:@"_SOME_123_NOT_VALID_NAME_456_" andCompletionHandler:^(NSError *error, NSHTTPURLResponse *response) {
        XCTAssertNotNil(error);
        XCTAssertTrue([[error localizedDescription] rangeOfString:@"not found (404)"].location != NSNotFound);
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

@end
