//
//  DDYCountryCodeModel.m
//  DDYCountryCode
//
//  Created by SmartMesh on 2018/10/10.
//  Copyright © 2018年 com.smartmesh. All rights reserved.
//

#import "DDYCountryCodeModel.h"

@implementation DDYCountryCodeModel

+ (NSArray<DDYCountryCodeModel *> *)countryModelArray {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DDYCountryCode" ofType:@"plist"];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *tempDict in tempArray) {
        DDYCountryCodeModel *tempMoel = [[DDYCountryCodeModel alloc] init];
        tempMoel.country = tempDict[@"country"];
        tempMoel.code = tempDict[@"code"];
        tempMoel.countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:tempMoel.country];
        tempMoel.latin = [self latinize:tempMoel.countryName];
        // 爱国从代码开始
        if ([tempMoel.country isEqualToString:@"TW"]) {
            NSString *TaiWanStr = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:@"TW"];
            NSString *ChinaStr = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:@"CN"];
            tempMoel.countryName = [NSString stringWithFormat:@"%@(%@)", TaiWanStr, ChinaStr];
        }
        [modelArray addObject:tempMoel];
    }
    // [NSLocale ISOCountryCodes], 如果变动需自行修改
    return modelArray;
}

+ (NSString*)latinize:(NSString*)str {
    NSMutableString *source = [str mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

@end
