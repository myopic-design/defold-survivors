APP_NAME := DefoldSurvivors
# This is provided by GitHub Actions
# APP_VERSION :=

# Paths

RESOLVE_DIR := .internal
ASSETS_DIR := assets
BUILD_DIR := build
COVERAGE_DIR := coverage
DIST_DIR := dist
TOOLS_DIR := tools

WINDOWS_ASSETS_DIR := $(ASSETS_DIR)/windows
MACOS_ASSETS_DIR := $(ASSETS_DIR)/macos
IOS_ASSETS_DIR := $(ASSETS_DIR)/ios
ANDROID_ASSETS_DIR := $(ASSETS_DIR)/android
ANDROID_BUNDLED_ASSETS_DIR := $(ASSETS_DIR)/bundle/android/res
WEB_ASSETS_DIR := $(ASSETS_DIR)/web

# Tools

BOB_PATH := $(TOOLS_DIR)/bob.jar
BOB_VERSION := 1.5.0
BOB_SHA256 := 0a7487f746c3278dc1f4159f20018fd74214d9982de958fdd4aa602d366f0977

RCEDIT_PATH := $(TOOLS_DIR)/rcedit.exe
RCEDIT_VERSION := 1.1.1
RCEDIT_SHA256 := 02e8e8c5d430d8b768980f517b62d7792d690982b9ba0f7e04163cbc1a6e7915

BUTLER_PATH := $(TOOLS_DIR)/butler/butler
BUTLER_VERSION := 15.21.0
BUTLER_SHA256 := af8fc2e7c4d4a2e2cb9765c343a88ecafc0dccc2257ecf16f7601fcd73a148ec

# Outputs

COMMON_DIST_LICENSE := $(DIST_DIR)/LICENSE.md

WINDOWS_ICON := $(WINDOWS_ASSETS_DIR)/icon.ico
WINDOWS_DIST_DIR := $(DIST_DIR)/windows
WINDOWS_DIST_APP := $(WINDOWS_DIST_DIR)/$(APP_NAME)
WINDOWS_DIST_EXE := $(WINDOWS_DIST_APP)/$(APP_NAME).exe
WINDOWS_DIST_ZIP := $(WINDOWS_DIST_DIR)/$(APP_NAME)-windows.zip

MACOS_ICONSET := $(MACOS_ASSETS_DIR)/icon.iconset
MACOS_ICON := $(MACOS_ASSETS_DIR)/icon.icns
MACOS_ARM_DIST_DIR := $(DIST_DIR)/macos-arm
MACOS_ARM_DIST_APP := $(MACOS_ARM_DIST_DIR)/$(APP_NAME).app
MACOS_ARM_DIST_DMG := $(MACOS_ARM_DIST_DIR)/$(APP_NAME)-macos-arm.dmg
MACOS_ARM_DIST_ZIP := $(MACOS_ARM_DIST_DIR)/$(APP_NAME)-macos-arm.zip
MACOS_X86_DIST_DIR := $(DIST_DIR)/macos-x86
MACOS_X86_DIST_APP := $(MACOS_X86_DIST_DIR)/$(APP_NAME).app
MACOS_X86_DIST_DMG := $(MACOS_X86_DIST_DIR)/$(APP_NAME)-macos-x86.dmg
MACOS_X86_DIST_ZIP := $(MACOS_X86_DIST_DIR)/$(APP_NAME)-macos-x86.zip

LINUX_DIST_DIR := $(DIST_DIR)/linux
LINUX_DIST_APP := $(LINUX_DIST_DIR)/$(APP_NAME)
LINUX_DIST_EXE := $(LINUX_DIST_APP)/$(APP_NAME).x86_64
LINUX_DIST_ZIP := $(LINUX_DIST_DIR)/$(APP_NAME)-linux.zip

