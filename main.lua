#!/usr/bin/env lua

path = arg[0]:gsub("(.+)/(%w+)%.lua", "%1")
package.path = package.path .. ";" .. path .. "/?.lua"

require("strong.init")
require("Subject")
require("data")
require("interface")
interface.process{...}
