//
//  Aircraft.h
//  JMODemo
//
//  Created by christophe on 21/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Airport, Pilot;

@interface Aircraft : NSManagedObject

@property (nonatomic, retain) NSNumber * canFly;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * primaryKey;
@property (nonatomic, retain) NSDate * purchaseDate;
@property (nonatomic, retain) Airport *airport;
@property (nonatomic, retain) NSSet *pilots;
@end

@interface Aircraft (CoreDataGeneratedAccessors)

- (void)addPilotsObject:(Pilot *)value;
- (void)removePilotsObject:(Pilot *)value;
- (void)addPilots:(NSSet *)values;
- (void)removePilots:(NSSet *)values;

@end
