#!/bin/bash
while [[ -f "/tmp/TESTDONE.harts" ]]; do
        killall Dock
        killall Finder
        killall SystemUIServer
        killall QuickLookUIService
        killall Siri
        killall Spotlight
        killall USBAgent
        killall SidecarRelay
        killall sharingd
        killall AirPlayUIAgent
        killall ExternalQuickLookSatellite
	killall TouchBarServer
done
