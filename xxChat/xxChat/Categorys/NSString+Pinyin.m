//
//  NSString+Pinyin.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/22.
//

#import "NSString+Pinyin.h"

@implementation NSString (Pinyin)

- (NSString *)getPinyin {
    
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    // 汉字转成拼音(不知道为什么英文是拉丁语的意思)
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    // 去掉声调
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    return mutableString;
}
@end
