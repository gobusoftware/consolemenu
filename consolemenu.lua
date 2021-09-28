-- author:zhurilinyu@163.com

local class = require 'lib.middleclass'

local now_menu
local LOG_COLOR_MAP <const> = {
  RESET = "\x1b[0m", -- reset
  DEBUG = "\x1b[0m",  -- default black
  INFO  = "\x1b[32m", -- green
  WARN  = "\x1b[33m", -- yellow
  ERROR = "\x1b[31m", -- red
  FATAL = "\x1b[35m", -- violet
  SKY   = "\x1b[34m", -- blue
}

-------------------------------------------------
-- menu
local Menu = class('menu')

function Menu:initialize(title, t)
  self.title = title
  self.menu = {}
  self.menu_last = ''
  self.parent = false
  if t then
    self:initMenu(t)
  end
end

function Menu:initMenu(t)
  for i = 1, #t do
    t[i].key = tostring(i)
    if t[i].child then
      t[i].cp = self
    end
  end
  self.menu = t
end

function Menu:getParentTitle()
  local c = ''
  if self.parent then
    c = c .. self.parent:getParentTitle()
    c = c .. self.parent.title .. ' > '
  end
  return c
end

function Menu:showMenu(cp)
  if not now_menu then
    now_menu = self
  end
  if not self.parent then
    self.parent = cp
  end
  if self.parent then
    self.menu_last = {
      key = 'b',
      text = '[b] back',
      action = function() self.parent:showMenu() now_menu = self.parent end
    }
  else
    self.menu_last = {
      key = 'x',
      text = '[x] exit',
      action = function() os.exit() end
    }
  end

  print(LOG_COLOR_MAP.RESET, LOG_COLOR_MAP.INFO)
  print('----------------------------------------')
  print(self:getParentTitle() .. self.title, LOG_COLOR_MAP.RESET, LOG_COLOR_MAP.FATAL)
  for k, v in ipairs(self.menu) do
    print('[' .. k .. '] ' .. v.text .. (v.child and ' -->' or '') )
  end
  print(self.menu_last.text)
  print(LOG_COLOR_MAP.RESET)
end

function Menu:action(input)
  for k, v in ipairs(self.menu) do
    if v.key == input then
      if v.child then
        now_menu = v.child
        v.child:showMenu(v.cp)
      else
        if v.action then
          print('enter [Y] to continue for:' .. v.text)
          local input = io.read()
          if input:lower() == 'y' then
            v.action()
          else
            print('interrupt!')
          end
        end
        now_menu:showMenu(v.cp)
      end
      return
    end
  end

  if self.menu_last.key == input then
    self.menu_last.action()
  else
    now_menu:showMenu()
  end
end

function Menu:loop()
  local input
  repeat input = io.read()
    input = input:gsub(' ', ''):gsub('\t', '')
    print('Your select: ' .. input)
  until now_menu:action(input)
end

return Menu