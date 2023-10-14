----------------------------------------------------------------------------------------------------
-- Sequence: Utility functions for dealing with sequences of async operations.
----------------------------------------------------------------------------------------------------

local M = {}

local resume

--- Wrap the specified function in a coroutine.
--- @param fn function # function to wrap
function M.run(fn, ...)
  coroutine.wrap(fn)(...)
end

--- Wait until a certain time has elapsed.
--- @param seconds number # delay in seconds
function M.delay(seconds)
  local co = coroutine.running()
  assert(co, "You must call this from inside a sequence")
  timer.delay(seconds, false, function()
    resume(co)
  end)
  coroutine.yield()
end

--- Call `go.animate` and wait until it has finished.
--- @param url string|hash|url # url of the game object or component having the property
--- @param property string|hash # id of the property to animate
--- @param playback constant # playback mode of the animation
--- @param to number|vector3|vector4|quaternion # target property value
--- @param easing constant|vector # easing to use during animation
--- @param duration number # duration of the animation in seconds
--- @param delay number? # delay before the animation starts in seconds
function M.go_animate(url, property, playback, to, easing, duration, delay)
  local co = coroutine.running()
  assert(co, "You must call this from inside a sequence")
  delay = delay or 0
  go.animate(url, property, playback, to, easing, duration, delay, function()
    resume(co)
  end)
  coroutine.yield()
end

function resume(co, ...)
  local ok, err = coroutine.resume(co, ...)
  if err then
    print(err)
  end
end

return M
