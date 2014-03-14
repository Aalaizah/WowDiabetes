# Bugs

A place to write all of the bugs found using bugsack.

## Status Bar Bug

1x <string>:"WowDiabetesGlucoseLevelBar:OnValueChanged":1: attempt to call global "WowDiabetesGlucoseLevelBar_OnValueChanged" (a nil value)
<string>:"*:OnValueChanged":1: in function <string>:"*:OnValueChanged":1
<in C code>
<string>:"*:OnLoad":2: in function <string>:"*:OnLoad":1

Locals:
(*temporary) = WowDiabetesGlucoseLevelBar {
 0 = <userdata>
}
(*temporary) = 50
(*temporary) = 50
(*temporary) = <function> defined =[C]:-1

## OnLoad Bug

Lua is breaking when it loads. FIX ASAP!!!

1x Diabetes\Diabetes.lua:31: attempt to index local "frame" (a nil value)
Diabetes\Diabetes.lua:31: in function "WowDiabetes_OnLoad"
<string>:"*:OnLoad":2: in function <string>:"*:OnLoad":1

Locals:
self = WowDiabetes {
 0 = <userdata>
}