IOS_XCASSETS := $(IOS_ASSETS_DIR)/Assets.xcassets
IOS_ICONSET := $(IOS_XCASSETS)/AppIcon.appiconset
IOS_ICONCAR := $(IOS_ASSETS_DIR)/Assets.car
IOS_ICONS := \
	$(IOS_ICONCAR) \
	$(IOS_ASSETS_DIR)/icon_76x76.png \
	$(IOS_ASSETS_DIR)/icon_120x120.png \
	$(IOS_ASSETS_DIR)/icon_152x152.png \
	$(IOS_ASSETS_DIR)/icon_167x167.png \
	$(IOS_ASSETS_DIR)/icon_180x180.png
IOS_ARM_DIST_DIR := $(DIST_DIR)/ios-arm
IOS_ARM_DIST_APP := $(IOS_ARM_DIST_DIR)/$(APP_NAME).app
IOS_ARM_DIST_ZIP := $(IOS_ARM_DIST_DIR)/$(APP_NAME)-ios-arm.zip
IOS_X86_DIST_DIR := $(DIST_DIR)/ios-x86
IOS_X86_DIST_APP := $(IOS_X86_DIST_DIR)/$(APP_NAME).app
IOS_X86_DIST_ZIP := $(IOS_X86_DIST_DIR)/$(APP_NAME)-ios-x86.zip

ANDROID_ICONS := \
	$(ANDROID_ASSETS_DIR)/icon_36x36.png \
	$(ANDROID_ASSETS_DIR)/icon_48x48.png \
	$(ANDROID_ASSETS_DIR)/icon_72x72.png \
	$(ANDROID_ASSETS_DIR)/icon_96x96.png \
	$(ANDROID_ASSETS_DIR)/icon_144x144.png \
	$(ANDROID_ASSETS_DIR)/icon_192x192.png \
	$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-mdpi/ic_launcher_fg.png \
	$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-hdpi/ic_launcher_fg.png \
	$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-xhdpi/ic_launcher_fg.png \
	$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-xxhdpi/ic_launcher_fg.png \
	$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-xxxhdpi/ic_launcher_fg.png
ANDROID_ARM_DIST_DIR := $(DIST_DIR)/android-arm
ANDROID_ARM_DIST_APP := $(ANDROID_ARM_DIST_DIR)/$(APP_NAME)
ANDROID_ARM_DIST_AAB := $(ANDROID_ARM_DIST_APP)/$(APP_NAME).aab
ANDROID_ARM_DIST_APK := $(ANDROID_ARM_DIST_APP)/$(APP_NAME).apk
ANDROID_ARM_DIST_ZIP := $(ANDROID_ARM_DIST_DIR)/$(APP_NAME)-android-arm.zip

WEB_SPLASH := $(WEB_ASSETS_DIR)/splash.png
WEB_DIST_DIR := $(DIST_DIR)/web
WEB_DIST_APP := $(WEB_DIST_DIR)/$(APP_NAME)
WEB_DIST_ZIP := $(WEB_DIST_DIR)/$(APP_NAME)-web.zip

# Targets

.PHONY: clean
clean:
	rm -rf "$(RESOLVE_DIR)"
	rm -rf "$(BUILD_DIR)"
	rm -rf "$(COVERAGE_DIR)"
	rm -rf "$(DIST_DIR)"
	rm -rf debug.*
	rm -rf manifest.*

.PHONY: test
test:
	$(MAKE) resolve
	$(MAKE) test-macos-arm

.PHONY: run
run:
	$(MAKE) resolve
	$(MAKE) run-macos-arm

.PHONY: dist
dist:
	$(MAKE) version
	$(MAKE) resolve
	$(MAKE) dist-common
	$(MAKE) dist-windows
	$(MAKE) dist-macos-arm
	$(MAKE) dist-macos-x86
	$(MAKE) dist-linux
	$(MAKE) dist-ios-arm
	$(MAKE) dist-ios-x86
	$(MAKE) dist-android-arm
	$(MAKE) dist-web

.PHONY: publish
publish:
	$(MAKE) publish-itchio

