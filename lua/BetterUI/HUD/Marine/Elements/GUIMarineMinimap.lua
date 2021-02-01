Script.Load("lua/BetterUI/HUD/GUIPlayerHUDElement.lua")

class 'GUIMarineMinimap' (GUIPlayerHUDElement)

GUIMarineMinimap.kMinimapBorderTexture = PrecacheAsset("ui/marine_HUD_minimap.dds")
GUIMarineMinimap.kMinimapMinimalBorderTexture = PrecacheAsset("ui/marine_HUD_minimap_minimal.dds")

GUIMarineMinimap.kMinimapBackgroundTextureCoords = { 0, 0, 400, 256 }
GUIMarineMinimap.kMinimapScanlineTextureCoords = { 0, 0, 400, 128 }
GUIMarineMinimap.kMinimapScanTextureCoords = { GUIMarineMinimap.kMinimapBackgroundTextureCoords[3], 2 * GUIMarineMinimap.kMinimapBackgroundTextureCoords[4], 2 * GUIMarineMinimap.kMinimapBackgroundTextureCoords[3], 3 * GUIMarineMinimap.kMinimapBackgroundTextureCoords[4] }
GUIMarineMinimap.kMinimapStencilTextureCoords = { GUIMarineMinimap.kMinimapBackgroundTextureCoords[3], 3 * GUIMarineMinimap.kMinimapBackgroundTextureCoords[4], 2 * GUIMarineMinimap.kMinimapBackgroundTextureCoords[3], 4 * GUIMarineMinimap.kMinimapBackgroundTextureCoords[4] }
GUIMarineMinimap.kMinimapBackgroundSize = Vector( GUIMarineMinimap.kMinimapBackgroundTextureCoords[3] - GUIMarineMinimap.kMinimapBackgroundTextureCoords[1], GUIMarineMinimap.kMinimapBackgroundTextureCoords[4] - GUIMarineMinimap.kMinimapBackgroundTextureCoords[2], 0 )

GUIMarineMinimap.kStencilSize = Vector(400, 256, 0)
GUIMarineMinimap.kStencilPos = Vector(0, 128, 0)
GUIMarineMinimap.kMinimapScanStartPos = Vector(0, - 128, 0)
GUIMarineMinimap.kMinimapScanEndPos = Vector(0, GUIMarineMinimap.kMinimapBackgroundSize.y + 512, 0)


function GUIMarineMinimap:Initialize(parentScript, frame, pos, anchor)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, pos)
    
    self.minimapBackground = self.parentScript:CreateAnimatedGraphicItem()
    self.minimapBackground:SetTexture(GUIMarineMinimap.kMinimapBorderTexture)
    self.minimapBackground:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineMinimap.kMinimapScanTextureCoords))
    if anchor then self.minimapBackground:SetAnchor(anchor.x, anchor.y) end
    self.minimapBackground:SetColor( Color( 1, 1, 1, 1 ) )
    self.minimapBackground:SetLayer(kGUILayerPlayerHUDForeground1)
    self.frame:AddChild(self.minimapBackground)

    self.minimapStencil = GetGUIManager():CreateGraphicItem()
    self.minimapStencil:SetColor( Color(1, 1, 1, 1) )
    self.minimapStencil:SetIsStencil(true)
    self.minimapStencil:SetClearsStencilBuffer(false)
    -- self.minimapStencil:SetTexture(ConditionalValue(minimal, kMinimapMinimalBorderTexture, kMinimapBorderTexture))
    self.minimapStencil:SetTexture(GUIMarineMinimap.kMinimapBorderTexture)
    self.minimapStencil:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineMinimap.kMinimapStencilTextureCoords))
    self.minimapStencil:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.minimapBackground:AddChild(self.minimapStencil)
    
    self.minimapScript = GetGUIManager():CreateGUIScript("GUIMinimapFrame")
    self.minimapScript:ShowMap(true)
    self.minimapScript:SetBackgroundMode(GUIMinimapFrame.kModeZoom)
    -- skip updating icons outside this radius; saves CPU. Radius is heuristic;
    -- measured as when items just start disappearing in the corners
    self.minimapScript.updateRadius = 145
    -- the updateIntervalMultiplier is by default set to zero which runs the minimap at close to full framerate
    -- setting it to 1 causes things to work pretty well for the marine HUD
    self.minimapScript.updateIntervalMultipler = 1

    self:RefreshMinimapZoom()
    
    -- we need an additional frame here since all positions are relative in the minimap script (due to zooming)
    self.minimapFrame = GetGUIManager():CreateGraphicItem()
    self.minimapFrame:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.minimapFrame:AddChild(self.minimapScript:GetBackground())
    self.minimapFrame:SetColor( Color( 1, 1, 1, 0 ) )
    
    self.minimapScanLines = self.parentScript:CreateAnimatedGraphicItem()
    self.minimapScanLines:SetTexture(GUIMarineMinimap.kMinimapBorderTexture)
    self.minimapScanLines:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineMinimap.kMinimapScanlineTextureCoords))
    self.minimapScanLines:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.minimapScanLines:SetColor( Color( 1, 1, 1, 1 ) )
    self.minimapScanLines:SetLayer(1)
    self.minimapScanLines:SetBlendTechnique(GUIItem.Add)
    self.minimapScanLines:SetStencilFunc(GUIItem.NotEqual)
    self.minimapBackground:AddChild(self.minimapScanLines)
    
    self.minimapBackground:AddChild(self.minimapFrame)

    self:Reset(parentScript.scale)
