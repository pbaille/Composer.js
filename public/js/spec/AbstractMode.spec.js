// Generated by CoffeeScript 1.6.3
(function() {
  define(['lib/core/AbstractMode'], function() {
    var AbstractMode;
    AbstractMode = AC.Core.AbstractMode;
    return describe("AbstractMode", function() {
      it("initialize by name", function() {
        var am, am2;
        am = new AbstractMode("Mix");
        expect(am).toBeTruthy();
        am2 = new AbstractMode("Lyd+");
        return expect(am2).toBeTruthy();
      });
      it("initialize by mother name , degree ", function() {
        var am, am2;
        am = new AbstractMode("Lyd", 3);
        expect(am.name).toEqual("Eol");
        am2 = new AbstractMode("Lyd+", 7);
        return expect(am2.name).toEqual("Phry6");
      });
      return it("initialize by functs ", function() {
        var am, am2, am3;
        am = new AbstractMode([0, 1, 3, 4, 6, 8, 10]);
        expect(am.name).toEqual("Alt");
        am2 = new AbstractMode([0, 2, 3, 5, 7, 9, 10]);
        expect(am2.name).toEqual("Dor");
        am3 = new AbstractMode([0, 1, 3, 5, 7, 9, 11]);
        return expect(am3.name).toEqual("unknown");
      });
    });
  });

}).call(this);
