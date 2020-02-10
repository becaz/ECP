# frozen_string_literal: true

require 'test_helper'

# Test points over finite fields

describe ECPoint do
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
        pt = ECPoint.new(a: @a, b: @b, x: x, y: y)
      end
    end
  end

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

  def test_scalar_multiplication
    _test_scalar_mul(2, [192, 105], [49, 71])
    _test_scalar_mul(2, [143, 98],  [64, 168])
    _test_scalar_mul(2, [47, 71],   [36, 111])
    _test_scalar_mul(4, [47, 71],   [194, 51])
    _test_scalar_mul(8, [47, 71],   [116, 55])

    x = FieldElement.new(value: 47, prime: @prime)
    y = FieldElement.new(value: 71, prime: @prime)
    pnt = ECPoint.new(a: @a, b: @b, x: x, y: y)
    pnt = 21*pnt

    assert_equal pnt, ECPoint.new(a: @a, b: @b)
  end

  private

  def _test_addition(p1, p2, p3)
    x1 = FieldElement.new(value: p1[0], prime: @prime)
    y1 = FieldElement.new(value: p1[1], prime: @prime)

    x2 = FieldElement.new(value: p2[0], prime: @prime)
    y2 = FieldElement.new(value: p2[1], prime: @prime)

    x3 = FieldElement.new(value: p3[0], prime: @prime)
    y3 = FieldElement.new(value: p3[1], prime: @prime)

    pt1 = ECPoint.new(a: @a, b: @b, x: x1, y: y1)
    pt2 = ECPoint.new(a: @a, b: @b, x: x2, y: y2)
    pt3 = ECPoint.new(a: @a, b: @b, x: x3, y: y3)

    assert_equal pt1 + pt2, pt3
  end

  def _test_scalar_mul(scalar, p1, p2)
    x1 = FieldElement.new(value: p1[0], prime: @prime)
    y1 = FieldElement.new(value: p1[1], prime: @prime)
    pnt1 = ECPoint.new(a: @a, b: @b, x: x1, y: y1)

    pnt2 = scalar*pnt1

    x3 = FieldElement.new(value: p2[0], prime: @prime)
    y3 = FieldElement.new(value: p2[1], prime: @prime)
    pnt3 = ECPoint.new(a: @a, b: @b, x: x3, y: y3)

    assert_equal pnt2, pnt3
  end

end
