
[LoadActions]
ActionList1=Start0 | Wait 2000 | Start1 | Custom1 | Wait 1000 | NextPage
Custom1=[!CommandMeasure CheckForDataFolder "Check-Data"]

[Tween:M]
Measure=Script
ScriptFile=#@#LuaTween/Main.lua
TweenGroup=Tweenable
Tween0=Single | Variable | TweenNode1 | 0 | 1 | 1700
Tween1=Single | Variable | TweenNode2 | 0 | 1 | 750
Optional0=Easing InOutExpo
Optional1=Easing InOutExpo
UpdateDivider=1

[Set.string:S]
Container=ContentContainer

[CheckForDataFolder]
MEasure=Plugin
Plugin=PowershellRM
DynamicVariables=1
ScriptFile=#@#Powershell\CheckData.ps1


; ---------------------------------------------------------------------------- ;
;                                   Contenet                                   ;
; ---------------------------------------------------------------------------- ;

[SpinImage]
MEter=Image
X=(#Sec.W#/2-256*#Sec.S#*#TweenNode1#/2+415.5*#Sec.S#*#TweenNode2#)
Y=(#Sec.H#/2-256*#Sec.S#*#TweenNode1#/2-109*#Sec.S#*#TweenNode2#)
W=((256*#TweenNode1#-206*#TweenNode2#)*#Sec.S#)
H=((256*#TweenNode1#-206*#TweenNode2#)*#Sec.S#)
DynamicVariables=1
Group=Tweenable
Container=ContentContainer
TransformationMatrix=(Cos(Rad(#TweenNode1#*360)));(-Sin(Rad(#TweenNode1#*360)));(Sin(Rad(#TweenNode1#*360)));(Cos(Rad(#TweenNode1#*360)));(([#CURRENTSECTION#:W]*0.5+[#CURRENTSECTION#:X])-([#CURRENTSECTION#:W]*0.5+[#CURRENTSECTION#:X])*Cos(Rad(#TweenNode1#*360))-([#CURRENTSECTION#:H]*0.5+[#CURRENTSECTION#:Y])*Sin(Rad(#TweenNode1#*360)));(([#CURRENTSECTION#:H]*0.5+[#CURRENTSECTION#:Y])+([#CURRENTSECTION#:W]*0.5+[#CURRENTSECTION#:X])*Sin(Rad(#TweenNode1#*360))-([#CURRENTSECTION#:H]*0.5+[#CURRENTSECTION#:Y])*Cos(Rad(#TweenNode1#*360)))
ImageName=#@#Images\CoreAssets\#Set.IconStyle#Logo256.png

[Logo]
Meter=

[CheckForIdle]
Measure=Calc
Formula=CheckForIdle + 1
IfCondition=CheckForIdle >= 20
IfTrueAction=[!CommandMEasure CoreBridge "start('', 'An error had occured', [[Welcoming page failed to display properly.]], '', '5000')"][!WriteKeyValue Variables UserNameCheckVariable "[MeasureUser]" "#@#Vars.inc"][!WriteKeyValue Variables Sec.Page 1 "#ROOTCONFIGPATH#Main\Home.ini"][!ActivateConfig "#JaxCore\Main" "Home.ini"][!DeactivateConfig]
DynamicVariables=1
UpdateDivider=20
[CoreBridge]
Measure=Script
ScriptFile=#SKINSPATH##JaxCore\@Resources\Lua\CoreElements\Toast.lua
[MeasureUser]
Measure=Plugin
Plugin=SysInfo
SysInfoType=USER_NAME
UpdateDivider=-1