

    local H = {}

    H.Minimap_Update = Minimap_Update

    local OnMouseWheel = function()
        if not arg1 then return end
        if  arg1 > 0   and  Minimap:GetZoom() < 5 then
            Minimap:SetZoom(Minimap:GetZoom() + 1)
        elseif arg1 < 0 and Minimap:GetZoom() > 0 then
            Minimap:SetZoom(Minimap:GetZoom() - 1)
        end
    end

    local Update = function()
        H.Minimap_Update()
		if  MinimapZoneText:GetStringWidth() > 128 then
			local t = gsub(GetMinimapZoneText(), '(%u)%S* %l*%s*', '%1. ')
			MinimapZoneText:SetText(t)
			if  MinimapZoneText:GetStringWidth() > 115 then
				t =   gsub(GetMinimapZoneText(), '(%a)([%w_\']*)', '%1.')
				MinimapZoneText:SetText(t)
			end
		end
	end

    local PLAYER_LOGIN = function()
        local f = CreateFrame('Frame', nil, Minimap)
        f:EnableMouse(false)
        f:SetPoint('TOPLEFT', Minimap)
        f:SetPoint('BOTTOMRIGHT', Minimap)
        f:EnableMouseWheel(true)
        f:SetScript('OnMouseWheel', OnMouseWheel)

        MiniMapTrackingFrame:SetFrameStrata'MEDIUM'
        MiniMapTrackingFrame:ClearAllPoints()
        MiniMapTrackingFrame:SetPoint('TOP', 45, -6)

        GameTimeFrame:SetScale(.76)
        GameTimeFrame:ClearAllPoints() 
        GameTimeFrame:SetPoint('BOTTOM', Minimap, 0, -24)
        GameTimeFrame:Hide()
        GameTimeFrame.HOnEnter = GameTimeFrame:GetScript'OnEnter'

        GameTimeFrame:SetScript('OnEnter', function()
            GameTimeFrame:HOnEnter()
            this:Show()
        end)
        GameTimeFrame:SetScript('OnLeave', function()
            GameTooltip:Hide()
            if  GetMouseFocus() ~= 'Minimap' then 
                this:Hide() 
            end
        end)

        MiniMapBattlefieldFrame:ClearAllPoints()
        MiniMapBattlefieldFrame:SetPoint('BOTTOMLEFT', 2, 8)

        MiniMapMailFrame:SetScale(1.22)
        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint('TOPLEFT', 0, -7)

        MinimapZoneText:ClearAllPoints()
        MinimapZoneText:SetPoint('TOP', Minimap, 0, 17)

        Update()

        for _, v in pairs(
            {
                MinimapBorderTop,
                MinimapToggleButton,
                MinimapZoomIn,
        	    MinimapZoomOut
            }
        ) do
            v:Hide()
        end
    end

    local OnEnter = function()
        GameTimeFrame:Show()
    end

    local OnLeave = function()
        GameTimeFrame:Hide()
    end

    Minimap_Update = Update
    
    Minimap:SetScript('OnEnter', OnEnter)
    Minimap:SetScript('OnLeave', OnLeave)
    
    MinimapCluster:SetScript('OnEnter', OnEnter)
    MinimapCluster:SetScript('OnLeave', OnLeave)

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', PLAYER_LOGIN)

    --