.PHONY: assets
assets: $(WINDOWS_ICON) $(MACOS_ICON) $(IOS_ICONS) $(ANDROID_ICONS) $(WEB_SPLASH)

# Test

.PHONY: test-windows
test-windows: $(BOB_PATH)
	mkdir -p "$(COVERAGE_DIR)"
	java -jar "$(BOB_PATH)" \
		--variant headless \
		--platform x86_64-win32 \
		build
	"$(BUILD_DIR)/x86_64-win32/dmengine.exe" --config="bootstrap.main_collection=/test/test.collectionc"

.PHONY: test-macos-arm
test-macos-arm: $(BOB_PATH)
	mkdir -p "$(COVERAGE_DIR)"
	java -jar "$(BOB_PATH)" \
		--variant headless \
		--platform arm64-macos \
		--architectures arm64-macos \
		build
	chmod +x "$(BUILD_DIR)/arm64-osx/dmengine"
	"$(BUILD_DIR)/arm64-osx/dmengine" --config="bootstrap.main_collection=/test/test.collectionc"

.PHONY: test-macos-x86
test-macos-x86: $(BOB_PATH)
	mkdir -p "$(COVERAGE_DIR)"
	java -jar "$(BOB_PATH)" \
		--variant headless \
		--platform x86_64-macos \
		--architectures x86_64-macos \
		build
	chmod +x "$(BUILD_DIR)/x86_64-osx/dmengine"
	"$(BUILD_DIR)/x86_64-osx/dmengine" --config="bootstrap.main_collection=/test/test.collectionc"

.PHONY: test-linux
test-linux: $(BOB_PATH)
	mkdir -p "$(COVERAGE_DIR)"
	java -jar "$(BOB_PATH)" \
		--variant headless \
		--platform x86_64-linux \
		build
	chmod +x "$(BUILD_DIR)/x86_64-linux/dmengine"
	"$(BUILD_DIR)/x86_64-linux/dmengine" --config="bootstrap.main_collection=/test/test.collectionc"

# Run

.PHONY: run-windows
run-windows: $(BOB_PATH)
	java -jar "$(BOB_PATH)" \
		--platform x86_64-win32 \
		build
	"$(BUILD_DIR)/x86_64-win32/dmengine.exe"

.PHONY: run-macos-arm
run-macos-arm: $(BOB_PATH)
	java -jar "$(BOB_PATH)" \
		--platform arm64-macos \
		--architectures arm64-macos \
		build
	chmod +x "$(BUILD_DIR)/arm64-osx/dmengine"
	rm "$(BUILD_DIR)/arm64-osx/Info.plist"
	"$(BUILD_DIR)/arm64-osx/dmengine"

.PHONY: run-macos-x86
run-macos-x86: $(BOB_PATH)
	java -jar "$(BOB_PATH)" \
		--platform x86_64-macos \
		--architectures x86_64-macos \
		build
	chmod +x "$(BUILD_DIR)/x86_64-osx/dmengine"
	rm "$(BUILD_DIR)/x86_64-osx/Info.plist"
	"$(BUILD_DIR)/x86_64-osx/dmengine"

.PHONY: run-linux
run-linux: $(BOB_PATH)
	java -jar "$(BOB_PATH)" \
		--platform x86_64-linux \
		build
	chmod +x "$(BUILD_DIR)/x86_64-linux/dmengine"
	"$(BUILD_DIR)/x86_64-linux/dmengine"

.PHONY: run-ios
run-ios: $(IOS_X86_DIST_APP)
	xcrun simctl install booted "$<"

.PHONY: run-android
run-android: $(ANDROID_ARM_DIST_APK)
	adb install "$<"

.PHONY: run-web
run-web: $(WEB_DIST_APP)
	python3 -m http.server -d "$<"

# Distributables

