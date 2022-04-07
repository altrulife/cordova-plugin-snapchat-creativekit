# cordova-plugin-snapchat-creativekit
Cordova plugin for Snapchat CreativeKit

Creative Kit SDK Docs: https://docs.snap.com/snap-kit/creative-kit/overview

## Supported platforms
- iOS

## Installation
```
cordova plugin add https://github.com/altrulife/cordova-plugin-snapchat-creativekit
```

## (Required) Add SCSDKClientId to config.xml so Snapchat will allowed to be opened with your Share data
```
<platform name="ios">
    <config-file target="*-Info.plist" parent="SCSDKClientId">
        <string>YOUR_CLIENT_ID</string>
    </config-file>
</platform>
```

## (Optional) Add SCSDKRedirectUrl to config.xml to handle errors from Snapchat
```
<platform name="ios">
    <config-file target="*-Info.plist" parent="SCSDKRedirectUrl">
        <string>YOUR_REDIRECT_URL</string>
    </config-file>
</platform>
```

## Usage from JS

### sharePhoto and shareVideo
A Snap with a still image or video is displayed in Snapchat’s preview screen, where the user can make the final modifications before sending it. Your app can add metadata or overlays — like caption text, sticker images, and attachment URLs — to embed with the Snap.

Media Size and Length Restrictions
- Shared media must be 300 MB or smaller.
- Videos must be 60 seconds or shorter.
- Videos that are longer than 10 seconds are split up into multiple Snaps of 10 seconds or less
- Preferred File Types
- Images must be JPEG or PNG
- Videos must be MP4 or MOV

```
cordova.plugins.creativekit.sharePhoto(
    {
        content: {
            uri: 'uri string', // ie: data:image/png;base64, iVBORw0KGgoAAAANSU...
        },
        attachmentUrl: 'url string', // any URL to attach ie: https://www.snapchat.com
        caption: 'Hi I am a caption bar on Snapchat',
        sticker: {
            uri: 'uri string', // ie: data:image/png;base64, iVBORw0KGgoAAAANSU...
            width: 300,
            height: 300,
            posX: 0.5,
            posY: 0.6,
            rotation: 0,
            // isAnimated: false, // always false for now
        },
        topics: ['topic1', 'topic2'], // See: Posting to Spotlight below
    },
    () => console.log('success'),
    () => console.log('error')
);
```

```
cordova.plugins.creativekit.shareVideo(
    {
        content: {
            uri: 'uri string',
        },
        attachmentUrl: 'url string', // any URL to attach ie: https://www.snapchat.com
        caption: 'Hi I am a caption bar on Snapchat',
        sticker: {
            uri: 'uri string', // ie: data:image/png;base64, iVBORw0KGgoAAAANSU...
            width: 300,
            height: 300,
            posX: 0.5,
            posY: 0.6,
            rotation: 0,
            // isAnimated: false, // always false for now
        },
        topics: ['topic1', 'topic2'], // See: Posting to Spotlight below
    },
    () => console.log('success'),
    () => console.log('error')
);
```

### shareToCameraPreview
Send users right into the live camera on Snapchat and allow them to add sticker overlays, caption text, and attachment URLs to any Snap content type.

Limitations
- Only one sticker is allowed at a time
- Stickers must be PNG or JPEG
- An animated sticker (currently only supported on iOS) must be WebP (preferred) or GIF
- Stickers must be 1MB or smaller
- Captions are limited to 250 characters
- Attachment URLs must be properly formatted URLs in string format
- Universal links are not supported

```
cordova.plugins.creativekit.shareToCameraPreview(
    {
        attachmentUrl: 'url string', // any URL to attach ie: https://www.snapchat.com
        caption: 'Hi I am a caption bar on Snapchat',
        sticker: {
            uri: 'uri string', // ie: data:image/png;base64, iVBORw0KGgoAAAANSU...
            width: 300,
            height: 300,
            posX: 0.5,
            posY: 0.6,
            rotation: 0,
            // isAnimated: false, // always false for now
        },
        topics: ['topic1', 'topic2'], // See: Posting to Spotlight below
    },
    () => console.log('success'),
    () => console.log('error')
);
```

### shareLensToCameraPreview
You are able to add Lens attachments so that users will open Snapchat to specific Lenses! To enable sharing with Dynamic Lenses, you must first create and publish a Lens using Lens Studio. You can choose to add captions or a URL attachment to a Lens, but stickers and background photos or videos are disabled in this flow. In addition, you may optionally include launch data with the Lens attachment, to add other attributes to the Lens, like hints, for example.

Conditions
- Stickers are not allowed
- Captions are limited to 250 characters
- Attachment URLs must be properly formatted URLs in string format
- Universal links are not supported
- Launch data can be added in key-value pairs. The key must be a string and the value can be an int, float, double, string, or an array of any one of those types

```
cordova.plugins.creativekit.shareLensToCameraPreview(
    {
        lensUUID: 'uuid string',
        launchData: {
            hair_color: '#b76e79',
            hint: 'lens_hint_raise_your_eyebrows',
            // ... etc
        },
        attachmentUrl: 'url string', // any URL to attach ie: https://www.snapchat.com
        caption: 'Hi I am a caption bar on Snapchat',
        topics: ['topic1', 'topic2'], // See: Posting to Spotlight below
    },
    () => console.log('success'),
    () => console.log('error')
);
```

## Posting to Spotlight

From SDK Docs: https://docs.snap.com/snap-kit/creative-kit/Tutorials/ios#posting-to-spotlight

Creative Kit for Spotlight provides Spotlight Creators and Snapstars with the ability to share content, with optionally attached topics, from third-party applications to Spotlight using Creative Kit; this makes it easier for them to create and share new content from their favorite Apps to Spotlight.

Topics in Spotlight are useful for identification (i.e. for campaigns, challenges, trends, etc.) and content categorization (i.e. #comedy, #dogs, #sports, etc.). When these topics are set, they propagate to the Send-To page and show up in the Spotlight Story section.

The Creative Kit API allows for up to 3 topics to be set for each Snap that is shared to Spotlight. Topics should be used wisely to increase engagement. We highly recommend deterring from using App names as topics.

### App Page and App Context Card
Spotlight Snaps are aggregated by the topics, sounds, and lenses that are used to create each of those Snaps, and are added to their respective Pages. We will use this same process for Snaps that are posted to Spotlight from 3PAs using Creative Kit -- App Pages will automatically be created from these submissions and users will be able to select them to view other content posted to Spotlight from that App.

In addition, Spotlight Snaps from 3PAs will generate App Context Cards, to show the source of the shared content. Tapping on the Context Card will link to the App Page shown above. From here, Snapchatters can browse Snaps created through the respective App and can install the App from within Snapchat:

#### Requirements
The Creative Kit API allows for up to 3 topics to be added to each Snap. Each topic is a string with the following requirements:

- Maximum of 100 characters
- Characters cannot include:
    - Punctuation Characters (except “_”)
    - Whitespace or Newline Characters
    - Symbol Characters
- This excluded character set is Unicode General Categories S*, Z*, P* and U+000A ~ U+000D, U+0085

The SDK API will raise an error if topics do not meet the requirements above.

#### Requesting Access
In order to utilize this feature, you will need to register your app and request for access in the Snap Kit Developer Portal.

Under the Creative Kit toggle, you will see a subsection for Spotlight. Make sure to fill out the appropriate details and submit your app for approval.

Your app will go through our normal review process. Please note that until your Attachment URL Domain is approved by our review team, you will not be able to use and test this integration.

Once approved, the approved app version can be set to Production and you can begin posting Creative Kit content to Spotlight!
