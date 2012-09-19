//
//  DiabloAPIClient.m
//  Diablo Connect
//
//  Created by Andy Jacobs on 18/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import "DiabloAPIClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kDiabloAPIBaseURLString = @"http://%@.battle.net/api/d3/";
//NSString * const kDiabloAPIBaseURLString = @"http://diablo.revolver.be/api/d3/";

@implementation DiabloAPIClient

@synthesize currentRegion = _currentRegion;

+ (DiabloAPIClient *)sharedClient {
    static DiabloAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DiabloAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kDiabloAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (void) changeRegion:(DiabloRegion)region
{
    _currentRegion = region;
    self.baseURL = [self APIDomain];
}

- (NSURLRequest *) URLRequestForBlacksmith
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@data/artisan/blacksmith",[self APIDomain]]]];
}

- (NSURLRequest *) URLRequestForJeweler
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@data/artisan/jeweler",[self APIDomain]]]];
}

- (NSURLRequest *) URLRequestforItem:(NSString *)path
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self APIDomain],path]]];

}
- (NSURL *) APIDomain
{
    NSString *domainString = [NSString stringWithFormat:kDiabloAPIBaseURLString,[DiabloAPIClient domainCodeForRegion:_currentRegion]];
    return [NSURL URLWithString:domainString];
}
+ (NSString *) domainCodeForRegion:(DiabloRegion)region
{
    NSString *domainCode = @"";
    switch (region) {
        case DiabloRegionAmericas:
        {
            domainCode = @"US";
            break;
        }
        case DiabloRegionEU:
        {
            domainCode = @"EU";
            break;
        }
        case DiabloRegionKR:
        {
            domainCode = @"KR";
            break;
        }
        case DiabloRegionTW:
        {
            domainCode = @"TW";
            break;
        }
        default:
            break;
    }
    return domainCode;
}

@end