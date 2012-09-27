Subject = {}
Subject.__index = Subject

function Subject.new(...)
  local t = setmetatable({}, Subject)
  t:init(...)
  return t
end

function Subject:init(title, quota, current, updated)
  self.title = title or ""
  self.quota = quota or 1
  self.current = current or 0
  self.updated = updated or os.time()
  if updated then self:checkUpdated() end
end

function Subject:add(amount)
  self.current = math.max(self.current + math.floor(amount + 0.5), 0)
  self.updated = os.time()
end

function Subject:toDataString()
  return ("%s %s %s/%s"):format(
    self.title,
    self.updated,
    self.current,
    self.quota
  )
end

function Subject:fromDataString(str)
  local t, u, c, q = str:match("(%w+)%s+(%d+)%s+(%d+)/(%d+)")
  self.title = t
  self.updated = tonumber(u)
  self.current = tonumber(c)
  self.quota = tonumber(q)
  self:checkUpdated()
end

function Subject:checkUpdated()
  -- new week (%U = week number)
  if os.date("%U", os.time()) ~= os.date("%U", self.updated) then
    self.current = 0
    self.updated = os.time()
  end
end
