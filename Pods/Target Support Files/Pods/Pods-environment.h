
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// GCDWebServer
#define COCOAPODS_POD_AVAILABLE_GCDWebServer
#define COCOAPODS_VERSION_MAJOR_GCDWebServer 3
#define COCOAPODS_VERSION_MINOR_GCDWebServer 2
#define COCOAPODS_VERSION_PATCH_GCDWebServer 1

// GCDWebServer/Core
#define COCOAPODS_POD_AVAILABLE_GCDWebServer_Core
#define COCOAPODS_VERSION_MAJOR_GCDWebServer_Core 3
#define COCOAPODS_VERSION_MINOR_GCDWebServer_Core 2
#define COCOAPODS_VERSION_PATCH_GCDWebServer_Core 1

// JRSwizzle
#define COCOAPODS_POD_AVAILABLE_JRSwizzle
#define COCOAPODS_VERSION_MAJOR_JRSwizzle 1
#define COCOAPODS_VERSION_MINOR_JRSwizzle 0
#define COCOAPODS_VERSION_PATCH_JRSwizzle 0

// SwipeBack
#define COCOAPODS_POD_AVAILABLE_SwipeBack
#define COCOAPODS_VERSION_MAJOR_SwipeBack 1
#define COCOAPODS_VERSION_MINOR_SwipeBack 0
#define COCOAPODS_VERSION_PATCH_SwipeBack 4

// Debug build configuration
#ifdef DEBUG

  // Reveal-iOS-SDK
  #define COCOAPODS_POD_AVAILABLE_Reveal_iOS_SDK
  #define COCOAPODS_VERSION_MAJOR_Reveal_iOS_SDK 1
  #define COCOAPODS_VERSION_MINOR_Reveal_iOS_SDK 0
  #define COCOAPODS_VERSION_PATCH_Reveal_iOS_SDK 7

#endif
