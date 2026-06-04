#!/bin/bash

svn checkout https://repos.wowace.com/wow/libstub/tags/1.0 ./libs/LibStub
svn checkout https://repos.wowace.com/wow/callbackhandler/trunk/CallbackHandler-1.0 ./libs/CallbackHandler-1.0
svn checkout https://repos.wowace.com/wow/ace3/trunk/AceAddon-3.0 ./libs/AceAddon-3.0
svn checkout https://repos.wowace.com/wow/ace3/trunk/AceDB-3.0 ./libs/AceDB-3.0
svn checkout https://repos.wowace.com/wow/ace3/trunk/AceDBOptions-3.0 ./libs/AceDBOptions-3.0
svn checkout https://repos.wowace.com/wow/ace3/trunk/AceHook-3.0 ./libs/AceHook-3.0
svn checkout https://repos.wowace.com/wow/ace3/trunk/AceGUI-3.0 ./libs/AceGUI-3.0
svn checkout https://repos.wowace.com/wow/ace3/trunk/AceConsole-3.0 ./libs/AceConsole-3.0
svn checkout https://repos.wowace.com/wow/ace3/trunk/AceConfig-3.0 ./libs/AceConfig-3.0
git clone https://github.com/tekkub/libdatabroker-1-1 ./libs/LibDataBroker-1.1
svn checkout https://repos.wowace.com/wow/libsharedmedia-3-0/trunk/LibSharedMedia-3.0 ./libs/LibSharedMedia-3.0
svn checkout https://repos.wowace.com/wow/ace-gui-3-0-shared-media-widgets/trunk/AceGUI-3.0-SharedMediaWidgets ./libs/AceGUI-3.0-SharedMediaWidgets

# WoW 12.x requires a numeric wrap arg to tooltip:AddLine; Ace3 upstream still passes boolean true.
# Remove this once https://repos.wowace.com/wow/ace3 fixes AceConfigDialog-3.0.
sed -i 's/, true)$/, 1)/g' \
  ./libs/AceConfig-3.0/AceConfigDialog-3.0/AceConfigDialog-3.0.lua

# WoW 12.x no longer auto-populates hash_SlashCmdList from SLASH_* globals.
# Remove this once https://repos.wowace.com/wow/ace3 fixes AceConsole-3.0.
sed -i 's/_G\["SLASH_"\.\.name\.\."1"\] = "\/"\.\.command:lower()/_G["SLASH_"..name.."1"] = "\/"..command:lower()\n\thash_SlashCmdList["\/"..command:upper()] = name/' \
  ./libs/AceConsole-3.0/AceConsole-3.0.lua
