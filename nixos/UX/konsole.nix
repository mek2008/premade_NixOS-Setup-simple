{  ...  }:
{
environment.etc."xdg/konsole/mk.profile".text = ''
[Appearance]
ColorScheme=NixDark
Font=JetBrainsMono Nerd Font,9,-1,5,50,0,0,0,0,0

[General]
Name=mk
Parent=FALLBACK/

[Scrolling]
HistoryMode=1
HistorySize=2500
ScrollBarPosition=2

[Terminal Features]
BlinkingCursorEnabled=true
'';


environment.etc."xdg/konsole/NixDark.colorscheme".text = ''
[Background]
Color=10,10,20

[BackgroundIntense]
Color=20,20,40

[Foreground]
Color=220,220,255

[ForegroundIntense]
Color=255,255,255

[Color0]
Color=15,15,30

[Color0Intense]
Color=50,50,80

[Color1]
Color=180,60,100

[Color2]
Color=80,180,160

[Color3]
Color=180,150,80

[Color4]
Color=80,120,220

[Color5]
Color=140,80,220

[Color6]
Color=80,180,220

[Color7]
Color=180,180,210

[Color1Intense]
Color=220,80,120

[Color2Intense]
Color=100,220,190

[Color3Intense]
Color=220,190,100

[Color4Intense]
Color=100,150,255

[Color5Intense]
Color=180,100,255

[Color6Intense]
Color=100,210,255

[Color7Intense]
Color=230,230,255

[General]
Anchor=0.5,0.5
Blur=true
ColorRandomization=false
Description=NixDark
Opacity=0.95
'';
}
