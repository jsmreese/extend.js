window.context = window.describe

behavesLikeAnExtender = (top) ->
  describe "the names you might specify", ->
    value = {}
    context "passed a single identifier", ->
      beforeEach ->
        top.extend("panda", value)

      it "creates a single object on the top", ->
        expect(top.panda).toBe(value)

    context "passed period-delimited identifiers", ->
      beforeEach ->
        top.extend("code.retreat", value)

      it "creates an object for each identifier", ->
        expect(top.code.retreat).toBe(value)

    context "passed forward-slash-delimited identifiers", ->
      beforeEach ->
        top.extend("pants/sale/time", value)

      it "creates an object for each identifier", ->
        expect(top.pants.sale.time).toBe(value)

    context "passed back-slash-delimited identifiers", ->
      beforeEach ->
        top.extend("test\\pollution\\sucks", value)

      it "creates an object for each identifier", ->
        expect(top.test.pollution.sucks).toBe(value)


    context "passed a humorously deep number of identifiers", ->
      beforeEach ->
        top.extend("a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.$", value)

      it "still works", ->
        expect(top.a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.$).toBe(value)

  describe "the stuff you might pass it", ->
    name = "panda"
    result = undefined
    context "like functions", ->
      func = ->

      context "passed a new function", ->
        beforeEach ->
          result = top.extend(name, func)

        it "defines the function", ->
          expect(top[name]).toBe(func)

        it "returns the function too", ->
          expect(result).toBe(func)


      context "passed a function when one already exists ", ->
        thrown = undefined
        beforeEach ->
          top.extend(name, func)
          try
            top.extend name, ->

          catch e
            thrown = e

        it "throws an error", ->
          expect(thrown).toBe "Cannot define a new function \"#{name}\", because one is already defined."


      context "passed a function when the one that exists is the same function", ->
        thrown = undefined
        beforeEach ->
          top.extend(name, func)
          try
            top.extend(name, func)
          catch e
            thrown = e

        it "doesn't throw anything", ->
          expect(thrown).not.toBeDefined()


      context "passed a function when the one that exists but no second arg is given", ->
        result = undefined
        thrown = undefined
        beforeEach ->
          top.extend(name, func)
          try
            result = top.extend(name)
          catch e
            thrown = e

        it "doesn't throw anything", ->
          expect(thrown).not.toBeDefined()

        it "returns the defined function", ->
          expect(result).toBe(func)

    context "like objects", ->
      obj =
        a: "A"
        b: "B"

      context "passed a new object", ->
        beforeEach ->
          result = top.extend(name, obj)

        it "defines the object", ->
          expect(top[name]).toBe(obj)

        it "returns the object", ->
          expect(result).toBe(obj)


      context "passed an object when one already exists", ->
        beforeEach ->
          top.extend(name, obj)
          result = top.extend(name,
            b: "B'"
            c: "C"
          )

        it "retains the property of the original", ->
          expect(result.a).toBe(obj.a)

        it "overrides the common property", ->
          expect(result.b).toBe("B'")

        it "defines the all-new property", ->
          expect(result.c).toBe("C")

    context "passed nothing", ->
      result = undefined
      context "when nothing exists", ->
        beforeEach ->
          result = top.extend(name)

        it "returns undefined", ->
          expect(result).not.toBeDefined()


      context "when something already exists", ->
        beforeEach ->
          top.extend name, "fun!"
          result = top.extend(name)

        it "returns that something", ->
          expect(result).toBe("fun!")

    afterEach ->
      delete top[name]

describe ".extend", ->
  behavesLikeAnExtender(window)

describe "extend.myNamespace", ->
  namespace = {}
  result = undefined
  beforeEach ->
    result = extend.myNamespace(namespace)

  it "it adds an 'extend' function to an arbitrary object", ->
    expect(namespace.extend).toBeDefined()

  it "returns the new extend method", ->
    expect(result).toBe(namespace.extend)

  behavesLikeAnExtender(namespace)

describe "extend.noConflict", ->
  theExtendBeingSpecifiedHere = undefined
  result = undefined
  beforeEach ->
    theExtendBeingSpecifiedHere = window.extend
    result = extend.noConflict()

  afterEach ->
    window.extend = theExtendBeingSpecifiedHere

  it "relinquishes control of window.extend to its previous owner", ->
    expect(window.previousOwnerOfExtend).toBe(window.extend)

  it "returns the .extend function", ->
    expect(result).toBe(theExtendBeingSpecifiedHere)


