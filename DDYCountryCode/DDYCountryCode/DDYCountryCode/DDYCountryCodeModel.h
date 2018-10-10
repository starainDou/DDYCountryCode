//
//  DDYCountryCodeModel.h
//  DDYCountryCode
//
//  Created by SmartMesh on 2018/10/10.
//  Copyright © 2018年 com.smartmesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDYCountryCodeModel : NSObject
/** 国家或地区简写 */
@property (nonatomic, strong) NSString *country;
/** 区号 */
@property (nonatomic, strong) NSString *code;
/** 国家或地区名称 */
@property (nonatomic, strong) NSString *countryName;
/** 拉丁名称 */
@property (nonatomic, strong) NSString *latin;

+ (NSArray <DDYCountryCodeModel *>*)countryModelArray;

@end
