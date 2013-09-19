// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["lib/utils/Rational", "lib/utils/Utils", "vendors/ruby"], function() {
    var Rational, root;
    if (typeof global !== "undefined" && global !== null) {
      root = global.AC.Core;
    } else {
      root = window.AC.Core;
    }
    Rational = AC.Utils.Rational;
    return root.RVal = (function(_super) {
      __extends(RVal, _super);

      function RVal(num, den) {
        if (den == null) {
          den = 1;
        }
        RVal.__super__.constructor.call(this, num, den);
      }

      RVal.prototype.to_ms = function(bpm) {
        return this.times(new Rational(60, bpm)).toFloat() * 1000;
      };

      RVal.prototype.polyrythmic_base = function() {
        return _a.last(AC.Utils.factorise(this.denom));
      };

      RVal.prototype.binary_base = function() {
        var pb;
        pb = this.polyrythmic_base();
        if (pb === 2) {
          return new Rational(1, this.denom);
        } else {
          return new Rational(this.numer, this.denom / pb);
        }
      };

      RVal.prototype.multiplier = function() {
        return this.numer;
      };

      RVal.prototype.show_bases = function() {
        return console.log("poly: " + this.polyrythmic_base() + " \nbinary: " + this.binary_base() + " \nmultiplier: " + this.multiplier());
      };

      RVal.prototype.times = function(rat) {
        return RVal.__super__.times.call(this, rat).toRVal();
      };

      RVal.prototype.div = function(rat) {
        return RVal.__super__.div.call(this, rat).toRVal();
      };

      RVal.prototype.plus = function(rat) {
        return RVal.__super__.plus.call(this, rat).toRVal();
      };

      RVal.prototype.minus = function(rat) {
        return RVal.__super__.minus.call(this, rat).toRVal();
      };

      return RVal;

    })(Rational);
  });

}).call(this);