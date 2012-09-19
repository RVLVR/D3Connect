//
//  ItemInfo.m
//  Diablo Connect
//
//  Created by Andy Jacobs on 29/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import "Item.h"

@implementation Range
{
@private
    NSNumber *_min;
    NSNumber *_max;
}

@synthesize min = _min;
@synthesize max = _max;

- (void) dealloc
{
    [_min release], _min = nil;
    [_max release], _max = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        if( !attributes || ![attributes isEqual:[NSNull null]] )
        {
            self.min = [attributes objectForKey:@"min"];
            self.max = [attributes objectForKey:@"max"];
        }
    }
    return self;
}

@end

@implementation Item
{
@private
    DiabloGrade _grade;
    
    HeroProfile *_parent;
    ItemCategory _category;
    ItemType _type;
    NSString *_key;
    NSString *_name;
    NSString *_icon;
    NSString *_displayColor;
    NSString *_tooltipParams;
    NSString *_itemTypeName;
    NSString *_itemTypeId;
    BOOL _itemTypeTwoHanded;
    NSNumber *_requiredLevel;
    NSNumber *_itemLevel;
    NSNumber *_bonusAffixes;
    Range *_dps;
    Range *_attacksPerSecond;
    Range *_minDamage;
    Range *_maxDamage;
    Range *_armor;
    Range *_blockChance;
    NSArray *_attributes;
    NSDictionary *_rawAttributes;
    NSArray *_gems;
    NSArray *_salvages;
    NSString *_flavorText;
    NSDictionary *_set;
}
@synthesize grade = _grade;

@synthesize flavorText = _flavorText;
@synthesize parent = _parent;
@synthesize category = _category;
@synthesize type = _type;
@synthesize key = _key;
@synthesize name = _name;
@synthesize icon = _icon;
@synthesize displayColor = _displayColor;
@synthesize tooltipParams = _tooltipParams;
@synthesize itemTypeName = _itemTypeName;
@synthesize itemTypeId = _itemTypeId;
@synthesize itemTypeTwoHanded = _itemTypeTwoHanded;
@synthesize requiredLevel = _requiredLevel;
@synthesize itemLevel = _itemLevel;
@synthesize bonusAffixes = _bonusAffixes;
@synthesize dps = _dps;
@synthesize attacksPerSecond = _attacksPerSecond;
@synthesize minDamage = _minDamage;
@synthesize maxDamage = _maxDamage;
@synthesize armor = _armor;
@synthesize blockChance = _blockChance;
@synthesize attributes = _attributes;
@synthesize rawAttributes = _rawAttributes;
@synthesize gems = _gems;
@synthesize salvages = _salvages;
@synthesize set = _set;

- (void) dealloc
{
    [_parent release], _parent = nil;
    [_key release], _key = nil;
    [_name release], _name = nil;
    [_icon release], _icon = nil;
    [_displayColor release], _displayColor = nil;
    [_tooltipParams release], _tooltipParams = nil;
    [_itemTypeName release], _itemTypeName = nil;
    [_itemTypeId release], _itemTypeId = nil;
    [_requiredLevel release], _requiredLevel = nil;
    [_itemLevel release], _itemLevel = nil;
    [_bonusAffixes release], _bonusAffixes = nil;
    [_dps release], _dps = nil;
    [_attacksPerSecond release], _attacksPerSecond = nil;
    [_minDamage release], _minDamage = nil;
    [_maxDamage release], _maxDamage = nil;
    [_armor release], _armor = nil;
    [_blockChance release], _blockChance = nil;
    [_attributes release], _attributes = nil;
    [_rawAttributes release], _rawAttributes = nil;
    [_gems release], _gems = nil;
    [_salvages release], _salvages = nil;
    [_flavorText release], _flavorText = nil;
    [_set release], _set = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        if( !attributes || ![attributes isEqual:[NSNull null]] )
        {
            _key = nil;
            [self addBasicAttributes:attributes];
        }
    }
    return self;
}

- (void) addBasicAttributes:(NSDictionary *)attributes
{
    if( attributes && ![attributes isEqual:[NSNull null]] )
    {
        self.grade = DiabloGradeBasic;
        self.icon = [attributes objectForKey:@"icon"];
        self.displayColor = [attributes objectForKey:@"displayColor"];
        self.name = [attributes objectForKey:@"name"];
        self.tooltipParams = [attributes objectForKey:@"tooltipParams"];
        self.itemTypeName = [attributes objectForKey:@"typeName"];
        
        
    }
}

