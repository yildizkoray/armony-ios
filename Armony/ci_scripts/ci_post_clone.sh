#!/bin/sh

# MARK: - CONFIG

mkdir -p '../Armony/Resources/Configs'

touch '../Armony/Resources/Configs/ReleaseConfiguration.xcconfig'
touch '../Armony/Resources/Configs/DebugConfiguration.xcconfig'

# MARK: - GOOGLE PLIST PATH

mkdir -p '../Armony/Resources/Firebase'

touch '../Armony/Resources/Firebase/GoogleService-Info-Debug.plist'
touch '../Armony/Resources/Firebase/GoogleService-Info.plist'

INFO_PLIST_PATH_RELEASE='../Armony/Resources/Firebase/GoogleService-Info.plist'
INFO_PLIST_PATH_DEBUG='../Armony/Resources/Firebase/GoogleService-Info-Debug.plist'

cat <<EOF > "$INFO_PLIST_PATH_DEBUG"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLIENT_ID</key>
    <string></string>
    <key>REVERSED_CLIENT_ID</key>
    <string></string>
    <key>API_KEY</key>
    <string></string>
    <key>GCM_SENDER_ID</key>
    <string></string>
    <key>PLIST_VERSION</key>
    <string>1</string>
    <key>BUNDLE_ID</key>
    <string></string>
    <key>PROJECT_ID</key>
    <string></string>
    <key>STORAGE_BUCKET</key>
    <string></string>
    <key>IS_ADS_ENABLED</key>
    <false/>
    <key>IS_ANALYTICS_ENABLED</key>
    <false/>
    <key>IS_APPINVITE_ENABLED</key>
    <true/>
    <key>IS_GCM_ENABLED</key>
    <true/>
    <key>IS_SIGNIN_ENABLED</key>
    <true/>
    <key>GOOGLE_APP_ID</key>
    <string></string>
</dict>
</plist>
EOF

cat <<EOF > "$INFO_PLIST_PATH_RELEASE"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLIENT_ID</key>
    <string></string>
    <key>REVERSED_CLIENT_ID</key>
    <string></string>
    <key>API_KEY</key>
    <string></string>
    <key>GCM_SENDER_ID</key>
    <string></string>
    <key>PLIST_VERSION</key>
    <string>1</string>
    <key>BUNDLE_ID</key>
    <string></string>
    <key>PROJECT_ID</key>
    <string></string>
    <key>STORAGE_BUCKET</key>
    <string></string>
    <key>IS_ADS_ENABLED</key>
    <false/>
    <key>IS_ANALYTICS_ENABLED</key>
    <false/>
    <key>IS_APPINVITE_ENABLED</key>
    <true/>
    <key>IS_GCM_ENABLED</key>
    <true/>
    <key>IS_SIGNIN_ENABLED</key>
    <true/>
    <key>GOOGLE_APP_ID</key>
    <string></string>
</dict>
</plist>
EOF
