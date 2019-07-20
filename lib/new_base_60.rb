require "date"
require "time"

class NewBase60
  VERSION    = '1.1.3'
  VOCABULARY = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ_abcdefghijkmnopqrstuvwxyz"

  def initialize(base_60)
    @base_60 = base_60
  end

  def to_s
    if negative?
      "-0:#{abs}"
    else
      "0:#{abs}"
    end
  end

  alias inspect to_s

  def abs
    if negative?
      @base_60[1..-1]
    else
      @base_60
    end
  end

  def negative?
    # minus sign
    @base_60.bytes.first == 45
  end

  # Converts into a base 10 integer.
  def to_i
    num = 0
    coeff = 1
    if negative?
      coeff = -1
    end

    @base_60.bytes.each do |char|
      case char
      when 48..57   then char -= 48
      when 65..72   then char -= 55
      when 73, 108  then char  = 1  # typo capital I, lowercase l to 1
      when 74..78   then char -= 56
      when 79       then char  = 0  # error correct typo capital O to 0
      when 80..90   then char -= 57
      when 95       then char  = 34
      when 97..107  then char -= 62
      when 109..122 then char -= 63
      else               char  = 0  # treat all other noise as 0
      end

      num = 60 * num + char
    end

    coeff*num
  end

  # Converts into a Date.
  def to_date
    Time.at(to_i * 60 * 60 * 24).utc.to_date
  end
end

class Integer
  # Converts a base 10 integer into a NewBase60 string.
  def to_sxg
    return "0" if zero?

    num = self.abs
    sxg = ""

    while num > 0 do
      mod = num % 60
      sxg = "#{NewBase60::VOCABULARY[mod,1]}#{sxg}"
      num = (num - mod) / 60
    end
    if self.negative?
      sxg = "-#{sxg}"
    end
    NewBase60.new(sxg)
  end

  # Converts a base 10 integer into a NewBase60 string,
  # padding with leading zeroes.
  def to_sxgf(padding=1)
    str = to_sxg

    padding -= str.length

    padding.times.map { "0" }.join + str
  end
end

class Date
  # Converts into a NewBase60 string.
  def to_sxg
    (self - Date.parse("1970/01/01")).to_i.to_sxg
  end
end
