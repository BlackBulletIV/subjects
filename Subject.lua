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
  self.prevCurrent = 0
  self.prevUpdated = 0
  if updated then self:checkUpdated() end
end

function Subject:add(amount)
  self.current = self.current + amount
  self.updated = os.time()
end

function Subject:sub(amount)
  self.current = math.max(self.current - amount, 0)
  self.updated = os.time()
end

function Subject:toDataString()
  return ("%s %s %s/%s %s %s"):format(
    self.title,
    self.updated,
    self.current,
    self.quota,
    self.prevUpdated,
    self.prevCurrent
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
  -- new week
  if os.date("%w", os.time()) < os.date("%w", self.updated) then
    self.prevCurrent = self.current
    self.prevUpdated = self.updated
    self.current = 0
    self.updated = os.time()
  end
end
