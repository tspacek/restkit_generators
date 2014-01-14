//
//  ViewController.m
//  Dummy
//
//  Created by Tomas Spacek on 9/01/2014.
//  Copyright (c) 2014 Papercloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) PCDCollectionTableViewManager *tableManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RKLogConfigureByName("*", RKLogLevelDebug);
    
    

    PCDCollectionManager *collectionManager = [PCDCollectionManager collectionManagerWithClass:[Post class]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Comment mapping]
                                                                      method:RKRequestMethodGET
                                                                 pathPattern:@"/api/posts.json"
                                                                     keyPath:@"comments"
                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [collectionManager.objectManager addResponseDescriptor:responseDescriptor];
    
    self.tableManager = [[PCDCollectionTableViewManager alloc] initWithDecoratedObject:nil
                                                                     collectionManager:collectionManager
                                                                             tableView:self.tableView];

}

@end
