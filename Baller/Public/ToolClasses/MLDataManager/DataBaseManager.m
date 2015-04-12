//
//  DataBaseManager.m
//  LightApp
//
//  Created by malong on 14/11/13.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "DataBaseManager.h"
#import "NSObject+DateBaseModel.h"
#import "FMDatabase.h"

#define kDefaultDataBaseName @"Baller.sqlite"

@implementation DataBaseManager

static DataBaseManager * _defaultDataBaseManager = nil;
static dispatch_once_t once = 0;

+(DataBaseManager *) defaultDataBaseManager{
    
    dispatch_once(&once, ^{
        _defaultDataBaseManager = [[DataBaseManager alloc] init];
        
    });
    return _defaultDataBaseManager;
    
}

- (void) dealloc {
    [self close];
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        int state = [self initializeDBWithName:kDefaultDataBaseName];
        
        if (state == kDBCREATEFAILURE) {
            DLog(@"数据库初始化失败");
        } else {
            DLog(@"数据库初始化成功");
        }
    }
    return self;
}

/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 * @return 返回数据库初始化状态，
 */

- (int) initializeDBWithName : (NSString *) name {
    if (!name) {
        return kDBCREATEFAILURE;  // 返回数据库创建失败
    }
    // 沙盒Docu目录
    NSString * filePath = [NSString stringWithFormat:@"/%@",name];
    _dataBasePath = DOCUMENTFILEPATH(filePath);
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:_dataBasePath];
    [self connect];
    if (!exist) {
        return kDBHASEXSIT;
    } else {
        return kDBCREATESUCCESS;
    }
    
}

- (void)addhah{
    
}


/// 连接数据库
- (void) connect {
    
    if (!_dataBase) {
        _dataBase = [[FMDatabase alloc] initWithPath:_dataBasePath];
    }
    if (![_dataBase open]) {
        DLog(@"不能打开数据库");
    }
}
/// 关闭连接
- (void) close {
    [_dataBase close];
    _defaultDataBaseManager = nil;
}


#pragma mark 数据库操作方法


/**
 * @brief 判断名为tableName的表是否存
 */
