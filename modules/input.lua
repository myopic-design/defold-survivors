----------------------------------------------------------------------------------------------------
-- Input: Utility functions for working with player input.
----------------------------------------------------------------------------------------------------

local M = {}

--- Create an instance of the input helper.
--- @return table # helper instance
function M.create()
  local instance = {}

  local action_map = nil
  local action_strength = nil

  --- Acquire input focus for the current script.
  --- @param receiver string|url|hash? # receiver of the `acquire_input_focus` message
  function instance.acquire(receiver)
    msg.post(receiver or ".", "acquire_input_focus")
    action_map = {}
    action_strength = {}
  end

  --- Release input focus for the current script.
  --- @param receiver string|url|hash? # receiver of the `release_input_focus` message
  function instance.release(receiver)
    msg.post(receiver or ".", "release_input_focus")
    action_map = nil
    action_strength = nil
  end

  --- Check whether an action is currently pressed.
  --- @param action_id hash # id of the input action
  --- @return boolean # true if action is pressed
  function instance.is_pressed(action_id)
    return action_map[action_id] or false
  end

  --- Get the strength of an action.
  --- @param action_id hash # id of the input action
  --- @return number # strength of the action
  function instance.get_action_strength(action_id)
    return action_strength[action_id] or 0
  end

  --- Forward any calls to `on_input` from scripts to this module.
  --- @param action_id hash # id of the received input action
  --- @param action table # input data
  function instance.on_input(action_id, action)
    if action_id then
      action_id = type(action_id) == "string" and hash(action_id) or action_id
      if action.pressed then
        action_map[action_id] = true
      elseif action.released then
        action_map[action_id] = false
      end
      action_strength[action_id] = action.value
    end
  end

  --- Forward any calls to `update` from scripts to this module.
  function instance.update()
    for action_id in pairs(action_strength) do
      action_strength[action_id] = nil
    end
  end

  return instance
end

return M
