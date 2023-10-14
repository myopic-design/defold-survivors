----------------------------------------------------------------------------------------------------
-- Game Object List: Utility functions for dealing with lists of game objects.
----------------------------------------------------------------------------------------------------

local M = {}

local next_id
local next_property

--- Create an instance of the game object list helper.
--- @return table # helper instance
function M.create()
  local instance = {}

  local list = {}

  --- Add game object to list.
  --- @param id string|hash|url # id of the game object instance
  --- @return boolean # true if game object got added
  function instance.add(id)
    local prev = list[id]
    list[id] = true
    return not prev
  end

  --- Remove game object from list.
  --- @param id string|hash|url # id of the game object instance
  --- @return boolean # true if game object got removed
  function instance.remove(id)
    local prev = list[id]
    list[id] = nil
    return not not prev
  end

  --- Remove all game objects from list.
  function instance.clear()
    for id in instance.iterate() do
      list[id] = nil
    end
  end

  --- Return whether a game object is present in the list.
  --- @param id string|hash|url # id of the game object instance
  --- @return boolean # true if game object is present
  function instance.has(id)
    return not not list[id]
  end

  --- Return closest game object to position.
  --- @param target_position vector3 # target position
  --- @return string|hash|url? # id of the closest game object instance
  function instance.get_closest(target_position)
    local closest_distance = nil
    local closest_id = nil

    for id, position in instance.iterate_property("position") do
      local distance = vmath.length_sqr(target_position - position)
      if closest_distance == nil or distance < closest_distance then
        closest_distance = distance
        closest_id = id
      end
    end

    return closest_id
  end

  --- Return stateless iterator for game object ids.
  --- @generic T: table, K, V
  --- @return fun(table: table<K, V>, index?: K):K, V
  --- @return T
  --- @return nil
  function instance.iterate()
    return next_id, list, nil
  end

  --- Return stateless iterator for game object property.
  --- @generic T: table, K, V
  --- @param property string|hash # id of the property to retrieve
  --- @return fun(table: table<K, V>, index?: K):K, V
  --- @return T
  --- @return nil
  function instance.iterate_property(property)
    return next_property(property), list, nil
  end

  return instance
end

--- Stateless iterator to return the id for each game object.
--- @generic K, V
--- @param table table<K, V>
--- @param index? K
--- @return K
function next_id(table, index)
  local k, _ = next(table, index)
  return k
end

--- Stateless iterator to return a property for each game object.
--- @generic K, V
--- @param property string|hash # id of the property to retrieve
--- @return fun(table: table<K, V>, index?: K):K, V
function next_property(property)
  --- @generic K, V
  --- @param table table<K, V>
  --- @param index? K
  --- @return K
  --- @return V
  return function(table, index)
    local k, v = next(table, index)
    if k ~= nil then
      v = go.get(k, property)
    end
    return k, v
  end
end

return M
