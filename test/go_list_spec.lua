return function()
  local mock = require("deftest.mock.mock")
  local go_list = require("modules.go_list")

  describe("go_list", function()
    local enemy_1 = "enemy_1"
    local enemy_2 = "enemy_2"
    local list

    before(function()
      list = go_list.create()
    end)

    describe("#add", function()
      it("adds to the list, and returns whether game object got added", function()
        assert_true(list.add(enemy_1))
        assert_false(list.add(enemy_1))
      end)
    end)

    describe("#remove", function()
      it("removes from the list, and returns whether game object got removed", function()
        assert_false(list.remove(enemy_1))
        list.add(enemy_1)
        assert_true(list.remove(enemy_1))
        assert_false(list.remove(enemy_1))
      end)
    end)

    describe("#clear", function()
      it("removes everything from the list", function()
        list.add(enemy_1)
        list.add(enemy_2)
        assert_true(list.has(enemy_1))
        assert_true(list.has(enemy_2))
        list.clear()
        assert_false(list.has(enemy_1))
        assert_false(list.has(enemy_2))
      end)
    end)

    describe("#has", function()
      it("returns whether game object is in the list", function()
        list.add(enemy_1)
        assert_true(list.has(enemy_1))
        assert_false(list.has(enemy_2))
      end)
    end)

    describe("#get_closest", function()
      before(function()
        mock.mock(go)

        local positions = {
          enemy_1 = vmath.vector3(4),
          enemy_2 = vmath.vector3(3),
        }
        go.get.replace(function(id, property)
          return property == "position" and positions[id]
            or error("`go.get` was called with id `" .. id .. "` and property `" .. property .. "`")
        end)
      end)

      after(function()
        mock.unmock(go)
      end)

      it("returns closest game object to target position", function()
        list.add(enemy_1)
        list.add(enemy_2)
        assert_equal(enemy_2, list.get_closest(vmath.vector3(2)))
        assert_equal(enemy_1, list.get_closest(vmath.vector3(5)))
      end)

      it("returns nil if list is empty", function()
        assert_nil(list.get_closest(vmath.vector3(2)))
      end)
    end)
  end)
end
