//
//  DiabloAPIClient.h
//  Diablo Connect
//
//  Created by Andy Jacobs on 18/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import "AFHTTPClient.h"

typedef enum
{
    DiabloGradeBasic,
    DiabloGradeFull
} DiabloGrade;

typedef enum
{
    DiabloRegionEU,
    DiabloRegionAmericas,
    DiabloRegionKR,
    DiabloRegionTW,
} DiabloRegion;

extern NSString * const kDiabloAPIBaseURLString;

@interface DiabloAPIClient : AFHTTPClient
{
    DiabloRegion _currentRegion;
}

@property DiabloRegion currentRegion;

+ (DiabloAPIClient *)sharedClient;

- (NSURLRequest *) URLRequestForBlacksmith;
- (NSURLRequest *) URLRequestForJeweler;

- (NSURLRequest *) URLRequestforItem:(NSString *)path;



- (void) changeRegion:(DiabloRegion)region;
- (NSURL *) APIDomain;
+ (NSString *) domainCodeForRegion:(DiabloRegion)region;

@end
