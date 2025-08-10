local health = require("base.health")
local base = require("base")

describe("Health Check", function()
  -- Test health check with default configuration
  describe("Default configuration", function()
    before_each(function()
      base.setup({})
    end)

    it("runs health check without errors", function()
      assert.has_no_errors(function()
        health.check()
      end)
    end)

    it("validates default options correctly", function()
      -- Setup with defaults
      base.setup({})

      -- Health check should pass without errors
      assert.has_no_errors(function()
        health.check()
      end)
    end)
  end)

  -- Test health check with custom configuration
  describe("Custom configuration", function()
    before_each(function()
      base.setup({ name = "Test User" })
    end)

    it("runs health check with custom options", function()
      assert.has_no_errors(function()
        health.check()
      end)
    end)

    it("validates custom options correctly", function()
      -- Health check should validate the custom name option
      assert.has_no_errors(function()
        health.check()
      end)
    end)
  end)

  -- Test health check validation
  describe("Option validation", function()
    it("handles invalid configuration gracefully", function()
      -- Setup with invalid options
      base.setup({ name = 123 }) -- name should be string, not number

      -- Health check should still complete (but may report errors internally)
      assert.has_no_errors(function()
        health.check()
      end)
    end)
  end)
end)

-- RESOURCES:
--   - https://github.com/lunarmodules/busted
--   - :help vim.health
--   - https://hiphish.github.io/blog/2024/01/29/testing-neovim-plugins-with-busted/
