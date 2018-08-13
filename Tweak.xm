#include <AppSupport/CPDistributedMessagingCenter.h>

@interface WriteAnywhereServer : NSObject
@end

@implementation WriteAnywhereServer

+ (void)load {
	[self sharedInstance];
}

+ (id)sharedInstance {
	static dispatch_once_t once = 0;
	__strong static id sharedInstance = nil;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id)init {
	if ((self = [super init])) {
		// ...
		// Center name must be unique, recommend using application identifier.
		CPDistributedMessagingCenter * messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.wizages.WriteAnywhereServer"];
		[messagingCenter runServerOnCurrentThread];

		// Register Messages
		[messagingCenter registerForMessageName:@"writeStringTo" target:self selector:@selector(handleString:withUserInfo:)];
		[messagingCenter registerForMessageName:@"createDir" target:self selector:@selector(handleDir:withUserInfo:)];
		[messagingCenter registerForMessageName:@"writeDataTo" target:self selector:@selector(handleData:withUserInfo:)];
	}

	return self;
}

- (NSDictionary *)handleString:(NSString *)name withUserInfo:(NSDictionary *)userinfo {
	// Process userinfo (simple dictionary) and return a dictionary (or nil)
	NSError *error3 = nil;
	[userinfo[@"data"] writeToFile:userinfo[@"filelocation"] atomically:NO encoding:NSUTF8StringEncoding error:&error3];
	HBLogDebug(@"Error3: %@", error3)
	return nil;
}

- (void)handleDir:(NSString *)name withUserInfo:(NSDictionary *)userinfo{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error2 = nil;
	[fm createDirectoryAtPath:userinfo[@"dirlocation"] withIntermediateDirectories:YES attributes:nil error:&error2];
	HBLogDebug(@"Error2: %@", error2)
	// ...
}


-(void)handleData:(NSString *)name withUserInfo:(NSDictionary *)userinfo{
	HBLogDebug(@"userinfo: %@", userinfo);
	[userinfo[@"data"] writeToFile:userinfo[@"filelocation"] atomically:NO];
}
@end

%ctor{
	HBLogDebug(@"Loaded");
	[WriteAnywhereServer load];
}