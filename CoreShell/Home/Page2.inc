[variables]
@includeVars=#@#Vars.inc

[BC]
MouseScrollDownAction=[!SetVariable Scroll "(Clamp(#Scroll#+20,0,(#Set.PageH#-#Set.H#)))"][!UpdateMeter *][!Redraw]
MouseScrollUpAction=[!SetVariable Scroll "(Clamp(#Scroll#-20,0,(#Set.PageH#-#Set.H#)))"][!UpdateMeter *][!Redraw]

; ---------------------------------------------------------------------------- ;
;                                   Functions                                  ;
; ---------------------------------------------------------------------------- ;


; ---------------------------------------------------------------------------- ;
;                                 Meter styles                                 ;
; ---------------------------------------------------------------------------- ;

; ---------------------------------------------------------------------------- ;
;                                    Content                                   ;
; ---------------------------------------------------------------------------- ;
[BarClip]
Fill=Fill Color #Set.Pri_Color#,(#Scroll# > 0 ? 255 : 0)

[Image]
Meter=Image
W=(#Set.W#)
H=(#Set.H#*0.6)
ImageAlpha=(#Scroll# > 0 ? 0 : 50)
PreserveAspectRatio=2
DynamicVariables=1
ImageName=#@#Images\NewsPreview.png
MaskImageName=#@#Images\FadeMask.png
Container=BC

[title.Text1]
Meter=String
MeterStyle=Set.String:S
Text=QuickNote released!
X=(#Set.W#/2)
Y=((110*[Set.S])-#Scroll#)
FontSize=(40*[Set.S])
FontFace=#Set.Font# 
FontWeight=(650)
StringAlign=Center
InlineSetting=GradientColor | 180 | #Set.Accent_Color# ; 0.0 | #Set.Accent_Color_2# ; 1.0

[Text.1]
Meter=String
MeterStyle=Set.String:S
X=r
Y=(100*[Set.S])r
W=(#Set.W#*0.8)
H=(#Set.H#*0.5)
Clipstring=1
StringAlign=Center
Text=QuickNote have been released! Head over to the skins page and install it!#CRLF##CRLF#Top choice for improving your productivity. Allows easy row manipulation with smooth transitional animations, built in checklist to make a to-do list, and 5 different slots for you to save notes. You can also choose to be able to summon it with a hotkey or by dragging from the top-left corner.#CRLF##CRLF#If you want to support me, buy me a cup of coffee on ko-fi, or join my discord server and hang out!
InlinePattern=Head over to the skins page and install it!|increasing your productivity
InlineSetting=Color | #Set.Accent_Color#
InlinePattern2=ko-fi
InlineSetting2=Color | FFA56D
InlinePattern3=discord server
InlineSetting3=Color | 88,101,242

[Button:S]
Shape=Rectangle 0,0,200,40,(#Set.R#/2) | StrokeWidth 0 | Scale [Set.S],[Set.S],0,0 | Extend THis
[ButtonText:S]
X=(200/2*[Set.S])r

[SkinsButton]
Meter=Shape
X=(#Set.W#/2-(200*2*[Set.S]+#Set.P#/2)/2)
Y=(200*[Set.S])r
MeterStyle=Shape.Over:S | Button:S
OverColor=FFA56D
LeaveColor=FFA56D
Leftmouseupaction=[!commandMeasure Func "startPopup('Donate')"]
[SkinsText]
Meter=String
Text=Ko-fi page
MeterStyle=Set.String:S | ButtonText:S

[DiscordButton]
Meter=Shape
X=(200/2*[Set.S]+#Set.P#/2)r
Y=(-20*[Set.S])r
MeterStyle=Shape.Over:S | Button:S
OverColor=88,101,242
LeaveColor=88,101,242
Leftmouseupaction=[!commandMeasure Func "startPopup('Discord')"]
[DiscordText]
Meter=String
Text=Join the community!
MeterStyle=Set.String:S | ButtonText:S

; ------------------------------------- 2 ------------------------------------ ;



; [title.Text2]
; Meter=String
; MeterStyle=Set.String:S
; Text=Change log
; X=(#Set.W#/2)
; Y=(30*[Set.S])R
; FontSize=(20*[Set.S])
; FontFace=#Set.Font# 
FontWeight=(650)
; StringAlign=Center
; InlineSetting=GradientColor | 180 | #Set.Accent_Color# ; 0.0 | #Set.Accent_Color_2# ; 1.0

; [Text.2]
; Meter=String
; MeterStyle=Set.String:S
; X=r
; Y=(40*[Set.S])r
; W=(#Set.W#*0.8)
; H=(#Set.H#*0.5)
; Clipstring=1
; StringAlign=Center
; Text=3620 - ValliStart: You can toggle monitor configuration section off and open the start menu by clicking on a desired key#CRLF#3611 - added customization support for Plainext1.6#CRLF#3611 - added hidden button to skip start animation in case it broke