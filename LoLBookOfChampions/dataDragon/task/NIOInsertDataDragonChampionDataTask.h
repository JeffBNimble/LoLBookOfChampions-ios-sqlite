//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"

@class NIOContentResolver;


@interface NIOInsertDataDragonChampionDataTask : NSObject<NIOTask>
@property (strong, nonatomic) NSURL *dataDragonCDN;
@property (strong, nonatomic) NSString *dataDragonRealmVersion;
@property (strong, nonatomic) NSDictionary *remoteDataDragonChampionData;

-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver;
@end