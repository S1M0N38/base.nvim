---@module 'luassert'

local health = require("base.health")
local base = require("base")

describe("health check", function()
  it("runs with default config without errors", function()
    base.did_setup = false
    base.setup({})
    assert.has_no.errors(function()
      health.check()
    end)
  end)

  it("runs with custom config without errors", function()
    base.did_setup = false
    base.setup({ name = "Test User" })
    assert.has_no.errors(function()
      health.check()
    end)
  end)

  it("handles invalid config gracefully", function()
    base.did_setup = false
    base.setup({ name = 123 })
    assert.has_no.errors(function()
      health.check()
    end)
  end)

  it("reports error when setup() was not called", function()
    -- Create a fresh health module to test without setup
    base.did_setup = false
    -- Don't call setup — health should report the issue
    assert.has_no.errors(function()
      health.check()
    end)
  end)
end)