- (void) addDataWithAttributes:(NSDictionary *)attributes
{    
    if( attributes && ![attributes isEqual:[NSNull null]] )
    {
        self.grade = DiabloGradeFull;
        
        [self addBasicAttributes:attributes];
        
        self.requiredLevel = [attributes objectForKey:@"requiredLevel"];
        self.itemLevel = [attributes objectForKey:@"itemLevel"];
        self.bonusAffixes = [attributes objectForKey:@"bonusAffixes"];
        self.dps = [attributes objectForKey:@"dps"] ? [[[Range alloc] initWithAttributes:[attributes objectForKey:@"dps"]] autorelease] : nil;
        self.attacksPerSecond = [attributes objectForKey:@"attacksPerSecond"] ? [[[Range alloc] initWithAttributes:[attributes objectForKey:@"attacksPerSecond"]] autorelease] : nil;
        self.minDamage = [attributes objectForKey:@"minDamage"] ? [[[Range alloc] initWithAttributes:[attributes objectForKey:@"minDamage"]] autorelease] : nil;
        self.maxDamage = [attributes objectForKey:@"maxDamage"] ? [[[Range alloc] initWithAttributes:[attributes objectForKey:@"maxDamage"]] autorelease] : nil;
        self.armor = [attributes objectForKey:@"armor"] ? [[[Range alloc] initWithAttributes:[attributes objectForKey:@"armor"]] autorelease] : nil;
        self.blockChance = [attributes objectForKey:@"blockChance"] ? [[[Range alloc] initWithAttributes:[attributes objectForKey:@"blockChance"]] autorelease] : nil;
        self.attributes = [attributes objectForKey:@"attributes"];
        self.rawAttributes = [attributes objectForKey:@"attributesRaw"];
        self.set = [attributes objectForKey:@"set"];
        self.itemTypeId = [[attributes objectForKey:@"type"] objectForKey:@"id"];
        self.itemTypeTwoHanded = [[[attributes objectForKey:@"type"] objectForKey:@"twoHanded"] boolValue];
        
        NSMutableArray *gems = [NSMutableArray array];
        for( NSDictionary *gem in [attributes objectForKey:@"gems"] )
        {
            [gems addObject:[[[Gem alloc] initWithAttributes:gem] autorelease]];
        }
        
        self.gems = [NSArray arrayWithArray:gems];

        
        self.salvages = [attributes objectForKey:@"salvage"];
        self.flavorText = [attributes objectForKey:@"flavorText"];
    }
}

- (NSURL *) iconURL
{    
    NSString *iconName = self.icon;
    
    /*NSString *itemGender = @"male";
    if([self.parent.gender intValue] == 1 && self.type == ItemTypeTorso) itemGender = @"female";
    NSString *iconAffix = [NSString stringWithFormat:@"%@_%@",[[[self.parent heroClassLong] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""],itemGender];

    
    
    if( [self.icon rangeOfString:iconAffix].location == NSNotFound )
        iconName = [NSString stringWithFormat:@"%@_%@",self.icon,iconAffix];*/
    
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.media.blizzard.com/d3/icons/items/large/%@.png",[DiabloAPIClient domainCodeForRegion:[[DiabloAPIClient sharedClient] currentRegion]],iconName]];
}

