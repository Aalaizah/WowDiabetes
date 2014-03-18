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


## Close Button Bug

14x <string>:"WowDiabetesCloseButton:OnClick":1: attempt to call global "WowDiabetesCloseButton_OnClick" (a nil value)
<string>:"*:OnClick":1: in function <string>:"*:OnClick":1

Locals:
