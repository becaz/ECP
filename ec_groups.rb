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

def example4
  gx = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
  gy = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
  p = 2**256 - 2**32 - 977
  n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
  x = FieldElement.new(value: gx, prime: p)
  y = FieldElement.new(value: gy, prime: p)
  seven = FieldElement.new(value: 7, prime: p)
  zero = FieldElement.new(value: 0, prime: p)
  g = ECPoint.new(a: zero, b: seven, x: x, y: y)
  puts n*g # => Point(identity)
end

example4
