//
//  CarreerProfile.m
//  Diablo Connect
//
//  Created by Andy Jacobs on 18/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import "CarreerProfile.h"
#import "HeroProfile.h"
#import "DiabloAPIClient.h"

@interface CarreerProfile (private)
- (NSArray *) addHeroes:(NSDictionary *)dict;
@end

@implementation CarreerProfile
{
@private
    NSString        *_battleTag;
    DiabloRegion    _region;
    
    NSArray         *_heroes;
    NSNumber        *_lastHeroPlayed;
    NSNumber        *_lastUpdated;
    NSArray         *_artisans;
    NSDictionary    *_kills;
    NSDictionary    *_timePlayed;
    NSArray         *_progression;
    NSArray         *_hardcoreProgression;
    NSArray         *_fallenHeroes;
}
@synthesize battleTag = _battleTag;

@synthesize heroes = _heroes;
@synthesize lastHeroPlayed = _lastHeroPlayed;
@synthesize lastUpdated = _lastUpdated;
@synthesize artisans = _artisans;
@synthesize kills = _kills;
@synthesize timePlayed = _timePlayed;
@synthesize progression = _progression;
@synthesize hardcoreProgression = _hardcoreProgression;
@synthesize fallenHeroes = _fallenHeroes;
@synthesize region = _region;

- (void) dealloc
{
    [_battleTag release], _battleTag = nil;
    [_heroes release], _heroes = nil;
    [_lastHeroPlayed release], _lastHeroPlayed = nil;
    [_lastUpdated release], _lastUpdated = nil;
    [_artisans release], _artisans = nil;
    [_kills release], _kills = nil;
    [_timePlayed release], _timePlayed = nil;
    [_progression release], _progression = nil;
    [_hardcoreProgression release], _hardcoreProgression = nil;
    [_fallenHeroes release], _fallenHeroes = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        
        self.heroes         = [self addHeroes:[attributes objectForKey:@"heroes"]];
        self.lastHeroPlayed = [attributes objectForKey:@"lastHeroPlayed"];
        self.lastUpdated    = [attributes objectForKey:@"lastUpdated"];
        self.kills          = [attributes objectForKey:@"kills"];
        self.timePlayed     = [attributes objectForKey:@"timePlayed"];
        
        NSMutableArray *artisans = [NSMutableArray array];
        // parse softcore artisans
        for ( NSDictionary *artisanDict in [attributes objectForKey:@"artisans"] )
        {
            if( [[artisanDict objectForKey:@"level"] intValue] > 0 )
            {
                
                Artisan *artisan = [[Artisan alloc] initWithAttributes:artisanDict];
                artisan.playStyle = PlayStyleSoftcore;
                [artisans addObject:artisan];
                [artisan release], artisan = nil;
            }
        }
        // parse hardcore artisans
        for ( NSDictionary *artisanDict in [attributes objectForKey:@"hardcoreArtisans"] )
        {
            Artisan *artisan = [[Artisan alloc] initWithAttributes:artisanDict];
            artisan.playStyle = PlayStyleHardcore;
            [artisans addObject:artisan];
            [artisan release], artisan = nil;
        }
        
        
        self.artisans = [NSArray arrayWithArray:artisans];
        
        
        NSMutableArray *fallenHeroes = [NSMutableArray array];
        // parse fallen heroes
        for ( NSDictionary *fallenHeroDict in [attributes objectForKey:@"fallenHeroes"] )
        {
            HeroProfile *fallenHero = [[HeroProfile alloc] init];
            [fallenHero addDataWithAttributes:fallenHeroDict];
            [fallenHeroes addObject:fallenHero];
            [fallenHero release], fallenHero = nil;
        }
        
        self.fallenHeroes = [NSArray arrayWithArray:fallenHeroes];
        
        
        NSMutableArray *quests = [NSMutableArray array];
        //parse quests
        for ( NSString *difficultyKey in [attributes objectForKey:@"progression"] )
        {
            Progress *progress = [[Progress alloc] initWithAttributes:[[attributes objectForKey:@"progression"] objectForKey:difficultyKey]];
            if( [difficultyKey isEqualToString:@"normal"] )
                progress.difficulty = ProgressDifficultyNormal;
            else if( [difficultyKey isEqualToString:@"nightmare"] )
                progress.difficulty = ProgressDifficultyNightmare;
            else if( [difficultyKey isEqualToString:@"hell"] )
                progress.difficulty = ProgressDifficultyHell;
            else if( [difficultyKey isEqualToString:@"inferno"] )
                progress.difficulty = ProgressDifficultyInferno;
            [quests addObject:progress];
            [progress release], progress = nil;
        }
        
        self.progression = [NSArray arrayWithArray:quests];
        
        NSMutableArray *hardcoreQuests = [NSMutableArray array];
        //parse quests
        for ( NSString *difficultyKey in [attributes objectForKey:@"hardcoreProgression"] )
        {
            Progress *progress = [[Progress alloc] initWithAttributes:[[attributes objectForKey:@"hardcoreProgression"] objectForKey:difficultyKey]];
            if( [difficultyKey isEqualToString:@"normal"] )
                progress.difficulty = ProgressDifficultyNormal;
            else if( [difficultyKey isEqualToString:@"nightmare"] )
                progress.difficulty = ProgressDifficultyNightmare;
            else if( [difficultyKey isEqualToString:@"hell"] )
                progress.difficulty = ProgressDifficultyHell;
            else if( [difficultyKey isEqualToString:@"inferno"] )
                progress.difficulty = ProgressDifficultyInferno;
            [hardcoreQuests addObject:progress];
            [progress release], progress = nil;
        }
        
        self.hardcoreProgression = [NSArray arrayWithArray:hardcoreQuests];
        
        
        
    }
    return self;
}

