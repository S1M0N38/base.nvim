---@module 'luassert'

local health = require("base.health")
local base = require("base")

describe("health check", function()
  it("runs with default config without errors", function()
    base.setup({})
    assert.has_no.errors(function()
      health.check()
    end)
  end)

  it("runs with custom config without errors", function()
    base.setup({ name = "Test User" })
    assert.has_no.errors(function()
      health.check()
    end)
  end)

  it("handles invalid config gracefully", function()
    base.setup({ name = 123 })
    assert.has_no.errors(function()
      health.check()
    end)
  end)
end)
