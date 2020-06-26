#!/bin/bash
launchctl unload /System/Library/LaunchAgent/com.apple.Dock.agent.plist
launchctl unload /System/Library/LaunchAgent/com.apple.Finder.plist
launchctl unload /System/Library/LaunchAgent/com.apple.SystemUIServer.agent.plist
launchctl unload /System/Library/LaunchAgent/com.apple.quicklook.plist
launchctl unload /System/Library/LaunchAgent/com.apple.quicklook.ui.helper.plist
launchctl unload /System/Library/LaunchAgent/com.apple.Siri.agent.plist
launchctl unload /System/Library/LaunchAgent/com.apple.Spotlight.plist
launchctl unload /System/Library/LaunchAgent/com.apple.sidecar-relay.plist
launchctl unload /System/Library/LaunchAgent/com.apple.sharingd.plist
launchctl unload /System/Library/LaunchAgent/com.apple.AirPlayUIAgent.plist