- (NSArray *) addHeroes:(NSDictionary *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    for( NSDictionary *attr in dict )
    {
        [array addObject:[[[HeroProfile alloc] initWithAttributes:attr] autorelease]];
    }
    
    return [NSArray arrayWithArray:array];
}

#pragma mark -

+ (void)carreerProfileForName:(NSString *)name andRegion:(DiabloRegion)region block:(void (^)(CarreerProfile *carreerProfile, NSError *error))block
{
    
    ShowNetworkActivityIndicator();
    
    [[DiabloAPIClient sharedClient] getPath:[NSString stringWithFormat:@"profile/%@/",name] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        HideNetworkActivityIndicator();
        if( [JSON isKindOfClass:NSDictionary.class] && [JSON objectForKey:@"code"] )
        {
            NSString *code = [JSON objectForKey:@"code"];
            if( [code isEqualToString:@"MAINTENANCE"] || [code isEqualToString:@"LIMITED"] || [code isEqualToString:@"OOPS"] )
            {
                NSInteger intCode = [code isEqualToString:@"MAINTENANCE"] ? MAINTENANCE_ERROR_CODE : LIMITED_ERROR_CODE;
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:[JSON objectForKey:@"reason"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"carreerProfile" code:intCode userInfo:details];
                if (block) {
                    block(nil,error);
                }
                return;
            }
        }
        
        CarreerProfile *carreerProfile = [[[self alloc] initWithAttributes:(NSDictionary *)JSON] autorelease];
        carreerProfile.battleTag = [name retain];
        carreerProfile.region = region;
        
        
        
        if (block) {
            block(carreerProfile,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       HideNetworkActivityIndicator();
        
        NSLog(@"%@",operation.request.URL);
        if (block) {
            block(nil,error);
        }
    }];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"CarreerProfile: %@",self.lastUpdated];
}

@end

@implementation Artisan
{
@private
    ArtisanType artisanType;
    PlayStyle _playStyle;
    NSString *_slug;
    NSNumber *_level;
    NSNumber *_stepCurrent;
    NSNumber *_stepMax;
}
@synthesize playStyle = _playStyle;
@synthesize slug = _slug;
@synthesize level = _level;
@synthesize stepCurrent = _stepCurrent;
@synthesize stepMax = _stepMax;
@synthesize artisanType = _artisanType;

- (void) dealloc
{
    [_slug release], _slug = nil;
    [_level release], _level = nil;
    [_stepCurrent release], _stepCurrent = nil;
    [_stepMax release], _stepMax = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        if( !attributes || ![attributes isEqual:[NSNull null]] )
        {
            self.slug = [attributes objectForKey:@"slug"];
            self.level = [attributes objectForKey:@"level"];
            self.stepCurrent = [attributes objectForKey:@"stepMurrent"] ? [attributes objectForKey:@"stepMurrent"] : [attributes objectForKey:@"stepCurrent"];
            self.stepMax = [attributes objectForKey:@"stepMax"];
            
            self.artisanType = [self.slug isEqualToString:@"blacksmith"] ? ArtisanTypeBlacksmith : ArtisanTypeJeweler;
        }
    }
    return self;
}

@end
