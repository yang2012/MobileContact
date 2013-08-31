default:
	# Set default make action here
	# xcodebuild -target Tests -configuration MyMainTarget -sdk iphonesimulator build	

clean:
	-rm -rf build/*

test:
	#GHUNIT_CLI=1 xcodebuild ARCHS=i386 ONLY_ACTIVE_ARCH=NO -workspace MobileContactApplication.xcworkspace -scheme MobileContactApplication\ Tests -configuration Debug -sdk iphonesimulator5.1 build
	xcodebuild -sdk iphonesimulator -workspace MobileContactApplication.xcworkspace -scheme CommandLineUnitTests -configuration Debug RUN_APPLICATION_TESTS_WITH_IOS_SIM=YES ONLY_ACTIVE_ARCH=NO clean build 2>&1
