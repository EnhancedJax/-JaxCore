function GetSkin(skin)
    skin = (skin:lower() == 'jaxcore') and ('#' .. skin) or skin
    SKIN:Bang('[!SetVariable Skin.Name "' .. skin .. '"]')
    SKIN:Bang('[!UpdateMeasure mActions][!CommandMeasure mActions "Execute 1"]')
end

function finalize(skin)
    SKIN:Bang('[!SetVariable Skin.Name "' .. skin .. '"]')
    SKIN:Bang('[!UpdateMeasure mActions][!CommandMeasure mActions "Execute 2"]')
end