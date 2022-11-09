-- update this condition to be based off of a UI setting so that it disables this greeting
if true then
    local name = UnitName("player");
    print('Hi, ' .. name .. '! Thanks for using "Mark As Junk"! Type "/maj" to get more info.');
end
