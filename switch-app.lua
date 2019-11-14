local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local application = require 'hs.application'

local hyper = {'cmd', 'alt', 'ctrl', 'shift'}

local key2App = {
   e = 'Emacs',
   f = 'Finder',
   g = 'Google Chrome',
   v = 'Preview',
   y = 'MailMaster',
   p = 'PhpStorm',
   w = 'WeChat',
   i = 'iTerm',
   d = 'Microsoft Word',
   x = 'Numbers',
   r = 'DataGrip',
   q = 'QQ'
}

for key, app in pairs(key2App) do
   hotkey.bind(hyper, key, function()
                  toggle_application(app)
   end)
end

-- 添加语言切换函数
local function toggle_languge(_app)
   hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
   if (_app == 'PhpStorm' or _app == 'Emacs' or _app == 'DataGrip' or _app == 'iTerm') then
   else
      hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
   end
end

-- Toggle an application between being the frontmost app, and being hidden
function toggle_application(_app)
   -- finds a running applications
   local app = application.find(_app)

   if not app then
      -- application not running, launch app
      application.launchOrFocus(_app)
      toggle_languge(_app)
      return
   end

   -- application running, toggle hide/unhide
   local mainwin = app:mainWindow()
   if mainwin then
      if true == app:isFrontmost() then
         mainwin:application():hide()
      else
         mainwin:application():activate(true)
         mainwin:application():unhide()
         mainwin:focus()
      end
   else
      -- no windows, maybe hide
      if true == app:hide() then
         -- focus app
         application.launchOrFocus(_app)
      else
         -- nothing to do
      end
   end

   toggle_languge(_app)
end