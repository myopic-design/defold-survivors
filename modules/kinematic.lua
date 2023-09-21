----------------------------------------------------------------------------------------------------
-- Kinematic: Utility functions for working with kinematic collision objects.
----------------------------------------------------------------------------------------------------

local messages = require("modules.messages")

local M = {}

--- Handle geometry contact by separating this object from the collision.
--- @param correction vector3 # aggregated correction vector (for when dealing with multiple
--- collisions per frame)
--- @param normal vector3 # collision normal (as provided from a `contact_point_response` message)
--- @param distance number # collision distance (as provided from a `contact_point_response`
--- message)
--- @param id string|hash|url? # optional id of the game object to separate
function M.handle_geometry_contact(correction, normal, distance, id)
  -- See: https://defold.com/manuals/physics-resolving-collisions/
  if distance > 0 then
    local proj = vmath.project(correction, normal * distance)
    if proj < 1 then
      local comp = (distance - distance * proj) * normal
      go.set_position(go.get_position(id) + comp, id)
      correction.x = correction.x + comp.x
      correction.y = correction.y + comp.y
      correction.z = correction.z + comp.z
    end
  end
end

--- Create an instance of the kinematic helper.
--- @return table # helper instance
function M.create()
  local instance = {}

  local correction = vmath.vector3()

  --- Forward any calls to `on_message` from scripts to this module.
  --- @param message_id hash # id of the received message
  --- @param message table # message data
  function instance.on_message(message_id, message)
    if message_id == messages.CONTACT_POINT_RESPONSE then
      M.handle_geometry_contact(correction, message.normal, message.distance)
    end
  end

  --- Forward any calls to `update` from scripts to this module.
  function instance.update()
    correction.x = 0
    correction.y = 0
    correction.z = 0
  end

  return instance
end

return M
