# Universal Makefile for SteamworksPy (Windows, macOS, Linux)
# Usage: make [windows|linux|macos]


# SDK root is now ./sdk (extract Steamworks SDK here)
STEAMWORKSPY_SRC = library/SteamworksPy.cpp
STEAMWORKS_SDK = sdk
STEAMWORKS_INC = $(STEAMWORKS_SDK)/public/steam
WIN_REDIST = $(STEAMWORKS_SDK)/redistributable_bin/win64
LINUX_REDIST = $(STEAMWORKS_SDK)/redistributable_bin/linux64
MAC_REDIST = $(STEAMWORKS_SDK)/redistributable_bin/osx

OUT_DIR = steamworks
WIN_OUT = $(OUT_DIR)/SteamworksPy64.dll
LINUX_OUT = $(OUT_DIR)/SteamworksPy.so
MAC_OUT_INTEL = $(OUT_DIR)/SteamworksPy_x86_64.dylib
MAC_OUT_ARM = $(OUT_DIR)/SteamworksPy_arm64.dylib
MAC_OUT = $(OUT_DIR)/SteamworksPy.dylib

WIN_LIB = $(WIN_REDIST)/steam_api64.lib
WIN_DLL = $(WIN_REDIST)/steam_api64.dll
LINUX_LIB = $(LINUX_REDIST)/libsteam_api.so
MAC_LIB = $(MAC_REDIST)/libsteam_api.dylib

all: help

windows: $(WIN_OUT)
linux: $(LINUX_OUT)

macos: $(MAC_OUT)
macos_intel: $(MAC_OUT_INTEL)
macos_arm: $(MAC_OUT_ARM)

$(WIN_OUT): $(STEAMWORKSPY_SRC) $(WIN_LIB) $(WIN_DLL)
	@echo "[*] Building for Windows (MinGW-w64 g++ required)"
	@mkdir -p $(OUT_DIR)
	g++ -std=c++11 -shared -o $@ $(STEAMWORKSPY_SRC) -I$(STEAMWORKS_INC) $(WIN_LIB)
	cp $(WIN_DLL) $(OUT_DIR)/
	cp $(WIN_LIB) $(OUT_DIR)/

$(LINUX_OUT): $(STEAMWORKSPY_SRC) $(LINUX_LIB)
	@echo "[*] Building for Linux"
	@mkdir -p $(OUT_DIR)
	g++ -std=c++11 -shared -fPIC -o $@ $(STEAMWORKSPY_SRC) -I$(STEAMWORKS_INC) $(LINUX_LIB)

$(MAC_OUT_INTEL): $(STEAMWORKSPY_SRC) $(MAC_LIB)
	@echo "[*] Building for macOS Intel (x86_64)"
	@mkdir -p $(OUT_DIR)
	g++ -std=c++11 -dynamiclib -arch x86_64 -o $@ $(STEAMWORKSPY_SRC) -I$(STEAMWORKS_INC) $(MAC_LIB)
	cp -n $(MAC_LIB) $(OUT_DIR)/

$(MAC_OUT_ARM): $(STEAMWORKSPY_SRC) $(MAC_LIB)
	@echo "[*] Building for macOS ARM (arm64)"
	@mkdir -p ${OUT_DIR}
	g++ -std=c++11 -dynamiclib -arch arm64 -o $@ $(STEAMWORKSPY_SRC) -I$(STEAMWORKS_INC) $(MAC_LIB)
	cp -n $(MAC_LIB) $(OUT_DIR)/

$(MAC_OUT): $(MAC_OUT_INTEL) $(MAC_OUT_ARM)
	@echo "[*] Creating universal macOS binary"
	lipo -create -output $@ $(MAC_OUT_INTEL) $(MAC_OUT_ARM)
	cp -n $(MAC_LIB) $(OUT_DIR)/

clean:
	rm -rf _build_*
	rm -rf $(OUT_DIR)/*.lib
	rm -rf $(OUT_DIR)/*.dll
	rm -rf $(OUT_DIR)/*.so
	rm -rf $(OUT_DIR)/*.dylib

help:
	@echo "Usage: make [windows|linux|macos|macos_intel|macos_arm|clean]"
	@echo "  windows:     Build DLL for Windows (requires MinGW-w64 g++)"
	@echo "  linux:       Build SO for Linux"
	@echo "  macos:       Build universal DYLIB for macOS (x86_64 + arm64)"
	@echo "  macos_intel: Build DYLIB for macOS Intel only"
	@echo "  macos_arm:   Build DYLIB for macOS ARM only"
	@echo "  clean:       Remove build artifacts"
