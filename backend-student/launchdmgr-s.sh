#!/bin/bash
launchctl load /System/Library/LaunchAgent/com.apple.Dock.agent.plist
launchctl load /System/Library/LaunchAgent/com.apple.Finder.plist
launchctl load /System/Library/LaunchAgent/com.apple.SystemUIServer.agent.plist
launchctl load /System/Library/LaunchAgent/com.apple.quicklook.plist
launchctl load /System/Library/LaunchAgent/com.apple.quicklook.ui.helper.plist
launchctl load /System/Library/LaunchAgent/com.apple.Siri.agent.plist
launchctl load /System/Library/LaunchAgent/com.apple.Spotlight.plist
launchctl load /System/Library/LaunchAgent/com.apple.sidecar-relay.plist
launchctl load /System/Library/LaunchAgent/com.apple.sharingd.plist
launchctl load /System/Library/LaunchAgent/com.apple.AirPlayUIAgent.plist
