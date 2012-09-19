//
//  CarreerProfile.h
//  Diablo Connect
//
//  Created by Andy Jacobs on 18/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroProfile.h"

typedef enum
{
    PlayStyleSoftcore,
    PlayStyleHardcore
} PlayStyle;



typedef enum
{
    ArtisanTypeBlacksmith,
    ArtisanTypeJeweler
} ArtisanType;




@interface CarreerProfile : NSObject

@property (nonatomic,retain) NSString *battleTag;

@property (nonatomic,retain) NSArray *heroes;
@property (nonatomic,retain) NSNumber *lastHeroPlayed;
@property (nonatomic,retain) NSNumber *lastUpdated;
@property (nonatomic,retain) NSArray *artisans;
@property (nonatomic,retain) NSDictionary *kills;
@property (nonatomic,retain) NSDictionary *timePlayed;
@property (nonatomic,retain) NSArray *progression;
@property (nonatomic,retain) NSArray *hardcoreProgression;
@property (nonatomic,retain) NSArray *fallenHeroes;
@property DiabloRegion region;


- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)carreerProfileForName:(NSString *)name andRegion:(DiabloRegion)region block:(void (^)(CarreerProfile *carreerProfile, NSError *error))block;

@end

@interface Artisan : NSObject

@property ArtisanType artisanType;
@property PlayStyle playStyle;
@property (nonatomic,retain) NSString *slug;
@property (nonatomic,retain) NSNumber *level;
@property (nonatomic,retain) NSNumber *stepCurrent;
@property (nonatomic,retain) NSNumber *stepMax;

- (id) initWithAttributes:(NSDictionary *)attributes;

@end
