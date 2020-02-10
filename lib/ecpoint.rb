# frozen_string_literal: true

# Elliptic curve point

class ECPoint
  attr_reader :a, :b, :x, :y

  def initialize(args = {})
    @x = args.fetch(:x, nil)
    @y = args.fetch(:y, nil)
    @a = args.fetch(:a)
    @b = args.fetch(:b)

    check_that_on_the_curve! unless identity?
  end

  def to_s
    return "Point(identity)" if identity?

    "Point(#{x}, #{y})"
  end

  def identity?
    x.nil? || y.nil?
  end

  def == other
    return false unless other.a == a && other.b == b
    return true if identity? && other.identity?

    other.x == x && other.y == y
  end

  def + other
    check_on_the_same_curve!(other)

    return other if identity?
    return self if other.identity?

    inf_pnt = ECPoint.new(a: a, b: b)

    return inf_pnt if self == -other

    if other.x == x && other.y == y
      return inf_pnt if y.zero?
      s =(3*x**2 + a) / (2*y)
      x3 = s**2 - 2*x
    else
      s = (other.y - y)/(other.x - x)
      x3 = s**2 - x - other.x
    end

    y3 = s*(x - x3) - y
    ECPoint.new(a: a, b: b, x: x3, y: y3)
  end

  def -@
    ECPoint.new(a: a, b: b, x: x, y: -y)
  end


  def * coefficient
    coef = coefficient
    current = self
    result = ECPoint.new(a: @a, b: @b)

    while coef > 0
      result += current if coef.odd?
      current += current
      coef >>= 1
    end
    result
  end


  def coerce coeff
    return self, coeff
  end

  private

  def check_on_the_same_curve!(pnt)
    return if pnt.a == a && pnt.b == b

    msg = "Point (#{pnt.x}, #{pnt.y}) are not on the same curve"
    raise TypeError, msg
  end

  def check_that_on_the_curve!
    return if y**2 == x**3 + a*x + b

    msg = "(#{x}, #{y}) are not on the curve"
    raise ArgumentError, msg
  end
end
