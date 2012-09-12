interface = {}
interface.progressBarLength = 40
interface.columnPadding = 2
interface.cmd = {}

function interface.process(args)
  local func
  data.load()
  
  if #args > 0 then
    func = interface.cmd[args[1]]
    
    if func then
      table.remove(args, 1)
    else
      if not data.subjects[args[1]] then interface.exit("No command or subject named '" .. args[1] .. "'") end
      func = interface.handleSubject
    end
  else
    func = interface.cmd.list
  end
  
  func(unpack(args))
  data.save()
end

function interface.format(s, nameLen, fractLen)
  -- title
  local ret = s.title .. " " * (math.max((nameLen or 0) - #s.title, 0) + interface.columnPadding)
  
  -- fraction
  local fract = ("%s/%s"):format(s.current, s.quota)
  ret = ret .. fract .. " " * (math.max((fractLen or 0) - #fract, 0) + interface.columnPadding)
  
  -- progress bar
  local num = math.min(s.current / s.quota, 1) * interface.progressBarLength
  ret = ret .. "|"
  
  for i = 1, interface.progressBarLength do
    ret = ret .. (i <= num and "|" or " ")
  end
  
  return ret .. "|"
end

function interface.exit(msg, code)
  print(msg)
  os.exit(code or 1)
end

function interface.handleSubject(title, change)
  local s = data.subjects[title]
  local amount = tonumber(change)
  
  if amount == 0 then
    print("Adding zero won't do much!")
  elseif amount < 0 then
    s:sub(math.abs(amount))
  else
    local oldAmount = s.current
    s:add(amount)
    
    if oldAmount < s.quota and s.current >= s.quota then
      print("Well done! You've completed this weeks quota.")
    end
  end
  
  print(interface.format(s))
end

function interface.cmd.list()
  local nameLen = 0
  local fractLen = 0
  local count = 0
  
  for _, v in pairs(data.subjects) do
    count = count + 1
    nameLen = math.max(nameLen, #v.title)
    fractLen = math.max(fractLen, #(("%s/%s"):format(v.current, v.quota)))
  end
  
  -- there's no subjects present, we'll exit now
  if count == 0 then interface.exit("There are no subjects at the moment.", 0) end
  
  for _, v in pairs(data.subjects) do
    print(interface.format(v, nameLen, fractLen))
  end
end

function interface.cmd.add(title, quota)
  if interface.cmd[title] then interface.exit("'" + title + "' is a command. Choose a different name.") end
  data.add(title, tonumber(quota))
end

function interface.cmd.mod(title, quota)
  local s = data.subjects[title]
  if not s then interface.exit("'" + title + "' isn't a subject. Use the add command.") end
  s.quota = tonumber(quota)
  print(interface.format(s))
end

interface.cmd.rm = data.remove
