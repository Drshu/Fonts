//
//  FavoritesList.h
//  Fonts
//
//  Created by shucheng on 16/3/1.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesList : NSObject

+(instancetype)shardFavoritesList;//声明了一个工厂方法，可以返回一个类的实例
-(NSArray *)favorites;
-(void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to;
-(void)addFavorite:(id)item;
-(void)removeFavorite:(id)item;

@end