+ (BOOL) isTableExist:(NSString *)tableName
{
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    FMResultSet * set = [[[[self class] defaultDataBaseManager] dataBase] executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([set next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [set intForColumn:@"count"];
        DLog(@"TableExist %ld", (long)count);
        return (BOOL)count;
    }
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    return NO;
}

/**
 *brief 判断是否已经存在某条数据
 */
+ (BOOL) isModelExist:(NSString *)modelName
              keyName:(NSString *) keyName
             keyValue:(id)keyValue
{
    if (!keyName) {
        DLog(@"缺少查询条件！");
        return NO;
    }
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@",modelName,keyName,keyValue];
    DLog(@"query = %@",query);
    //根据查询语句查询
    FMResultSet * set = [[[[self class] defaultDataBaseManager] dataBase] executeQuery:query];
    
    //根据查询结果，生成对象，放入数组并返回
    while ([set next]) {
        DLog(@"TableExist %ld", (long)[set columnCount]);
        return (BOOL)[set columnCount];
        
    }
    [[[[self class] defaultDataBaseManager] dataBase]close];
    
    return NO;
}


/**
 * @brief 根据model对象名称创建数据库
 */
+ (void) createDataBaseWithDBModelName:(NSString *)modelName
{
    
    NSObject * dbModel = [[NSClassFromString(modelName) alloc]init];
    
    BOOL existTable = [DataBaseManager isTableExist:modelName];
    
    if (existTable) {
        // TODO:是否更新数据库
        DLog(@"数据库已经存在");
    } else {
        // TODO: 插入新的数据库
        
        NSMutableString * sql = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (",modelName];
        
        for (NSString *  propertyName in dbModel.propertyNames) {
            [sql appendFormat:@"%@,",propertyName];
        }
        [sql appendFormat:@")"];
        
        
        
        BOOL res = [[[[self class] defaultDataBaseManager] dataBase] executeUpdate:[sql stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        if (!res) {
            DLog(@"数据库创建失败");
            
        } else {
            DLog(@"数据库创建成功");
            
        }
    }
}

/**
 * @brief 删除数据库
 */
+ (BOOL) deleteDataBase
{
    BOOL success;
    NSError *error;
    
    // delete the old db.
    if ([DEFAULTFILEMANAGER fileExistsAtPath:[[[self class] defaultDataBaseManager] dataBasePath]])
    {
        [[[[self class] defaultDataBaseManager] dataBase]close];
        success = [DEFAULTFILEMANAGER removeItemAtPath:[[[self class] defaultDataBaseManager] dataBasePath] error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
            
        }
    }
    return success;
}

/**
 * @brief 删除表内容
 *
 * @param tableName 需要删除的表
 */
+ (BOOL) deleteTheTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![[[[self class] defaultDataBaseManager] dataBase] executeUpdate:sql])
    {
        DLog(@"表删除失败");
        return NO;
    }
    DLog(@"表删除成功");
    
    return YES;
}

/**
 * @brief 清除表
 *
 * @param tableName 需要清除的表名
 */
- (BOOL) eraseTheTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![[[[self class] defaultDataBaseManager] dataBase] executeUpdate:sql])
    {
        DLog(@"表清除失败!");
        return NO;
    }
    DLog(@"表清除成功");
    
    return YES;
}


/**
 * @brief 插入一条用户记录
 *
 * @param user 需要插入的用户数据
 */
+ (void) insertDataWithMDBModel:(NSObject *) dbModel
{
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    NSString * modelClassName = NSStringFromClass([dbModel class]);
    if (![DataBaseManager isTableExist:modelClassName]) {
        [DataBaseManager createDataBaseWithDBModelName:modelClassName];
    }
    //编辑插入语句
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@",modelClassName];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:dbModel.propertyNames.count];
    
    //遍历数组并将数组属性名称拼接
    for (NSString * propertyName in dbModel.propertyNames) {
        [keys appendString:[NSString stringWithFormat:@"%@,",propertyName]];
        [values appendString:@"?,"];
        //添加数据
        if ([dbModel valueForKey:propertyName]) {
            [arguments addObject:[dbModel valueForKey:propertyName]];
        }else{
            [arguments addObject:[NSNull new]];
        }
        
    }
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    DLog(@"%@",query);
    
    if ([[[[self class] defaultDataBaseManager] dataBase] executeUpdate:query withArgumentsInArray:arguments]) {
        DLog(@"插入一条数据");
    }
    
    [[[[self class] defaultDataBaseManager] dataBase]close];
    
}


/**
 * @brief 删除一条用户数据
 *
 * @param modelName 需要删除的数据模型的名称
 * @param keyName   需要删除的数据模型的主键名称
 * @param keyValue  需要删除的数据模型的主键
 */
+ (void) deleteDataModelWithModelName:(NSString *)modelName
                              keyName:(NSString *)keyName
                             keyValue:(id) keyValue
{
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@",modelName,keyName,keyValue];
    DLog(@"%@",query);
    
    
    if ([[[[self class] defaultDataBaseManager] dataBase] executeUpdate:query]) DLog(@"删除数据成功");
    
    //        [AppDelegate showStatusWithText:@"删除数据成功" duration:2.0];
    
    
    [[[[self class] defaultDataBaseManager] dataBase]close];
    
}


/**
 * @brief 以keyName为查询条件，更新主键值为keyValue的数据对象的值
 *
 * @param dbModel 所要修改的数据源
 */
+ (void) mergeWithDBModel:(NSObject *)dbModel
                  keyName:(NSString *)keyName
                 keyValue:(id) keyValue
{
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    NSString * modelClassName = NSStringFromClass([dbModel class]);
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"UPDATE %@ SET",modelClassName];
    NSMutableArray * arguments = [NSMutableArray array];
    
    //遍历对象的属性数组，并从新赋值
    for (NSString *  propertyName in dbModel.propertyNames) {
        if ([dbModel valueForKey:propertyName]) {
            [query appendFormat:@" %@ =  ?,",propertyName];
            [arguments addObject:[dbModel valueForKey:propertyName]];
            
        }
    }
    [query appendString:@")"];
    [query appendFormat:@" WHERE %@ = ?",keyName];
    [arguments addObject:keyValue];
    
    NSString * sql = [NSString stringWithFormat:@"%@",query];
    sql = [sql stringByReplacingOccurrencesOfString:@",)" withString:@""];
    DLog(@"%@",sql);
    
    
    if([[[[self class] defaultDataBaseManager] dataBase] executeUpdate:sql withArgumentsInArray:arguments])
        //         [AppDelegate showStatusWithText:@"成功修改了数据" duration:2.0];
        DLog(@"成功修改了数据");
    
    [[[[self class] defaultDataBaseManager] dataBase]close];
    
}