.PHONY: version
version:
	perl -i -pe 's/game_debug.appmanifest/game_release.appmanifest/g;' \
		-pe 's/0.0.0-development/$(APP_VERSION)/g;' \
		-pe 's/2100000000/$(subst .,,$(APP_VERSION))/g;' \
		game.project

resolve: $(RESOLVE_DIR)
dist-common: $(COMMON_DIST_LICENSE)
dist-windows: $(WINDOWS_DIST_ZIP)
dist-macos-arm: $(MACOS_ARM_DIST_ZIP) $(MACOS_ARM_DIST_DMG)
dist-macos-x86: $(MACOS_X86_DIST_ZIP) $(MACOS_X86_DIST_DMG)
dist-linux: $(LINUX_DIST_ZIP)
dist-ios-arm: $(IOS_ARM_DIST_ZIP)
dist-ios-x86: $(IOS_X86_DIST_ZIP)
dist-android-arm: $(ANDROID_ARM_DIST_ZIP)
dist-web: $(WEB_DIST_ZIP)

$(RESOLVE_DIR): $(BOB_PATH)
	java -jar "$(BOB_PATH)" resolve

$(COMMON_DIST_LICENSE): LICENSE.md
	mkdir -p `dirname "$@"`
	cp "$<" "$@"

## Windows (x86_64)

$(WINDOWS_DIST_ZIP): $(WINDOWS_DIST_EXE)
	(cd "$(dir $<)" && zip -rX "../$(notdir $@)" .)

$(WINDOWS_DIST_EXE): $(WINDOWS_ICON) $(BOB_PATH) $(RCEDIT_PATH)
	mkdir -p "$(WINDOWS_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(WINDOWS_DIST_DIR)/report.html" \
		--bundle-output "$(WINDOWS_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform x86_64-win32 \
		--architectures x86_64-win32 \
		distclean build bundle
	wine64 "$(RCEDIT_PATH)" "$@" --set-file-version "$(APP_VERSION)"
	wine64 "$(RCEDIT_PATH)" "$@" --set-product-version "$(APP_VERSION)"

## macOS (arm64)

$(MACOS_ARM_DIST_ZIP): $(MACOS_ARM_DIST_DMG)
	hdiutil attach "$<"
	ditto -c -k -rsrc --sequesterRsrc --keepParent "/Volumes/$(APP_NAME)/$(APP_NAME).app" "$@"
	hdiutil detach "/Volumes/$(APP_NAME)"

