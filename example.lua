-- Test script that will receive a test case file as input
local a = string.gmatch(io.read(), "[^%s]+")()
local b = string.gmatch(io.read(), "[^%s]+")()
-- Will reverse and concatenate the two inputs
print(tostring(b) .. tostring(a))
