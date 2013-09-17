// Generated by CoffeeScript 1.6.3
(function() {
  define(["lib/core/Domain"], function() {
    var Domain, Mode;
    Domain = AC.Core.Domain;
    Mode = AC.Core.Mode;
    return describe("Domain class", function() {
      return it("@pitches init", function() {
        var d, m;
        m = new Mode("C Lyd+");
        d = new Domain(m, [0, 24]);
        return expect(d.pitches_values()).toEqual([0, 2, 4, 6, 8, 9, 11, 12, 14, 16, 18, 20, 21, 23, 24]);
      });
    });
  });

}).call(this);
