require_relative 'lib/field_element'
require_relative 'lib/ecpoint'

def example1
  # Curve:  y^2 = x^3 + x + 1
  # E(F5) has order 9

  x = FieldElement.new(value: 0, prime: 5)
  y = FieldElement.new(value: 1, prime: 5)
  one = FieldElement.new(value: 1, prime: 5)
  gen = ECPoint.new(a: one, b: one, x: x, y: y)

  # List all elements
  10.times{|i| puts i*gen}
end

def example2
  # Curve:  y^2 = x^3 + 2
  # E(F7) has order 9

  zero = FieldElement.new(value: 0, prime: 7)
  two = FieldElement.new(value: 2, prime: 7)

  # List different subgroups

  x = FieldElement.new(value: 0, prime: 7)
  y = FieldElement.new(value: 3, prime: 7)

  gen = ECPoint.new(a: zero, b: two, x: x, y: y)
  3.times{|i| puts (i+1)*gen}

  x = FieldElement.new(value: 3, prime: 7)
  y = FieldElement.new(value: 1, prime: 7)

  gen = ECPoint.new(a: zero, b: two, x: x, y: y)
  3.times{|i| puts (i+1)*gen}

  x = FieldElement.new(value: 5, prime: 7)
  y = FieldElement.new(value: 1, prime: 7)

  gen = ECPoint.new(a: zero, b: two, x: x, y: y)
  3.times{|i| puts (i+1)*gen}

  x = FieldElement.new(value: 6, prime: 7)
  y = FieldElement.new(value: 1, prime: 7)

  gen = ECPoint.new(a: zero, b: two, x: x, y: y)
  3.times{|i| puts (i+1)*gen}
end

def example3
  # Curve:  y^2 = x^3 + 3x + 1
  # E(F13) has order 19

  x = FieldElement.new(value: 4, prime: 13)
  y = FieldElement.new(value: 5, prime: 13)
  three = FieldElement.new(value: 3, prime: 13)
  one = FieldElement.new(value: 1, prime: 13)
  gen = ECPoint.new(a: three, b: one, x: x, y: y)

  # List all elements
  19.times{|i| puts i*gen}
end

example3
