default:
	# Set default make action here
	# xcodebuild -target Tests -configuration MyMainTarget -sdk iphonesimulator build	

clean:
	-rm -rf build/*

test:
	xcodebuild -sdk iphonesimulator -workspace MobileContactApplication.xcworkspace -scheme CommandLineUnitTests -configuration Debug RUN_APPLICATION_TESTS_WITH_IOS_SIM=YES ONLY_ACTIVE_ARCH=NO clean build 2>&1 | bundle exec ocunit2junit
