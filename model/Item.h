//
//  ItemInfo.h
//  Diablo Connect
//
//  Created by Andy Jacobs on 29/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiabloAPIClient.h"
#import "HeroProfile.h"
#import "AFJSONRequestOperation.h"

typedef enum
{
    ItemCategoryJewel,
    ItemCategoryArmor,
    ItemCategoryWeapon,
    ItemCategoryOffHand
} ItemCategory;

typedef enum
{
    ItemTypeHead,
    ItemTypeTorso,
    ItemTypeFeet,
    ItemTypeHands,
    ItemTypeShoulders,
    ItemTypeLegs,
    ItemTypeBracers,
    ItemTypeMainHand,
    ItemTypeOffHand,
    ItemTypeWaist,
    ItemTypeRightFinger,
    ItemTypeLeftFinger,
    ItemTypeNeck
} ItemType;

typedef enum
{
    GemTypeAmethyst,
    GemTypeEmerald,
    GemTypeRuby,
    GemTypeTopaz
} GemType;

typedef enum
{
    GemLevelChipped,
    GemLevelFlawed,
    GemLevelDefault,
    GemLevelFlawless,
    GemLevelPerfect,
    GemLevelRadiant, 
    GemLevelSquare,
    GemLevelFlawlessSquare,
    GemLevelPerfectSquare,
    GemLevelRadiantSquare,
    GemLevelStar,
    GemLevelFlawlessStar,
    GemLevelPerfectStar,
    GemLevelRadiantStar
} GemLevel;



@interface Range : NSObject

@property (nonatomic,retain) NSNumber *min;
@property (nonatomic,retain) NSNumber *max;

@end

@class HeroProfile;
@interface Item : NSObject

@property DiabloGrade grade;

@property (nonatomic,assign) HeroProfile *parent;
@property ItemCategory category;
@property ItemType type;
@property (nonatomic,retain) NSString *key;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *icon;
@property (nonatomic,retain) NSString *displayColor;
@property (nonatomic,retain) NSString *tooltipParams;
@property (nonatomic,retain) NSString *itemTypeName;
@property (nonatomic,retain) NSString *itemTypeId;
@property BOOL itemTypeTwoHanded;
@property (nonatomic,retain) NSNumber *requiredLevel;
@property (nonatomic,retain) NSNumber *itemLevel;
@property (nonatomic,retain) NSNumber *bonusAffixes;
@property (nonatomic,retain) Range *dps;
@property (nonatomic,retain) Range *attacksPerSecond;
@property (nonatomic,retain) Range *minDamage;
@property (nonatomic,retain) Range *maxDamage;
@property (nonatomic,retain) Range *armor;
@property (nonatomic,retain) Range *blockChance;
@property (nonatomic,retain) NSArray *attributes;
@property (nonatomic,retain) NSDictionary *rawAttributes;
@property (nonatomic,retain) NSArray *gems;
@property (nonatomic,retain) NSArray *salvages;
@property (nonatomic,retain) NSString *flavorText;
@property (nonatomic,readonly) NSURL *iconURL;
@property (nonatomic,retain) NSDictionary *set;

- (id) initWithAttributes:(NSDictionary *)attributes;
- (void) addBasicAttributes:(NSDictionary *)attributes;
- (void) addDataWithAttributes:(NSDictionary *)attributes;
- (void) retrieveInformationWithBlock:(void (^)(Item *item, NSError *error))block;
- (AFJSONRequestOperation *) requestOperation;
@end

@interface Gem : NSObject

@property GemType gemType;
@property GemLevel gemLevel;
@property (nonatomic,retain) NSString *key;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *icon;
@property (nonatomic,retain) NSString *displayColor;
@property (nonatomic,retain) NSString *tooltipParams;
@property (nonatomic,retain) NSArray *attributes;
@property (nonatomic,retain) NSDictionary *rawAttributes;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (NSURL *) iconURL;
@end

