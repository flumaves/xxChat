//
//  NSString+Pinyin.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Pinyin)

//将汉字转拼音方法
- (NSString *)getPinyin;

@end

NS_ASSUME_NONNULL_END
