#!/bin/sh
function failed()
{
    echo "Failed: $@" >&2
    exit 1
}
 
set -ex
 
export OUTPUT=$WORKSPACE/output
rm -rf $OUTPUT
mkdir -p $OUTPUT
PROFILE_HOME=~/Library/MobileDevice/Provisioning\ Profiles/
KEYCHAIN=~/Library/Keychains/login.keychain
 
. "$WORKSPACE/build/build.config"
 
[ -d "$PROFILE_HOME" ] || mkdir -p "$PROFILE_HOME"
security unlock -p $PASSWORD
 
cd $WORKSPACE/iphone;
agvtool new-version -all $BUILD_NUMBER
 
for sdk in $SDKS; do
for config in $CONFIGURATIONS; do
provision=$(eval echo \$`echo Provision$config`)
        cert="$WORKSPACE/build/$provision"
        archive="$OUTPUT/$JOB_NAME-$BUILD_NUMBER-$config.zip";
        [ -f "$cert" ] && cp "$cert" "$PROFILE_HOME"
        cd $WORKSPACE/iphone
 
        xcodebuild -configuration $config -sdk $sdk clean;
        xcodebuild -configuration $config -sdk $sdk || failed build;
        cd build/$config-iphoneos;
        if [ $config == "Release" ]; then
zip -r -T -y "$archive" *.app* || failed zip
            zip -j -T "$archive" "$WORKSPACE/iphone/icon.png" || failed icon
        else
zip -r -T -y "$archive" *.app || failed zip
            zip -j -T "$archive" "$cert" || failed cert
        fi
done
done
