data = {}
data.file = path .. "/.subjects-data"
data.subjects = {}

function data.load()
  local f = io.open(data.file, "r")
  if not f then return end
  
  for v in f:lines() do
    local s = Subject.new()
    s:fromDataString(v)
    data.subjects[s.title] = s
  end
  
  f:close()
end

function data.save()
  local f = io.open(data.file, "w")
  for _, v in pairs(data.subjects) do f:write(v:toDataString() .. "\n") end
  f:close()
end

function data.add(title, quota)
  local s = Subject.new(title, quota)
  data.subjects[title] = s
  return s
end

function data.remove(title)
  data.subjects[title] = nil
end
