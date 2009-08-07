class Object
  HTML_HEX_COLORS = {
    'aqua'     => '00FFFF', 'black'    => '000000', 'blue'     => '0000FF', 'fuchsia'  => 'FF00FF',
    'gray'     => '808080', 'green'    => '008000', 'lime'     => '00FF00', 'maroon'   => '800000',
    'navy'     => '000080', 'olive'    => '808000', 'purple'   => '800080', 'red'      => 'FF0000',
    'silver'   => 'C0C0C0', 'teal'     => '008080', 'white'    => 'FFFFFF', 'yellow'   => 'FFFF00'
  }

  def blank?
    respond_to?(:empty?) ? empty? : !self
  end unless Object.respond_to? :blank?

  def to_hex_color
    return self if self.is_a?(String) && (hex_color? || hex_color_with_opacity?)
    HTML_HEX_COLORS[self.to_s.downcase] || raise('Not a color!')
  end

end

class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end

class Integer
  CHARACTERS = [
    'A','B','C','D','E','F','G','H','I','J','K','L', 'M', 'N',
    'O','P','Q','R','S','T','U','V','W','X','Y','Z',
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n',
    'o','p','q','r','s','t','u','v','w','x','y','z',
    '0','1','2','3','4','5','6','7','8','9','-','.' 
  ]

  def simple_encode
    raise 'Out of bounds' if 0 > self || self > 61
    CHARACTERS[self]
  end

  def extended_encode
    raise 'Out of bounds' if 0 > self || self > 4095
    "#{CHARACTERS[self / 64]}#{CHARACTERS[self % 64]}"
  end
end

class String
  def hex_color?
    !!(self =~ /^(\d|[a-f]|[A-F]){6}$/)
  end

  def hex_color_with_opacity?
    !!(self =~ /^(\d|[a-f]|[A-F]){8}$/)
  end
end
