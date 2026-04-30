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

  it("setup() sets did_setup to true", function()
    assert.is_true(base.did_setup)
  end)
end)

describe("user defined options", function()
  before_each(function()
    -- Reset did_setup to allow re-setup in tests
    base.did_setup = false
    base.setup({ name = "World" })
  end)

  it("hello() returns greeting with custom name", function()
    assert.are.equal("Hello World", base.hello())
  end)

  it("bye() returns farewell with custom name", function()
    assert.are.equal("Bye World", base.bye())
  end)
end)

describe("double setup guard", function()
  it("warns on second setup() call", function()
    base.did_setup = false
    base.setup({ name = "First" })
    -- Second call should not error, just warn
    assert.has_no.errors(function()
      base.setup({ name = "Second" })
    end)
    -- Name should still be "First" since second setup was rejected
    assert.are.equal("Hello First", base.hello())
  end)
end)
