//
//  HeroProfile.h
//  Diablo Connect
//
//  Created by Andy Jacobs on 18/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

#import "DiabloAPIClient.h"
typedef enum
{
    SkillTypeNone = 0,
    SkillTypeActive,
    SkillTypeRune,
    SkillTypePassive,
    SkillTypeFollower
} SkillType;

typedef enum
{
    ProgressDifficultyNormal = 0,
    ProgressDifficultyNightmare = 1,
    ProgressDifficultyHell = 2,
    ProgressDifficultyInferno = 3
} ProgressDifficulty;

typedef enum
{
    HeroTypeBarbarian,
    HeroTypeDemonHunter,
    HeroTypeMonk,
    HeroTypeWitchDocter,
    HeroTypeWizard
} HeroType;

typedef enum
{
    ProgressActI,
    ProgressActII,
    ProgressActIII,
    ProgressActIV
} ProgressAct;

typedef enum
{
    FollowerTypeEnchantress,
    FollowerTypeTemplar,
    FollowerTypeScoundrel
} FollowerType;


@interface HeroProfile : NSObject

@property DiabloGrade grade;

@property HeroType heroType;
@property BOOL fallenHero;
@property (nonatomic,retain) NSNumber *nid;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSNumber *level;
@property (nonatomic,retain) NSNumber *paragonLevel;
@property (nonatomic,retain) NSNumber *gender;
@property (nonatomic,retain) NSNumber *hardcore;
@property (nonatomic,retain) NSString *heroClass;
@property (nonatomic,retain) NSNumber *lastUpdated;

@property (nonatomic,retain) NSString *heroClassLong;
@property (nonatomic,retain) NSString *heroClassShort;


@property (nonatomic,retain) NSArray *skills;
@property (nonatomic,retain) NSArray *items;
@property (nonatomic,retain) NSArray *followers;
@property (nonatomic,retain) NSArray *quests;
@property (nonatomic,retain) NSDictionary *stats;
@property (nonatomic,retain) NSDictionary *kills;
@property (nonatomic,retain) NSDictionary *death;


- (id)initWithAttributes:(NSDictionary *)attributes;
- (void) addDataWithAttributes:(NSDictionary *)attributes;
- (void) heroProfileWithCarreerName:(NSString *)name block:(void (^)(HeroProfile *heroProfile, NSError *error))block;



@end


@interface Skill : NSObject

@property SkillType skillType;
@property (nonatomic,retain) HeroProfile *parent;
@property (nonatomic,retain) NSString *slug;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *simpleDescription;
@property (nonatomic,retain) NSString *tooltipParams;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *flavor;
@property (nonatomic,retain) NSNumber *orderIndex;
@property (nonatomic,retain) NSString *icon;
@property (nonatomic,retain) Skill *rune;
@property (nonatomic,readonly) NSURL *iconURL;

- (id) initWithAttributes:(NSDictionary *)attributes;

@end


@interface Follower : NSObject

@property FollowerType followerType;
@property (nonatomic,retain) NSString *key;
@property (nonatomic,retain) NSString *slug;
@property (nonatomic,retain) NSArray *items;
@property (nonatomic,retain) NSArray *skills;
@property (nonatomic,retain) NSNumber *level;
@property (nonatomic,retain) NSDictionary *stats;

- (id) initWithAttributes:(NSDictionary *)attributes  andHero:(HeroProfile *)hero;

@end

@interface Quest : NSObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *slug;
@property BOOL completed;

- (id) initWithAttributes:(NSDictionary *)attributes;


@end

@interface Act : NSObject

@property ProgressAct act;
@property (nonatomic,retain) NSArray *quests;
@property BOOL completed;

- (id) initWithAttributes:(NSDictionary *)attributes;

@end

@interface Progress : NSObject

@property ProgressDifficulty difficulty;
@property (nonatomic,retain) NSArray *acts;

- (id) initWithAttributes:(NSDictionary *)attributes;

@end