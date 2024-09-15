local base = require("base")


-- Test base.nvim with default options
describe("Default options", function()
  base.setup({})
  it("can say hello", function()
    assert.are.equal("Hello John Doe", base.hello())
  end)
  it("can say bye", function()
    assert.are.equal("Bye John Doe", base.bye())
  end)
end)

-- Test base.nvim with user defined options
describe("User defined options", function()
  base.setup({ name = "John Smith" })
  it("can say hello", function()
    assert.are.equal("Hello John Smith", base.hello())
  end)
  it("can say bye", function()
    assert.are.equal("Bye John Smith", base.bye())
  end)
end)


-- RESOURCES:
--   - https://github.com/lunarmodules/busted
--   - https://hiphish.github.io/blog/2024/01/29/testing-neovim-plugins-with-busted/
