//
//  HeroProfile.m
//  Diablo Connect
//
//  Created by Andy Jacobs on 18/06/12.
//  Copyright (c) 2012 REVOLVER. All rights reserved.
//

#import "HeroProfile.h"
#import "JSONKit.h"

@implementation HeroProfile
{
@private
    DiabloGrade _grade;
    BOOL _fallenHero;
    HeroType _heroType;
    NSString *_name;
    NSNumber *_nid;
    NSNumber *_paragonLevel;
    NSNumber *_level;
    NSNumber *_gender;
    NSNumber *_hardcore;
    NSString *_heroClass;
    NSNumber *_lastUpdated;
    
    NSString *_heroClassLong;
    NSString *_heroClassShort;
    
    NSArray *_skills;
    
    NSArray *_items;
    NSArray *_followers;
    NSArray *_quests;
    NSDictionary *_stats;
    NSDictionary *_kills;
    NSDictionary *_death;
}
@synthesize grade = _grade;
@synthesize heroType = _heroType;
@synthesize name = _name;
@synthesize nid = _nid;
@synthesize skills = _skills;
@synthesize level = _level;
@synthesize paragonLevel = _paragonLevel;
@synthesize gender = _gender;
@synthesize hardcore = _hardcore;
@synthesize heroClass = _heroClass;
@synthesize lastUpdated = _lastUpdated;
@synthesize heroClassLong = _heroClassLong;
@synthesize heroClassShort = _heroClassShort;
@synthesize items = _items;
@synthesize followers = _followers;
@synthesize quests = _quests;
@synthesize stats = _stats;
@synthesize kills = _kills;
@synthesize death = _death;
@synthesize fallenHero = _fallenHero;
- (void) dealloc
{
    [_name release], _name = nil;
    [_nid release], _nid = nil;
    [_paragonLevel release], _paragonLevel = nil;
    [_level release], _level = nil;
    [_gender release], _gender = nil;
    [_hardcore release], _hardcore = nil;
    [_heroClass release], _heroClass = nil;
    [_lastUpdated release], _lastUpdated = nil;
    
    [_heroClassLong release], _heroClassLong = nil;
    [_heroClassShort release], _heroClassShort = nil;
    
    [_skills release], _skills = nil;
    
    [_items release], _items = nil;
    [_followers release], _followers = nil;
    [_quests release], _quests = nil;
    [_stats release], _stats = nil;
    [_kills release], _kills = nil;
    [_death release], _death = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        
        [self addBasicAttributes:attributes];
        
    }
    return self;
}

- (void) addBasicAttributes:(NSDictionary *)attributes
{
    if( attributes && ![attributes isEqual:[NSNull null]] )
    {
        self.grade = DiabloGradeBasic;
        _nid            = [[attributes objectForKey:@"id"] retain];
        _name           = [[attributes objectForKey:@"name"] retain];
        _level          = [[attributes objectForKey:@"level"] retain];
        _paragonLevel   = [[attributes objectForKey:@"paragonLevel"] retain];
        _gender         = [[attributes objectForKey:@"gender"] retain];
        _hardcore       = [[attributes objectForKey:@"hardcore"] retain];
        _heroClass      = [[attributes objectForKey:@"class"] retain];
        _lastUpdated    = [[attributes objectForKey:@"lastUpdated"] retain];
        
        if( [_heroClass isEqualToString:@"barbarian"] )
        {
            _heroClassLong = @"BARBARIAN";
            _heroClassShort = @"BARB";
            _heroType = HeroTypeBarbarian;
        } else if ( [_heroClass isEqualToString:@"demon-hunter"] )
        {
            _heroClassLong = @"DEMON HUNTER";
            _heroClassShort = @"DH";
            _heroType = HeroTypeDemonHunter;
        } else if ( [_heroClass isEqualToString:@"monk"] )
        {
            _heroClassLong = @"MONK";
            _heroClassShort = @"MONK";
            _heroType = HeroTypeMonk;
        } else if ( [_heroClass isEqualToString:@"witch-doctor"] )
        {
            _heroClassLong = @"WITCH DOCTOR";
            _heroClassShort = @"WD";
            _heroType = HeroTypeWitchDocter;
        } else if ( [_heroClass isEqualToString:@"wizard"] )
        {
            _heroClassLong = @"WIZARD";
            _heroClassShort = @"WIZ";
            _heroType = HeroTypeWizard;
        }
    }
}

