//
//  CRMLog.m
//  PaicAATService
//
//  Created by 陈栋(外包) on 2017/6/5.
//  Copyright © 2017年 chdo. All rights reserved.
//

#import "CRMLog.h"
#import "CRMLogManger.h"

@implementation CRMLog

+(void)outPutLog:(NSString *)dscrption content: (id)cont {
    
    
        NSString *environment = [CRMUserDefaults objectForKey:k_CRMEnvironment];
        
        // 测试
        if ( 1 == [environment intValue]) {
            
            NSString *showContent = [NSString stringWithFormat:@"%@: %@", dscrption, cont];
            NSLog(@"%@",showContent);
            [[CRMLogManger share] inputLog:showContent];
//            if ([cont isKindOfClass:[NSString class]]) {
//
//                [[CRMLogManger share] inputLog:showContent];
//            } else if ([cont isKindOfClass:[NSDictionary class]]) {
//
//                NSDictionary *dic = (NSDictionary *)cont;
//                NSString *str =  [NSDictionary dictionaryToJson:dic];
//                [[CRMLogManger share] inputLog:str];
//            }
            
        } else if ( 0 == [environment intValue]){ //生产
            
        }
    
}

@end