end

function GUIMarineMinimap:Uninitialize()
    if self.minimapScript then
        GetGUIManager():DestroyGUIScript(self.minimapScript)
        self.minimapScript = nil
    end
    
    if self.minimapBackground then
        self.minimapBackground:Destroy()
        self.minimapBackground = nil
    end
    
    if self.minimapFrame then
        GUI.DestroyItem(self.minimapFrame)
        self.minimapFrame = nil
    end
end

local kMinUserZoomRoot = math.sqrt(0.3)
local kMaxUserZoomRoot = math.sqrt(1.0)
local kDefaultZoom = 0.75
function GUIMarineMinimap:RefreshMinimapZoom()
    if self.minimapScript then
        local normRoot = Clamp( Client.GetOptionFloat("minimap-zoom", kDefaultZoom), 0, 1 )
        local root = (1-normRoot) * kMinUserZoomRoot + normRoot*kMaxUserZoomRoot
        self.minimapScript:SetDesiredZoom( root * root )
    end
end

function GUIMarineMinimap:Reset(scale)
    self.minimapBackground:SetUniformScale(scale)
    self.minimapBackground:SetSize(GUIMarineMinimap.kMinimapBackgroundSize)
    self.minimapBackground:SetPosition(self.position)
    self.minimapBackground:SetColor( Color( 1, 1, 1, 1 ) )

    self.minimapStencil:SetSize(scale * GUIMarineMinimap.kStencilSize)
    self.minimapStencil:SetPosition( scale * (-GUIMarineMinimap.kStencilSize/2 + GUIMarineMinimap.kStencilPos) )

    self.minimapScanLines:SetUniformScale(scale)
    self.minimapScanLines:SetSize(GUIMarineMinimap.kMinimapBackgroundSize)
    
    self.minimapFrame:SetPosition(Vector(-190, -180, 0) * scale)
    
    self.minimapScanLines:SetPosition(GUIMarineMinimap.kMinimapScanStartPos)
    self.minimapScanLines:SetPosition(GUIMarineMinimap.kMinimapScanEndPos, 4, "MINIMAP_SCANLINE_ANIM", AnimateLinear, ScanLineAnim)
    self.minimapScanLines:SetColor( Color( 1, 1, 1, 1 ) )
end

local function ScanLineAnim(script, item)
    item:SetPosition(GUIMarineMinimap.kMinimapScanStartPos)
    item:SetPosition(GUIMarineMinimap.kMinimapScanEndPos, 4, "MINIMAP_SCANLINE_ANIM", AnimateLinear, ScanLineAnim)
end

function GUIMarineMinimap:Update(deltaTime)
end

function GUIMarineMinimap:GetElementToMove()
    return self.minimapBackground
end