$(MACOS_ARM_DIST_DMG): $(MACOS_ARM_DIST_APP)
	mkdir -p "$(MACOS_ARM_DIST_DIR)"
	-npx --yes create-dmg --overwrite "$<" "$(MACOS_ARM_DIST_DIR)"
	mv "$(MACOS_ARM_DIST_DIR)"/*.dmg "$@"

$(MACOS_ARM_DIST_APP): $(MACOS_ICON) $(BOB_PATH)
	mkdir -p "$(MACOS_ARM_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(MACOS_ARM_DIST_DIR)/report.html" \
		--bundle-output "$(MACOS_ARM_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform arm64-macos \
		--architectures arm64-macos \
		distclean build bundle

## macOS (x86_64)

$(MACOS_X86_DIST_ZIP): $(MACOS_X86_DIST_DMG)
	hdiutil attach "$<"
	ditto -c -k -rsrc --sequesterRsrc --keepParent "/Volumes/$(APP_NAME)/$(APP_NAME).app" "$@"
	hdiutil detach "/Volumes/$(APP_NAME)"

$(MACOS_X86_DIST_DMG): $(MACOS_X86_DIST_APP)
	mkdir -p "$(MACOS_X86_DIST_DIR)"
	-npx --yes create-dmg --overwrite "$<" "$(MACOS_X86_DIST_DIR)"
	mv "$(MACOS_X86_DIST_DIR)"/*.dmg "$@"

$(MACOS_X86_DIST_APP): $(MACOS_ICON) $(BOB_PATH)
	mkdir -p "$(MACOS_X86_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(MACOS_X86_DIST_DIR)/report.html" \
		--bundle-output "$(MACOS_X86_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform x86_64-macos \
		--architectures x86_64-macos \
		distclean build bundle

## Linux (x86_64)

$(LINUX_DIST_ZIP): $(LINUX_DIST_EXE)
	(cd "$(dir $<)" && zip -rX "../$(notdir $@)" .)

$(LINUX_DIST_EXE): $(BOB_PATH)
	mkdir -p "$(LINUX_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(LINUX_DIST_DIR)/report.html" \
		--bundle-output "$(LINUX_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform x86_64-linux \
		--architectures x86_64-linux \
		distclean build bundle

## iOS (arm64)

$(IOS_ARM_DIST_ZIP): $(IOS_ARM_DIST_APP)
	ditto -c -k -rsrc --sequesterRsrc --keepParent "$<" "$@"

$(IOS_ARM_DIST_APP): $(IOS_ICONS) $(BOB_PATH)
	mkdir -p "$(IOS_ARM_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(IOS_ARM_DIST_DIR)/report.html" \
		--bundle-output "$(IOS_ARM_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform arm64-ios \
		--architectures arm64-ios \
		distclean build bundle

## iOS (x86_64)

$(IOS_X86_DIST_ZIP): $(IOS_X86_DIST_APP)
	ditto -c -k -rsrc --sequesterRsrc --keepParent "$<" "$@"

$(IOS_X86_DIST_APP): $(IOS_ICONS) $(BOB_PATH)
	mkdir -p "$(IOS_X86_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(IOS_X86_DIST_DIR)/report.html" \
		--bundle-output "$(IOS_X86_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform x86_64-ios \
		--architectures x86_64-ios \
		distclean build bundle

## Android (arm64)

$(ANDROID_ARM_DIST_ZIP): $(ANDROID_ARM_DIST_AAB) $(ANDROID_ARM_DIST_APK)
	(cd "$(dir $<)" && zip -rX "../$(notdir $@)" .)

$(ANDROID_ARM_DIST_AAB) $(ANDROID_ARM_DIST_APK): $(ANDROID_ICONS) $(BOB_PATH)
	mkdir -p "$(ANDROID_ARM_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(ANDROID_ARM_DIST_DIR)/report.html" \
		--bundle-output "$(ANDROID_ARM_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform armv7-android \
		--architectures arm64-android \
		--bundle-format aab,apk \
		distclean build bundle

## Web (wasm)

$(WEB_DIST_ZIP): $(WEB_DIST_APP)
	(cd "$<" && zip -rX "../$(notdir $@)" .)

$(WEB_DIST_APP): $(WEB_SPLASH) $(BOB_PATH)
	mkdir -p "$(WEB_DIST_DIR)"
	java -jar "$(BOB_PATH)" \
		--archive \
		--build-report-html "$(WEB_DIST_DIR)/report.html" \
		--bundle-output "$(WEB_DIST_DIR)" \
		--exclude-build-folder test \
		--texture-compression true \
		--platform js-web \
		--architectures wasm-web \
		distclean build bundle

# Publish

.PHONY: publish-itchio
publish-itchio:
	$(MAKE) publish-itchio-windows
	$(MAKE) publish-itchio-macos-arm
	$(MAKE) publish-itchio-macos-x86
	$(MAKE) publish-itchio-linux
	$(MAKE) publish-itchio-ios-arm
	$(MAKE) publish-itchio-ios-x86
	$(MAKE) publish-itchio-android
	$(MAKE) publish-itchio-web

.PHONY: publish-itchio-windows
publish-itchio-windows: $(WINDOWS_DIST_ZIP) $(BUTLER_PATH)
	echo -n "$(BUTLER_PATH) push $< $(BUTLER_PROJECT):windows --userversion $(APP_VERSION)" | base64
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):windows" --userversion "$(APP_VERSION)"

.PHONY: publish-itchio-macos-arm
publish-itchio-macos-arm: $(MACOS_ARM_DIST_APP) $(BUTLER_PATH)
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):macos-arm" --userversion "$(APP_VERSION)"

.PHONY: publish-itchio-macos-x86
publish-itchio-macos-x86: $(MACOS_X86_DIST_APP) $(BUTLER_PATH)
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):macos-x86" --userversion "$(APP_VERSION)"

.PHONY: publish-itchio-linux
publish-itchio-linux: $(LINUX_DIST_ZIP) $(BUTLER_PATH)
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):linux" --userversion "$(APP_VERSION)"

.PHONY: publish-itchio-ios-arm
publish-itchio-ios-arm: $(IOS_ARM_DIST_APP) $(BUTLER_PATH)
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):ios-arm" --userversion "$(APP_VERSION)"

.PHONY: publish-itchio-ios-x86
publish-itchio-ios-x86: $(IOS_X86_DIST_APP) $(BUTLER_PATH)
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):ios-x86" --userversion "$(APP_VERSION)"

.PHONY: publish-itchio-android
publish-itchio-android: $(ANDROID_ARM_DIST_ZIP) $(BUTLER_PATH)
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):android" --userversion "$(APP_VERSION)"

.PHONY: publish-itchio-web
publish-itchio-web: $(WEB_DIST_ZIP) $(BUTLER_PATH)
	"$(BUTLER_PATH)" push "$<" "$(BUTLER_PROJECT):web" --userversion "$(APP_VERSION)"

# Assets

MAGICK_CONVERT = magick convert "$<" \
	-interpolate Integer \
	-filter point \
	-resize `basename "$@" | perl -pe 's/^.+_(\d+)x(?:\1)(?:@(\d+)x)?.png$$/$$1*($$2||1)/e'` \
	"$@"

$(ASSETS_DIR)/icon_filled.png:;
$(ASSETS_DIR)/icon_rounded.png:;
$(ASSETS_DIR)/icon_transparent.png:;
$(ASSETS_DIR)/splash.png:;

$(WINDOWS_ASSETS_DIR)/%.png: $(ASSETS_DIR)/icon_rounded.png
	$(MAGICK_CONVERT)

$(MACOS_ASSETS_DIR)/%.png: $(ASSETS_DIR)/icon_rounded.png
	$(MAGICK_CONVERT)

$(ANDROID_BUNDLED_ASSETS_DIR)/%.png: $(ASSETS_DIR)/icon_transparent.png
	$(MAGICK_CONVERT)

$(ASSETS_DIR)/%.png: $(ASSETS_DIR)/icon_filled.png
	$(MAGICK_CONVERT)

$(WINDOWS_ICON): \
		$(WINDOWS_ASSETS_DIR)/icon_16x16.png \
		$(WINDOWS_ASSETS_DIR)/icon_32x32.png \
		$(WINDOWS_ASSETS_DIR)/icon_48x48.png \
		$(WINDOWS_ASSETS_DIR)/icon_64x64.png \
		$(WINDOWS_ASSETS_DIR)/icon_128x128.png \
		$(WINDOWS_ASSETS_DIR)/icon_256x256.png
	# `-compress jpeg` is a workaround for https://github.com/ImageMagick/ImageMagick/issues/1577
	magick convert $^ -compress jpeg "$@"

$(MACOS_ICON): \
		$(MACOS_ICONSET)/icon_16x16.png \
		$(MACOS_ICONSET)/icon_16x16@2x.png \
		$(MACOS_ICONSET)/icon_32x32.png \
		$(MACOS_ICONSET)/icon_32x32@2x.png \
		$(MACOS_ICONSET)/icon_48x48.png \
		$(MACOS_ICONSET)/icon_128x128.png \
		$(MACOS_ICONSET)/icon_128x128@2x.png \
		$(MACOS_ICONSET)/icon_256x256.png \
		$(MACOS_ICONSET)/icon_256x256@2x.png \
		$(MACOS_ICONSET)/icon_512x512.png \
		$(MACOS_ICONSET)/icon_512x512@2x.png
	iconutil -c icns -o "$@" "$(MACOS_ICONSET)"

$(IOS_ICONCAR): \
		$(IOS_ICONSET)/icon_40x40.png \
		$(IOS_ICONSET)/icon_58x58.png \
		$(IOS_ICONSET)/icon_60x60.png \
		$(IOS_ICONSET)/icon_76x76.png \
		$(IOS_ICONSET)/icon_80x80.png \
		$(IOS_ICONSET)/icon_87x87.png \
		$(IOS_ICONSET)/icon_114x114.png \
		$(IOS_ICONSET)/icon_120x120.png \
		$(IOS_ICONSET)/icon_128x128.png \
		$(IOS_ICONSET)/icon_136x136.png \
		$(IOS_ICONSET)/icon_152x152.png \
		$(IOS_ICONSET)/icon_167x167.png \
		$(IOS_ICONSET)/icon_180x180.png \
		$(IOS_ICONSET)/icon_192x192.png \
		$(IOS_ICONSET)/icon_1024x1024.png
	xcrun actool "$(IOS_XCASSETS)" \
		--compile "$(IOS_ASSETS_DIR)" \
		--platform iphoneos \
		--minimum-deployment-target 11.0 \
		--app-icon AppIcon \
		--output-partial-info-plist /dev/null \
		> /dev/null

$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-mdpi/ic_launcher_fg.png: $(ANDROID_ASSETS_DIR)/icon_48x48.png
	cp "$<" "$@"

$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-hdpi/ic_launcher_fg.png: $(ANDROID_ASSETS_DIR)/icon_72x72.png
	cp "$<" "$@"

$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-xhdpi/ic_launcher_fg.png: $(ANDROID_ASSETS_DIR)/icon_96x96.png
	cp "$<" "$@"

$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-xxhdpi/ic_launcher_fg.png: $(ANDROID_ASSETS_DIR)/icon_144x144.png
	cp "$<" "$@"

$(ANDROID_BUNDLED_ASSETS_DIR)/mipmap-xxxhdpi/ic_launcher_fg.png: $(ANDROID_ASSETS_DIR)/icon_192x192.png
	cp "$<" "$@"

$(WEB_SPLASH): $(ASSETS_DIR)/splash.png
	cp "$<" "$@"

# Misc

$(BOB_PATH):
	curl -L -o /tmp/bob.jar "https://github.com/defold/defold/releases/download/$(BOB_VERSION)/bob.jar"
	echo "$(BOB_SHA256) /tmp/bob.jar" | sha256sum --check
	mkdir -p `dirname "$(BOB_PATH)"`
	mv /tmp/bob.jar "$(BOB_PATH)"
	java -jar "$(BOB_PATH)" --version

$(RCEDIT_PATH):
	curl -L -o /tmp/rcedit.exe "https://github.com/electron/rcedit/releases/download/v$(RCEDIT_VERSION)/rcedit-x64.exe"
	echo "$(RCEDIT_SHA256) /tmp/rcedit.exe" | sha256sum --check
	mkdir -p `dirname "$(RCEDIT_PATH)"`
	mv /tmp/rcedit.exe "$(RCEDIT_PATH)"
	wine64 "$(RCEDIT_PATH)" --help

$(BUTLER_PATH):
	curl -L -o /tmp/butler.zip "https://broth.itch.ovh/butler/darwin-amd64/$(BUTLER_VERSION)/archive/default"
	echo "$(BUTLER_SHA256) /tmp/butler.zip" | sha256sum --check
	mkdir -p `dirname "$(BUTLER_PATH)"`
	unzip /tmp/butler.zip -d `dirname "$(BUTLER_PATH)"`
	rm /tmp/butler.zip
	"$(BUTLER_PATH)" --version
