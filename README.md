# Elliptic Curves on Prime fields in Ruby
This project bears educational purpose, and can be used for proof of concepts or small experiments. We implement elliptic curve operations over prime fields.

## Basic Concepts
Let's consider the **Weierstrass Equation** written as

<center><i>y</i><sup>2</sup> = <i>x</i><sup>3</sup> + <i>Ax</i> + <i>B</i></center><br>

where *A* and *B* are constants, and *A*, *B*, *x*, and *y* are elements of a prime field.

So, **elliptic curve** (EC) over a field *K*, denoted by *E(K)*, is the set (pair of points)

<center>{ (<i>x</i>, <i>y</i>) | <i>y</i><sup>2</sup> = <i>x</i><sup>3</sup> + <i>Ax</i> + <i>B</i> and  <i>A</i>, <i>B</i>, <i>x</i>, and <i>y</i> are in <i>K</i> }</center><br>
plus a point at infinity, <i>O</i>.
<br><br>

Elements of *E(K)* form an abelian group whose identity element is *O*.

Given *P*, *Q* in *E(K)*, we are interested in implementing addition of two EC points, i.e., *P* + *Q*, multiplication by an EC point by a scalar *n*, i.e., *nP* (*P* + ... + *P*, *n* times), and negation, i.e,. -*P*.

## `ECPoint` class

Since an elliptic point *P(x,y)* satisfies the equation *y<sup>2</sup> = x<sup>3</sup> + Ax + B*, we define a point by four values: *x*, *y*, *A*, and *B*. A point with having a quadruple (*x*, *y*, *A*, *B*) but not satisfying the equation *y<sup>2</sup> = x<sup>3</sup> + Ax + B* is said to be invalid.

Thus, our tests are
```
require 'test_helper'

# Test points over finite fields

describe Point do
  before do
    @prime = 223
    @a = FieldElement.new(value: 0, prime: @prime)
    @b = FieldElement.new(value: 7, prime: @prime)
  end

  def test_valid_points
    [[192, 105], [17, 56], [1, 193]].each do |pt|
      x = FieldElement.new(value: pt[0], prime: @prime)
      y = FieldElement.new(value: pt[1], prime: @prime)
      pt = ECPoint.new(a: @a, b: @b, x: x, y: y)

      assert_equal pt.a, @a
      assert_equal pt.b, @b
      assert_equal pt.x, x
      assert_equal pt.y, y
    end
  end

  def test_invalid_points
    [[200, 119], [42, 99]].each do |pt|
      x = FieldElement.new(value: pt[0], prime: @prime)
      y = FieldElement.new(value: pt[1], prime: @prime)

      assert_raises(ArgumentError) do
        pt = Point.new(a: @a, b: @b, x: x, y: y)
      end
    end
  end
end
```

To pass the test we implement the class as following
```
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
```

## Point addition

First test
```
def test_addition
  tuples = [
    [[192, 105], [17, 56],  [170, 142]],
    [[170, 142], [60, 139], [220, 181]],
    [[47, 71],   [17, 56],  [215, 68]],
    [[143, 98],  [76, 66],  [47, 71]]
  ]

  tuples.each do |points|
    _test_addition(points[0], points[1], points[2])
  end
end
```

and then implementation
```
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
```

## Scalar multiplication
Finally, we need to implement computation of *nP*

Our test is
```
def test_scalar_multiplication
  _test_scalar_mul(2, [192, 105], [49, 71])
  _test_scalar_mul(2, [143, 98],  [64, 168])
  _test_scalar_mul(2, [47, 71],   [36, 111])
  _test_scalar_mul(4, [47, 71],   [194, 51])
  _test_scalar_mul(8, [47, 71],   [116, 55])

  x = FieldElement.new(value: 47, prime: @prime)
  y = FieldElement.new(value: 71, prime: @prime)
  pnt = Point.new(a: @a, b: @b, x: x, y: y)
  pnt = 21*pnt

  assert_equal pnt, ECPoint.new(a: @a, b: @b)
end
```
and its implementation
```
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
```

## Tryout
Examples are in the file `ec_groups.rb`.
## References
1. *Programming Bitcoin*, Jimmy Song
2. *Algebraic Aspects of Cryptography*, Neal Koblitz
