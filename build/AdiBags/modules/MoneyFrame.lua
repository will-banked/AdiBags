--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local C_CurrencyInfo = _G.C_CurrencyInfo
local CreateFrame = _G.CreateFrame
local GetMoney = _G.GetMoney
local max = _G.max
local NumberFontNormal = _G.NumberFontNormal
local NumberFontNormalLarge = _G.NumberFontNormalLarge
--GLOBALS>

local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString

local mod = addon:NewModule('MoneyFrame', 'ABEvent-1.0')
mod.uiName = L['Money']
mod.uiDesc = L['Display character money at bottom right of the backpack.']

function mod:OnInitialize()
	self.db = addon.db:RegisterNamespace(
		self.moduleName,
		{
			profile = {
				small = false,
			}
		}
	)
end

function mod:OnEnable()
	addon:HookBagFrameCreation(self, 'OnBagFrameCreated')
	if self.widget then
		self.widget:Show()
		self:UpdateMoney()
	end
end

function mod:OnDisable()
	if self.widget then
		self.widget:Hide()
	end
end

function mod:OnBagFrameCreated(bag)
	if bag.bagName ~= "Backpack" then return end
	local frame = bag:GetFrame()

	local widget = CreateFrame("Button", addonName.."MoneyFrame", frame)
	self.widget = widget
	widget:RegisterForClicks("RightButtonUp")
	widget:SetScript('OnClick', function() self:OpenOptions() end)
	addon.SetupTooltip(widget, { L['Money'], L['Right-click to configure.'] }, "ANCHOR_BOTTOMRIGHT")

	local moneyText = widget:CreateFontString(nil, "OVERLAY")
	moneyText:SetFontObject(self.db.profile.small and NumberFontNormal or NumberFontNormalLarge)
	moneyText:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -2, 0)
	self.moneyText = moneyText

	self:RegisterEvent("PLAYER_MONEY", "UpdateMoney")
	self:UpdateMoney()

	frame:AddBottomWidget(widget, "RIGHT", 50)
end

function mod:UpdateMoney()
	if not self.moneyText then return end
	self.moneyText:SetText(GetCoinTextureString(GetMoney()))
	self.widget:SetSize(
		max(self.moneyText:GetStringWidth() + 4, 0.1),
		max(self.moneyText:GetStringHeight(), 0.1)
	)
end

function mod:GetOptions()
	return {
		small = {
			name = L['Small'],
			desc = L['Display a smaller money frame. This setting will take effect on next reload.'],
			type = 'toggle',
			order = 10,
		},
	}, addon:GetOptionHandler(self, false)
end