- (void) setKey:(NSString *)key
{
    [_key release], _key = nil;
    _key = [key retain];
    if( [_key isEqualToString:@"head"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeHead;
    } else if ( [_key isEqualToString:@"torso"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeTorso;
    } else if ( [_key isEqualToString:@"feet"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeFeet;
    } else if ( [_key isEqualToString:@"hands"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeHands;
    } else if ( [_key isEqualToString:@"shoulders"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeShoulders;
    } else if ( [_key isEqualToString:@"legs"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeLegs;
    } else if ( [_key isEqualToString:@"bracers"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeBracers;
    } else if ( [_key isEqualToString:@"mainHand"] )
    {
        self.category = ItemCategoryWeapon;
        self.type = ItemTypeMainHand;
    } else if ( [_key isEqualToString:@"offHand"] )
    {
        self.category = ItemCategoryOffHand;
        self.type = ItemTypeOffHand;
    } else if ( [_key isEqualToString:@"waist"] )
    {
        self.category = ItemCategoryArmor;
        self.type = ItemTypeWaist;
    } else if ( [_key isEqualToString:@"rightFinger"] )
    {
        self.category = ItemCategoryJewel;
        self.type = ItemTypeRightFinger;
    } else if ( [_key isEqualToString:@"leftFinger"] )
    {
        self.category = ItemCategoryJewel;
        self.type = ItemTypeLeftFinger;
    } else if ( [_key isEqualToString:@"neck"] )
    {
        self.category = ItemCategoryJewel;
        self.type = ItemTypeNeck;
    }
}

- (void) retrieveInformationWithBlock:(void (^)(Item *item, NSError *error))block
{
    if( self.grade == DiabloGradeFull )
    {
        if(block)
            block(self,nil);
        return;
    }
    ShowNetworkActivityIndicator();
    [[DiabloAPIClient sharedClient] getPath:[NSString stringWithFormat:@"data/item/%@",[[self.tooltipParams componentsSeparatedByString:@"/"] objectAtIndex:1]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        HideNetworkActivityIndicator();
        [self addDataWithAttributes:(NSDictionary *)JSON];
        
        if (block) {
            block(self,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HideNetworkActivityIndicator();
        if (block) {
            block(nil,error);
        }
    }];
}

- (AFJSONRequestOperation *) requestOperation
{
    NSURLRequest *request = [[DiabloAPIClient sharedClient] URLRequestforItem:[NSString stringWithFormat:@"data/item/%@",[[self.tooltipParams componentsSeparatedByString:@"/"] objectAtIndex:1]]];
    
    if( !request )
        return nil;
    
    return [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //
        self.grade = DiabloGradeFull;
        
        if( [JSON isKindOfClass:NSDictionary.class] && [JSON objectForKey:@"code"] )
        {
            NSString *code = [JSON objectForKey:@"code"];
            if( [code isEqualToString:@"MAINTENANCE"] || [code isEqualToString:@"LIMITED"] )
            {
                return;
            }
        }
        
        [self addDataWithAttributes:(NSDictionary *)JSON];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //
    }];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Item: %@, %@, %@ - %i",self.key,self.name,self.tooltipParams,self.type];
}


@end

@implementation Gem
{
@private
    GemType _gemType;
    GemLevel _gemLevel;
    NSString *_key;
    NSString *_name;
    NSString *_icon;
    NSString *_displayColor;
    NSString *_tooltipParams;
    NSArray *_attributes;
    NSDictionary *_rawAttributes;
}
@synthesize gemType = _gemType;
@synthesize gemLevel = _gemLevel;
@synthesize key = _key;
@synthesize name = _name;
@synthesize icon = _icon;
@synthesize displayColor = _displayColor;
@synthesize tooltipParams = _tooltipParams;
@synthesize attributes = _attributes;
@synthesize rawAttributes = _rawAttributes;


- (void) dealloc
{
    [_key release], _key = nil;
    [_name release], _name = nil;
    [_icon release], _icon = nil;
    [_displayColor release], _displayColor = nil;
    [_tooltipParams release], _tooltipParams = nil;
    [_attributes release], _attributes = nil;
    [_rawAttributes release], _rawAttributes = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        
        if( !attributes || ![attributes isEqual:[NSNull null]] )
        {
            
            self.key = [[attributes objectForKey:@"item"] objectForKey:@"id"];
            self.icon = [[attributes objectForKey:@"item"] objectForKey:@"icon"];
            self.displayColor = [[attributes objectForKey:@"item"] objectForKey:@"displayColor"];
            self.name = [[attributes objectForKey:@"item"] objectForKey:@"name"];
            self.tooltipParams = [[attributes objectForKey:@"item"] objectForKey:@"tooltipParams"];
            self.attributes = [attributes objectForKey:@"attributes"];
            self.rawAttributes = [attributes objectForKey:@"attributesRaw"];
            
            /*
            NSString *level = [self.name lowercaseString];
            
            if( [[word rangeOfString:searchFor] isEqualToString:@"chipped"] )
            {
                self.gemLevel = GemLevelChipped;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"flawed"] )
            {
                self.gemLevel = GemLevelFlawed;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"default"] )
            {
                self.gemLevel = GemLevelDefault;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"flawless"] )
            {
                self.gemLevel = GemLevelFlawless;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"perfect"] )
            {
                self.gemLevel = GemLevelPerfect;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"radiant"] )
            {
                self.gemLevel = GemLevelRadiant;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"square"] )
            {
                self.gemLevel = GemLevelSquare;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"flawless-square"] )
            {
                self.gemLevel = GemLevelFlawlessSquare;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"perfect-square"] )
            {
                self.gemLevel = GemLevelPerfectSquare;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"radiant-square"] )
            {
                self.gemLevel = GemLevelRadiantSquare;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"star"] )
            {
                self.gemLevel = GemLevelStar;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"flawless-star"] )
            {
                self.gemLevel = GemLevelFlawlessStar;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"perfect-star"] )
            {
                self.gemLevel = GemLevelPerfectStar;
            } else if ( [[attributes objectForKey:@"level"] isEqualToString:@"radiant-star"] )
            {
                self.gemLevel = GemLevelRadiantStar;
            }
            
            NSString *type = [self.name lowercaseString];
            
            if( [[attributes objectForKey:@"type"] isEqualToString:@"amethyst"] )
            {
                self.gemType = GemTypeAmethyst;
            } else if( [[attributes objectForKey:@"type"] isEqualToString:@"emerald"] )
            {
                self.gemType = GemTypeEmerald;
            } else if( [[attributes objectForKey:@"type"] isEqualToString:@"ruby"] )
            {
                self.gemType = GemTypeRuby;
            } else if( [[attributes objectForKey:@"type"] isEqualToString:@"topaz"] )
            {
                self.gemType = GemTypeTopaz;
            }*/
            
            
            
            
        }
    }
    return self;
}

- (NSURL *) iconURL
{
    NSString *iconName = self.icon;
    
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.media.blizzard.com/d3/icons/items/large/%@.png",[DiabloAPIClient domainCodeForRegion:[[DiabloAPIClient sharedClient] currentRegion]],iconName]];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Socket: type: %i - level: %i",self.gemType,self.gemLevel];
}

@end