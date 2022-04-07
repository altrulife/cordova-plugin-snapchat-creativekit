/********* CDVCreativeKit.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <SCSDKCreativeKit/SCSDKCreativeKit.h>
#import "CDVCreativeKit.h"

@implementation CDVCreativeKit
{
    SCSDKSnapAPI *_scSdkSnapApi;
}

- (void)pluginInitialize {
    [super pluginInitialize];

    _scSdkSnapApi = [SCSDKSnapAPI new];
}


- (void) sendPluginResult: (CDVPluginResult*)result :(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) handlePluginException: (NSException*) exception :(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    NSLog(@"EXCEPTION: %@", exception.reason);
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (SCSDKSnapSticker*)createSnapSticker:(NSDictionary*)stickerMap
{
    NSString *stickerData = nil;

    if (stickerMap != nil) {
        stickerData = stickerMap[@"uri"];
    }
    
    if (stickerData == nil) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:stickerData];
    SCSDKSnapSticker *snapSticker = [[SCSDKSnapSticker alloc] initWithStickerUrl:url isAnimated:NO];
    if(stickerMap[@"width"]) {
        snapSticker.width = [[stickerMap objectForKey:@"width"] doubleValue];
    }
    if(stickerMap[@"height"]) {
        snapSticker.height = [[stickerMap objectForKey:@"height"] doubleValue];
    }
    if(stickerMap[@"posX"]) {
        snapSticker.posX = [[stickerMap objectForKey:@"posX"] doubleValue];
    }
    if(stickerMap[@"posY"]) {
        snapSticker.posY = [[stickerMap objectForKey:@"posY"] doubleValue];
    }
    if(stickerMap[@"rotation"]) {
        snapSticker.rotation = [[stickerMap objectForKey:@"rotation"] doubleValue];
    }
    return snapSticker;
}

- (SCSDKPhotoSnapContent*)createSnapPhotoContent:(NSDictionary*)contentMap
{
    NSString *contentUri = nil;

    if (contentMap != nil) {
        contentUri = contentMap[@"uri"];
    }
    
    if (contentUri == nil) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:contentUri];
    SCSDKSnapPhoto *photo = [[SCSDKSnapPhoto alloc] initWithImageUrl:url];
    SCSDKPhotoSnapContent *photoContent = [[SCSDKPhotoSnapContent alloc] initWithSnapPhoto:photo];

    return photoContent;
}

- (SCSDKVideoSnapContent*)createSnapVideoContent:(NSDictionary*)contentMap
{
    NSString *contentUri = nil;

    if (contentMap != nil) {
        contentUri = contentMap[@"uri"];
    }
    
    if (contentUri == nil) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:contentUri];
    SCSDKSnapVideo *video = [[SCSDKSnapVideo alloc] initWithVideoUrl:url];
    SCSDKVideoSnapContent *videoContent = [[SCSDKVideoSnapContent alloc] initWithSnapVideo:video];

    return videoContent;
}

- (void)sharePhoto:(CDVInvokedUrlCommand*)command
{
    @try {
        NSDictionary* metadata = [command.arguments objectAtIndex:0];
        
        if (metadata[@"content"] == nil) {
            [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] :command];
            return;
        }

        SCSDKPhotoSnapContent *snapContent = [self createSnapPhotoContent:metadata[@"content"]];
        NSLog(@"Added content");
        
        if (metadata[@"caption"]) {
            snapContent.caption = metadata[@"caption"];
            NSLog(@"Added caption");
        }
        
        if (metadata[@"attachmentUrl"]) {
            snapContent.attachmentUrl = metadata[@"attachmentUrl"];
            NSLog(@"Added attachmentUrl");
        }
        
        if (metadata[@"sticker"]) {
            SCSDKSnapSticker *snapSticker = [self createSnapSticker:metadata[@"sticker"]];
            if (snapSticker != nil) {
                snapContent.sticker = snapSticker;
                NSLog(@"Added sticker");
            }
        }

        if (metadata[@"topics"]) {
            NSArray* topics = [metadata objectForKey:@"topics"];
            snapContent.topics = [[SCSDKContentTopics alloc] initWithTopics:topics];
            NSLog(@"Added topics");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_scSdkSnapApi startSendingContent:snapContent completionHandler:^(NSError *error){
                return;
            }];
        });

        [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] :command];
    }
    @catch (NSException *exception) {
        [self handlePluginException:exception :command];
    }
}

- (void)shareVideo:(CDVInvokedUrlCommand*)command
{
    @try {
        NSDictionary* metadata = [command.arguments objectAtIndex:0];
        
        if (metadata[@"content"] == nil) {
            [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] :command];
            return;
        }

        SCSDKVideoSnapContent *snapContent = [self createSnapVideoContent:metadata[@"content"]];
        NSLog(@"Added content");
        
        if (metadata[@"caption"]) {
            snapContent.caption = metadata[@"caption"];
            NSLog(@"Added caption");
        }
        
        if (metadata[@"attachmentUrl"]) {
            snapContent.attachmentUrl = metadata[@"attachmentUrl"];
            NSLog(@"Added attachmentUrl");
        }
        
        if (metadata[@"sticker"]) {
            SCSDKSnapSticker *snapSticker = [self createSnapSticker:metadata[@"sticker"]];
            if (snapSticker != nil) {
                snapContent.sticker = snapSticker;
                NSLog(@"Added sticker");
            }
        }

        if (metadata[@"topics"]) {
            NSArray* topics = [metadata objectForKey:@"topics"];
            snapContent.topics = [[SCSDKContentTopics alloc] initWithTopics:topics];
            NSLog(@"Added topics");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_scSdkSnapApi startSendingContent:snapContent completionHandler:^(NSError *error){
                return;
            }];
        });

        [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] :command];
    }
    @catch (NSException *exception) {
        [self handlePluginException:exception :command];
    }
}

- (void)shareToCameraPreview:(CDVInvokedUrlCommand*)command
{
   
    @try {
        SCSDKNoSnapContent *snapContent = [[SCSDKNoSnapContent alloc] init];
        NSDictionary* metadata = [command.arguments objectAtIndex:0];
        
        if (metadata[@"caption"]) {
            snapContent.caption = metadata[@"caption"];
            NSLog(@"Added caption");
        }
        
        if (metadata[@"attachmentUrl"]) {
            snapContent.attachmentUrl = metadata[@"attachmentUrl"];
            NSLog(@"Added attachmentUrl");
        }
        
        if (metadata[@"sticker"]) {
            SCSDKSnapSticker *snapSticker = [self createSnapSticker:metadata[@"sticker"]];
            if (snapSticker != nil) {
                snapContent.sticker = snapSticker;
                NSLog(@"Added sticker");
            }
        }

        if (metadata[@"topics"]) {
            NSArray* topics = [metadata objectForKey:@"topics"];
            snapContent.topics = [[SCSDKContentTopics alloc] initWithTopics:topics];
            NSLog(@"Added topics");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_scSdkSnapApi startSendingContent:snapContent completionHandler:^(NSError *error){
                return;
            }];
        });

        [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] :command];
    }
    @catch (NSException *exception) {
        [self handlePluginException:exception :command];
    }
}

- (void)shareLensToCameraPreview:(CDVInvokedUrlCommand*)command
{
   
    @try {
        NSDictionary* metadata = [command.arguments objectAtIndex:0];

        if (metadata[@"lensUUID"] == nil) {
            [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] :command];
            return;
        }

        SCSDKLensSnapContent *snapContent = [[SCSDKLensSnapContent alloc] initWithLensUUID:metadata[@"lensUUID"]];
        NSLog(@"Added lensUUID");

        if (metadata[@"caption"]) {
            snapContent.caption = metadata[@"caption"];
            NSLog(@"Added caption");
        }
        
        if (metadata[@"attachmentUrl"]) {
            snapContent.attachmentUrl = metadata[@"attachmentUrl"];
            NSLog(@"Added attachmentUrl");
        }

        if (metadata[@"launchData"]) {
            SCSDKLensLaunchDataBuilder *launchDataBuilder = [[SCSDKLensLaunchDataBuilder alloc] init];
            NSDictionary* launchDataMap = metadata[@"launchData"];
            for(id key in launchDataMap)
                [launchDataBuilder addNSStringKeyPair:key value:[launchDataMap objectForKey:key]];

            [launchDataBuilder build];
            snapContent.launchData = launchDataBuilder;
            NSLog(@"Added launchData");
        }

        if (metadata[@"topics"]) {
            NSArray* topics = [metadata objectForKey:@"topics"];
            snapContent.topics = [[SCSDKContentTopics alloc] initWithTopics:topics];
            NSLog(@"Added topics");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_scSdkSnapApi startSendingContent:snapContent completionHandler:^(NSError *error){
                return;
            }];
        });

        [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] :command];
    }
    @catch (NSException *exception) {
        [self handlePluginException:exception :command];
    }
}
@end
