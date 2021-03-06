[Variables]
; SaveLocation="#@#Vars.ini"

; ---------------------------------------------------------------------------- ;
;                                   Functions                                  ;
; ---------------------------------------------------------------------------- ;


[Preset:M]
Measure=Script
ScriptFile=#@#Lua\PresetLoad.lua

[String:S]
LeftMouseUpAction=[!CommandMeasure Preset:M "ChangeTo('#CURRENTSECTION#')"][!Refresh "#JaxCore\Main"][!DeactivateConfig]

; ---------------------------------------------------------------------------- ;
;                                    Content                                   ;
; ---------------------------------------------------------------------------- ;

[Normal]
Meter=String
Y=(#Sec.P#)
MeterStyle=String:S
[Div:1]
Meter=Shape
MeterStyle=Div:S
[Frosted]
Meter=String
MeterStyle=String:S
[Div:2]
Meter=Shape
MeterStyle=Div:S
[Light]
Meter=String
MeterStyle=String:S
[Div:3]
Meter=Shape
MeterStyle=Div:S
[Amoled]
Meter=String
MeterStyle=String:S
[Div:4]
Meter=Shape
MeterStyle=Div:S
[Classic]
Meter=String
MeterStyle=String:S
[Div:5]
Meter=Shape
MeterStyle=Div:S
[Runic]
Meter=String
FontFace=Runic
MeterStyle=String:S