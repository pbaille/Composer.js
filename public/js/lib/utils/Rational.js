// Generated by CoffeeScript 1.6.3
(function() {
  define([], function() {
    var root;
    if (typeof global !== "undefined" && global !== null) {
      root = global.AC.Utils;
    } else {
      root = window.AC.Utils;
    }
    return root.Rational = (function() {
      function Rational(numerator, denominator) {
        if (denominator === undefined) {
          denominator = 1;
        } else {
          if (denominator === 0) {
            throw "divide by zero";
          }
        }
        this.numer = numerator;
        if (this.numer === 0) {
          this.denom = 1;
        } else {
          this.denom = denominator;
        }
        this.normalize();
      }

      Rational.prototype.numerator = function() {
        return this.numer;
      };

      Rational.prototype.denominator = function() {
        return this.denom;
      };

      Rational.prototype.dup = function() {
        return new AC.Utils.Rational(this.numerator(), this.denominator());
      };

      Rational.prototype.toString = function() {
        if (this.denominator() === 1) {
          return this.numerator().toString();
        } else {
          return this.numerator() + "/" + this.denominator();
        }
      };

      Rational.prototype.toFloat = function() {
        return this.numer / this.denom;
      };

      Rational.prototype.toInt = function() {
        return Math.floor(this.toFloat());
      };

      Rational.prototype.normalize = function() {
        var a, b, tmp;
        a = Math.abs(this.numerator());
        b = Math.abs(this.denominator());
        while (b !== 0) {
          tmp = a;
          a = b;
          b = tmp % b;
        }
        this.numer /= a;
        this.denom /= a;
        if (this.denom < 0) {
          this.numer *= -1;
          this.denom *= -1;
        }
        return this;
      };

      Rational.prototype.abs = function() {
        return new AC.Utils.Rational(Math.abs(this.numerator()), this.denominator());
      };

      Rational.prototype.inv = function() {
        return new AC.Utils.Rational(this.denominator(), this.numerator());
      };

      Rational.prototype.add = function(rat) {
        this.numer = this.numer * rat.denom + this.denom * rat.numer;
        this.denom = this.denom * rat.denom;
        return this.normalize();
      };

      Rational.prototype.plus = function(rat) {
        var d, n, result;
        if (!rat.numer) {
          rat = new AC.Utils.Rational(rat, 1);
        }
        n = this.numer * rat.denom + this.denom * rat.numer;
        d = this.denom * rat.denom;
        result = new AC.Utils.Rational(n, d);
        result.normalize();
        return result;
      };

      Rational.prototype.minus = function(rat) {
        var d, n, result;
        if (!rat.numer) {
          rat = new AC.Utils.Rational(rat, 1);
        }
        n = this.numer * rat.denom - this.denom * rat.numer;
        d = this.denom * rat.denom;
        result = new AC.Utils.Rational(n, d);
        result.normalize();
        return result;
      };

      Rational.prototype.subtract = function() {
        var i;
        i = 0;
        while (i < arguments.length) {
          this.numer = this.numer * arguments[i].denominator() - this.denom * arguments[i].numerator();
          this.denom = this.denom * arguments[i].denominator();
          i++;
        }
        return this.normalize();
      };

      Rational.prototype.neg = function() {
        return (new AC.Utils.Rational(0)).subtract(this);
      };

      Rational.prototype.times = function(rat) {
        var d, n;
        if (!rat.numer) {
          rat = new AC.Utils.Rational(rat, 1);
        }
        n = this.numer * rat.numer;
        d = this.denom * rat.denom;
        return new AC.Utils.Rational(n, d);
      };

      Rational.prototype.multiply = function() {
        var i;
        i = 0;
        while (i < arguments.length) {
          this.numer *= arguments[i].numerator();
          this.denom *= arguments[i].denominator();
          i++;
        }
        return this.normalize();
      };

      Rational.prototype.divide = function(rat) {
        return this.multiply(rat.inv());
      };

      Rational.prototype.inc = function() {
        this.numer += this.denominator();
        return this.normalize();
      };

      Rational.prototype.dec = function() {
        this.numer -= this.denominator();
        return this.normalize();
      };

      Rational.prototype.isZero = function() {
        return this.numerator() === 0;
      };

      Rational.prototype.isPositive = function() {
        return this.numerator() > 0;
      };

      Rational.prototype.isNegative = function() {
        return this.numerator() < 0;
      };

      Rational.prototype.eq = function(rat) {
        var self;
        self = this.dup().normalize();
        return self.numer === rat.numer && self.denom === rat.denom;
      };

      Rational.prototype.ne = function(rat) {
        return !(this.eq(rat));
      };

      Rational.prototype.lt = function(rat) {
        return this.dup().subtract(rat).isNegative();
      };

      Rational.prototype.gt = function(rat) {
        return this.dup().subtract(rat).isPositive();
      };

      Rational.prototype.le = function(rat) {
        return !(this.gt(rat));
      };

      Rational.prototype.ge = function(rat) {
        return !(this.lt(rat));
      };

      return Rational;

    })();
  });

}).call(this);
