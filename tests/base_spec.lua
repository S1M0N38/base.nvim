---@module 'luassert'

local base = require("base")
base.setup({})

describe("default options", function()
  it("hello() returns greeting with default name", function()
    assert.are.equal("Hello John Doe", base.hello())
  end)

  it("bye() returns farewell with default name", function()
    assert.are.equal("Bye John Doe", base.bye())
  end)
end)

describe("user defined options", function()
  before_each(function()
    base.setup({ name = "World" })
  end)

  it("hello() returns greeting with custom name", function()
    assert.are.equal("Hello World", base.hello())
  end)

  it("bye() returns farewell with custom name", function()
    assert.are.equal("Bye World", base.bye())
  end)
end)