/**
 * @brief 获得表的数据条数
 *
 * @param modelName 需要查询的表名
 */
+ (int)findTheTableItemNumberWithModelName:(NSString *)modelName
                                   keyName:(NSString *) keyName
                                  keyValue:(id)keyValue{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", modelName];
    if (keyName && keyValue) {
        sql = $str(@"%@ where %@ = %@",sql,keyName,keyValue);
    }
    DLog(@"sql = %@",sql);
    [[[[self class] defaultDataBaseManager] dataBase]open];
    FMResultSet *set = [[[[self class] defaultDataBaseManager] dataBase] executeQuery:sql];
    int number = 0;
    while ([set next])
    {
        number++;
    }
    return number;
}

/**
 * @brief 获得表的数据
 *
 * @param modelName 需要查询的表名
 */
+ (NSMutableArray *)findTheTableItemWithModelName:(NSString *)modelName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", modelName];
    
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    FMResultSet *set = [[[[self class] defaultDataBaseManager] dataBase] executeQuery:sql];
    
    NSMutableArray * results = [[NSMutableArray alloc]init];
    
    while ([set next])
    {
        
        NSObject * obj = [[NSClassFromString(modelName) alloc]init];
        
        for (NSString *  propertyName in obj.propertyNames) {
            if ($safe([set objectForColumnName:propertyName])) {
                [obj setValue:[set objectForColumnName:propertyName] forKey:propertyName];
            }
        }
        
        [results addObject:obj];
        DLog(@"TableItemCount %ld", (long)results.count);
        
    }
    [set close];
    [[[[self class] defaultDataBaseManager] dataBase]close];
    
    return results;
    
}

/**
 * @brief 查询获取表modelName的数据
 */
+ (NSMutableArray *)findTheTableItemWithModelName:(NSString *)modelName sql:(NSString *)sql{
    
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    FMResultSet *set = [[[[self class] defaultDataBaseManager] dataBase] executeQuery:sql];
    
    NSMutableArray * results = [[NSMutableArray alloc]init];
    
    while ([set next])
    {
        
        NSObject * obj = [[NSClassFromString(modelName) alloc]init];
        
        for (NSString *  propertyName in obj.propertyNames) {
            if ($safe([set objectForColumnName:propertyName])) {
                [obj setValue:[set objectForColumnName:propertyName] forKey:propertyName];
            }
        }
        
        [results addObject:obj];
    }
    [set close];
    [[[[self class] defaultDataBaseManager] dataBase]close];
    DLog(@"TableItemCount %ld", (long)results.count);
    return results;
    
}

/**
 * @brief 模拟分页查找数据。取modelId大于某个值以后的limit个数据
 *
 * @param modelName 需要查询的数据模型的名称
 * @param keyName   需要删除的数据模型的主键名称
 * @param keyValue  需要删除的数据模型的主键值
 * @param limit 每页取多少个
 */
+ (NSArray *) findWithModelName:(NSString *)modelName
                        keyName:(NSString *) keyName
                       keyValue:(id)keyValue
                          limit:(int) limit
{
    [[[[self class] defaultDataBaseManager] dataBase]open];
    
    if (!keyName) {
        DLog(@"缺少查询条件！");
        return nil;
    }
    
    NSMutableString * query;
    if (limit) {
        query = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ ORDER BY %@ DESC limit %d",modelName,keyName,keyValue,keyName,limit];
    }else{
        query = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@",modelName,keyName,keyValue];
    }
    
    
    NSMutableArray * arguments = [NSMutableArray array];
    [arguments addObject:keyValue];
    DLog(@"%@",query);
    
    //根据查询语句查询
    FMResultSet * set = [[[[self class] defaultDataBaseManager] dataBase] executeQuery:query];
    NSMutableArray * results = [NSMutableArray arrayWithCapacity:[set columnCount]];
    
    //根据查询结果，生成对象，放入数组并返回
    while ([set next]) {
        
        NSObject * obj = [[NSClassFromString(modelName) alloc]init];
        
        for (NSString *  propertyName in obj.propertyNames) {
            [obj setValue:[set objectForColumnName:propertyName] forKey:propertyName];
        }
        
        [results addObject:obj];
        
    }
    [set close];
    DLog(@"results.count = %lu",(unsigned long)results.count);
    
    [[[[self class] defaultDataBaseManager] dataBase]close];
    
    return results;
    
    
}

@end
