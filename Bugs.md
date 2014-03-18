# Bugs

A place to write all of the bugs found using bugsack.

## Status Bar Bug

<string>:"WowDiabetesGlucoseLevelBar:OnValueChanged":1: attempt to call global "WowDiabetesGlucoseLevelBar_OnValueChanged" (a nil value)
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

## Status Bar Bug 2

<string>:"WowDiabetesFrameGlucoseLevelBar:OnLoad":4: attempt to index global "WowDiabetesGlucoseLevelString" (a nil value)
<string>:"*:OnLoad":4: in function <string>:"*:OnLoad":1

Locals:
