[;InitNotSection]
[General:Category]
Meter = String
MeterStyle = Set.String:S | Pagecat:S
Text = GENERAL
Y = (#Set.P#+64*[Set.S])

[General]
Meter = Shape
Y = (10*[Set.S])R
MeterStyle = PageBox:S
Fill = Fill Color #Set.Accent_Color#,(#BarHandler# = 2 ? 255: 0)
Handle = 2
[GeneralIcon]
Meter = Image
MeterStyle = PageIcon:S
[2]
Meter = String
Text = General
MeterStyle = Set.String:S | PageText:S

[Appearance]
Meter = Shape
Y = (10*[Set.S])R
MeterStyle = PageBox:S
Fill = Fill Color #Set.Accent_Color#,(#BarHandler# = 3 ? 255: 0)
Handle = 3
[AppearanceIcon]
Meter = Image
MeterStyle = PageIcon:S
[3]
Meter = String
Text = Appearance
MeterStyle = Set.String:S | PageText:S

[Addons]
Meter = Shape
Y = (10*[Set.S])R
MeterStyle = PageBox:S
Fill = Fill Color #Set.Accent_Color#,(#BarHandler# = 81 ? 255: 0)
Handle = 81
[AddonsIcon]
Meter = Image
MeterStyle = PageIcon:S
[81]
Meter = String
Text = Addons
MeterStyle = Set.String:S | PageText:S

[Language]
Meter = Shape
Y = (10*[Set.S])R
MeterStyle = PageBox:S
Fill = Fill Color #Set.Accent_Color#,(#BarHandler# = 82 ? 255: 0)
Handle = 82
[LanguageIcon]
Meter = Image
MeterStyle = PageIcon:S
[82]
Meter = String
Text = Language
MeterStyle = Set.String:S | PageText:S
