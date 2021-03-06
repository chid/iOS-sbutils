#import <AppSupport/CPDistributedMessagingCenter.h>
#include <SpringBoard/SBMediaController.h>


%hook SpringBoard 
- (id)init {
	if ((self = %orig)) {
		CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.innoying.sbserver"];
		[messagingCenter runServerOnCurrentThread];
		[messagingCenter registerForMessageName:@"sbmedia" target:self selector:@selector(handleSbmediaCommand:withUserInfo:)];
	}
	return self;
}

%new(@@:@@)
- (NSDictionary *)handleSbmediaCommand:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
	//Extract options
	NSString *options = [userInfo objectForKey:@"options"];

	if([options isEqualToString:@"-t"] == YES){
		[(SBMediaController *)[%c(SBMediaController) sharedInstance] togglePlayPause];
	}else if([options isEqualToString:@"-p"] == YES){
                [(SBMediaController *)[%c(SBMediaController) sharedInstance] changeTrack:-1];
        }else if([options isEqualToString:@"-n"] == YES){
                [(SBMediaController *)[%c(SBMediaController) sharedInstance] changeTrack:1];
        }else{
		return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:-1] forKey:@"status"];	
	}
	return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"];
}
%end
