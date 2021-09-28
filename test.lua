local Menu = require 'consolemenu'

main_menu = Menu:new("MainMenu")

local menu1 = Menu:new('menu1')
local menu2 = Menu:new("menu2")

local Test1 = {}

function Test1:test1()
  print('hello1')
end

function Test1:test2()
  print('hello2')
end

local Test2 = {}

function Test2:test3()
  print('hello3')
end

function Test2:test4()
  print('hello4')
end

function Test2:test5()
  print('hello5')
end


menu1:initMenu({
    { text = 'test1', action = Test1.test1 },
    { text = 'test2 ', child = menu2 },
})

menu2:initMenu({
  { text = 'test10', action = Test2.test3 },
  { text = 'test11', action = Test2.test4 },
  { text = 'test12', action = Test2.test5 },
})


main_menu:initMenu({
    { text = 'menu 1', child = menu1 },
    { text = 'memu 2', action = function() print('這里是空的') end },
})


main_menu:showMenu()
main_menu:loop()