- (void) addDataWithAttributes:(NSDictionary *)attributes
{
    //NSLog(@"%@",attributes);
    
    if( attributes && ![attributes isEqual:[NSNull null]] )
    {
        self.grade = DiabloGradeFull;
        [self addBasicAttributes:attributes];
        
        NSMutableArray *skills = [NSMutableArray array];
        // parse active skills
        for ( NSDictionary *activeSkill in [[attributes objectForKey:@"skills"] objectForKey:@"active"] )
        {
            Skill *rune = [[Skill alloc] initWithAttributes:[activeSkill objectForKey:@"rune"]];
            rune.skillType = SkillTypeRune;
            
            Skill *skill = [[Skill alloc] initWithAttributes:[activeSkill objectForKey:@"skill"]];
            skill.skillType = SkillTypeActive;
            skill.rune = rune;
            [skills addObject:skill];
            
            [skill release], skill = nil;
            [rune release], rune = nil;
        }
        //parse passive skills
        for ( NSDictionary *passiveSkill in [[attributes objectForKey:@"skills"] objectForKey:@"passive"] )
        {
            Skill *skill = [[Skill alloc] initWithAttributes:[passiveSkill objectForKey:@"skill"]];
            skill.parent = self;
            skill.skillType = SkillTypePassive;
            [skills addObject:skill];
            
            [skill release], skill = nil;
        }
        
        _skills = [[NSArray alloc] initWithArray:skills];
        
        
        NSMutableArray *items = [NSMutableArray array];
        // parse items
        for( NSString *itemKey in [attributes objectForKey:@"items"] )
        {
            Item *item = [[Item alloc] initWithAttributes:[[attributes objectForKey:@"items"] objectForKey:itemKey]];
            item.parent = self;
            item.key = itemKey;
            [items addObject:item];
            [item release], item = nil;
        }
        
        _items = [[NSArray alloc] initWithArray:items];
        
        NSMutableArray *followers = [NSMutableArray array];
        // parse followers
        for ( NSString *followerKey in [attributes objectForKey:@"followers"] )
        {
            NSLog(@"%@",[[attributes objectForKey:@"followers"] objectForKey:followerKey]);
            Follower *follower = [[Follower alloc] initWithAttributes:[[attributes objectForKey:@"followers"] objectForKey:followerKey] andHero:self];
            follower.key = followerKey;
            if( [followerKey isEqualToString:@"templar"] )
                follower.followerType = FollowerTypeTemplar;
            if( [followerKey isEqualToString:@"scoundrel"] )
                follower.followerType = FollowerTypeScoundrel;
            if( [followerKey isEqualToString:@"enchantress"] )
                follower.followerType = FollowerTypeEnchantress;
            [followers addObject:follower];
            [follower release], follower = nil;
        }
        
        _followers = [[NSArray alloc] initWithArray:followers];
        
        _stats = [[attributes objectForKey:@"stats"] retain];
        
        NSMutableArray *quests = [NSMutableArray array];
        //parse quests
        for ( NSString *difficultyKey in [attributes objectForKey:@"progress"] )
        {
            Progress *progress = [[Progress alloc] initWithAttributes:[[attributes objectForKey:@"progress"] objectForKey:difficultyKey]];
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
        
        _quests = [[NSArray arrayWithArray:quests] retain];
        
        _kills = [[attributes objectForKey:@"kills"] retain];
        
        _death = [[attributes objectForKey:@"death"] retain];
        
        _lastUpdated = [[attributes objectForKey:@"last-updated"] retain];
    }
}


#pragma mark -

- (void) heroProfileWithCarreerName:(NSString *)name block:(void (^)(HeroProfile *heroProfile, NSError *error))block
{
    if( self.grade == DiabloGradeFull )
    {
        if(block)
            block(self,nil);
        return;
    }
    
    ShowNetworkActivityIndicator();
    [[DiabloAPIClient sharedClient] getPath:[NSString stringWithFormat:@"profile/%@/hero/%@",[[name stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.nid] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
       HideNetworkActivityIndicator();
        
        if( [JSON isKindOfClass:NSDictionary.class] && [JSON objectForKey:@"code"] )
        {
            NSString *code = [JSON objectForKey:@"code"];
            if( [code isEqualToString:@"MAINTENANCE"] || [code isEqualToString:@"LIMITED"] )
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

- (NSString *) description
{
    return [NSString stringWithFormat:@"HeroProfile: %@ - %@",self.name,self.nid];
}


@end

@implementation Skill
{
@private
    SkillType _skillType;
    NSString *_slug;
    NSString *_name;
    NSString *_description;
    NSString *_simpleDescription;
    NSString *_tooltipParams;
    NSString *_type;
    NSString *_flavor;
    NSNumber *_orderIndex;
    NSString *_icon;
    Skill *_rune;
    HeroProfile *_parent;
}
@synthesize parent = _parent;
@synthesize skillType = _skillType;
@synthesize slug = _slug;
@synthesize name = _name;
@synthesize description = _description;
@synthesize simpleDescription = _simpleDescription;
@synthesize tooltipParams = _tooltipParams;
@synthesize type = _type;
@synthesize flavor = _flavor;
@synthesize orderIndex = _orderIndex;
@synthesize icon = _icon;
@synthesize rune = _rune;

- (void) dealloc
{
    [_slug release], _slug = nil;
    [_name release], _name = nil;
    [_description release], _description = nil;
    [_simpleDescription release], _simpleDescription = nil;
    [_tooltipParams release], _tooltipParams = nil;
    [_type release], _type = nil;
    [_flavor release], _type = nil;
    [_orderIndex release], _orderIndex = nil;
    [_icon release], _icon = nil;
    [_rune release], _rune = nil;
    [_parent release], _parent = nil;
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
            self.name = [attributes objectForKey:@"name"];
            self.description = [attributes objectForKey:@"description"];
            self.simpleDescription = [attributes objectForKey:@"simpleDescription"];
            self.tooltipParams = [attributes objectForKey:@"tooltipParams"];
            self.type = [attributes objectForKey:@"type"];
            self.flavor = [attributes objectForKey:@"flavor"];
            self.orderIndex = [attributes objectForKey:@"orderIndex"];
            self.icon = [attributes objectForKey:@"icon"];
        }
    }
    return self;
}

- (NSURL *) iconURL
{

    return [NSURL URLWithString:[NSString stringWithFormat:@"http://us.media.blizzard.com/d3/icons/skills/64/%@.png",self.icon]];
}

@end


@implementation Follower 
{
@private
    FollowerType _followerType;
    NSString *_key;
    NSString *_slug;
    NSArray *_items;
    NSArray *_skills;
    NSNumber *_level;
    NSDictionary *_stats;
}
@synthesize followerType = _followerType;
@synthesize key = _key;
@synthesize slug = _slug;
@synthesize items = _items;
@synthesize skills = _skills;
@synthesize level = _level;
@synthesize stats = _stats;

- (void) dealloc
{
    [_key release], _key = nil;
    [_slug release], _slug = nil;
    [_items release], _items = nil;
    [_skills release], _skills = nil;
    [_level release], _level = nil;
    [_stats release], _stats = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes andHero:(HeroProfile *)hero
{
    self = [super init];
    if (self)
    {
        if( !attributes || ![attributes isEqual:[NSNull null]] )
        {
            self.slug = [attributes objectForKey:@"slug"];
            NSMutableArray *skills = [NSMutableArray array];
            //parse follower skills
            for ( NSDictionary *passiveSkill in [attributes objectForKey:@"skills"] )
            {
                Skill *skill = [[Skill alloc] initWithAttributes:[passiveSkill objectForKey:@"skill"]];
                skill.skillType = SkillTypeFollower;
                [skills addObject:skill];
                
                [skill release], skill = nil;
            }
            
            self.skills = [NSArray arrayWithArray:skills];
            
            
            NSMutableArray *items = [NSMutableArray array];
            // parse follower items
            for( NSString *itemKey in [attributes objectForKey:@"items"] )
            {
                Item *item = [[Item alloc] initWithAttributes:[[attributes objectForKey:@"items"] objectForKey:itemKey]];
                item.key = itemKey;
                item.parent = hero;
                [items addObject:item];
                [item release], item = nil;
            }
            
            self.items = [NSArray arrayWithArray:items];
            self.level = [attributes objectForKey:@"level"];
            self.stats = [attributes objectForKey:@"stats"];
        }
    }
    return self;
}

@end

@implementation Quest 
{
@private
    NSString *_name;
    NSString *_slug;
    BOOL _completed;
}
@synthesize name = _name;
@synthesize slug = _slug;
@synthesize completed = _completed;

- (void) dealloc
{
    [_name release], _name = nil;
    [_slug release], _slug = nil;
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
            self.name = [attributes objectForKey:@"name"];
            //self.completed = [[attributes objectForKey:@"completedQuests"] boolValue];
        }
    }
    return self;
}


@end

@implementation Act
{
@private
    ProgressAct _act;
    NSArray *_quests;
    BOOL _completed;
}
@synthesize act = _act;
@synthesize quests = _quests;
@synthesize completed = _completed;

- (void) dealloc
{
    [_quests release], _quests = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        if( !attributes || ![attributes isEqual:[NSNull null]] )
        {
            NSMutableArray *quests = [NSMutableArray array];
            // parse quests
            for ( NSDictionary *questDict in [attributes objectForKey:@"quests"] )
            {
                Quest *quest = [[Quest alloc] initWithAttributes:questDict];
                [quests addObject:quest];
                [quest release], quest = nil;
            }
            self.quests = [NSArray arrayWithArray:quests];
            //self.completed = [[attributes objectForKey:@"completed"] boolValue];
        }
    }
    return self;
}

- (void) completedQuests:(NSDictionary *)completedQuests
{
    self.completed = [[completedQuests objectForKey:@"completed"] boolValue];
    
    for ( NSDictionary *questDict in [completedQuests objectForKey:@"completedQuests"] )
    {
        
        Quest *quest = (Quest *)[[self.quests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"slug like %@",[questDict objectForKey:@"slug"]]] objectAtIndex:0];
        quest.completed = YES;
    }
}

@end

@implementation Progress 
{
@private
    ProgressDifficulty _difficulty;
    NSArray *_acts;
}
@synthesize difficulty = _difficulty;
@synthesize acts = _acts;

- (void) dealloc
{
    [_acts release], _acts = nil;
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        if( !attributes || ![attributes isEqual:[NSNull null]] )
        {
            NSDictionary *quests = nil;
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"quests" ofType:@"json"];
            NSData *myData = [NSData dataWithContentsOfFile:filePath];
            if (myData) {
                quests = [myData objectFromJSONData];
            }
            
            NSMutableArray *acts = [NSMutableArray array];
            for( NSString *actKey in quests )
            {
                
                
                Act *act = [[Act alloc] initWithAttributes:[quests objectForKey:actKey]];
                if( [actKey isEqualToString:@"act1"] )
                {
                    act.act = ProgressDifficultyNormal;
                } else if( [actKey isEqualToString:@"act2"] ){
                    act.act = ProgressDifficultyNightmare;
                } else if( [actKey isEqualToString:@"act3"] ){
                    act.act = ProgressDifficultyHell;
                } else if( [actKey isEqualToString:@"act4"] ){
                    act.act = ProgressDifficultyInferno;
                }
                
                [act completedQuests:[attributes objectForKey:actKey]];
                
                [acts addObject:act];
                [act release], act = nil;
            }
            
            self.acts = [NSArray arrayWithArray:acts];
        }
        
    }
        return self;
}

@end
