require 'minitest'
require 'minitest/autorun'
require 'new_base_60'

class TestCase < MiniTest::Spec
  def test_string_abs
    assert NewBase60.new("464").string_abs == "464"
    assert NewBase60.new("-464").string_abs == "464"
  end

  def test_abs
    assert NewBase60.new("464").abs == NewBase60.new("464")
    pos_num = NewBase60.new("464")
    assert pos_num.abs.object_id == pos_num.object_id
    assert NewBase60.new("-464").abs == NewBase60.new("464")
  end

  def test_base60_abs_object_id
    num = NewBase60.new("4JG")
    assert num.abs.object_id ==  num.abs.object_id
  end

  def test_equals
    assert NewBase60.new("464") == NewBase60.new("464")
    assert NewBase60.new("0") == NewBase60.new("0")
    assert NewBase60.new("-464") == NewBase60.new("-464")
  end

  def test_negative
    refute NewBase60.new("464").negative?
    refute NewBase60.new("0").negative?
    assert NewBase60.new("-464").negative?
  end

  def test_positive
    refute NewBase60.new("-464").positive?
    refute NewBase60.new("0").positive?
    assert NewBase60.new("464").positive?
  end

  def test_zero
    refute NewBase60.new("-464").zero?
    assert NewBase60.new("0").zero?
    refute NewBase60.new("464").zero?
  end

  def test_to_s
    assert NewBase60.new("464").to_s == "0:464"
    assert NewBase60.new("-464").to_s == "-0:464"
  end

  def test_inspect
    assert NewBase60.new("464").inspect == "0:464"
    assert NewBase60.new("-464").inspect == "-0:464"
  end

  def test_base60_to_base10
    assert NewBase60.new("464").to_i == 14764
    refute NewBase60.new("464").to_i == 12345
  end

  def test_base60_to_base10_negative
    assert NewBase60.new("-464").to_i == -14764
    refute NewBase60.new("-464").to_i == -12345
  end

  def test_base60_to_base10_zero
    assert NewBase60.new("0").to_i == 0
  end

  def test_base60_to_date
    assert NewBase60.new("").to_date == Date.parse("1970/01/01")
    assert NewBase60.new("4JG").to_date == Date.parse("2012/06/05")
    assert NewBase60.new("464").to_date == Date.parse("2010/06/04")
    refute NewBase60.new("464").to_date == Date.parse("2010/06/05")
  end

  def test_base60_to_date_object_id
    num = NewBase60.new("4JG")
    assert num.to_date.object_id ==  num.to_date.object_id
  end

  def test_date_to_base60
    assert Date.parse("2010/06/04").to_sxg == NewBase60.new("464")
    refute Date.parse("2010/06/05").to_sxg == NewBase60.new("464")
  end

  def test_base10_to_base60
    assert 14764.to_sxg.to_s == "0:464"
    refute 12345.to_sxg.to_s == "0:464"
  end

  def test_base10_to_base60_negative
    assert (-14764).to_sxg.to_s == "-0:464"
    refute (-12345).to_sxg.to_s == "-0:464"
  end

  def test_base10_to_base60_zero
    assert 0.to_sxg == "0:0"
  end

  def test_base10_to_base60_with_leading_zeroes
    assert 14764.to_sxgf(1) == "0:464"
    assert 14764.to_sxgf(5) == "0:00464"
    assert 14764.to_sxgf()  == "0:464"
    assert 14764.to_sxgf(9) == "0:000000464"
    refute 12345.to_sxgf(9) == "0:000000464"
    assert (-14764).to_sxgf(1) == "-0:464"
    assert (-14764).to_sxgf(5) == "-0:00464"
    assert (-14764).to_sxgf()  == "-0:464"
    assert (-14764).to_sxgf(9) == "-0:000000464"
    refute (-12345).to_sxgf(9) == "-0:000000464"
  end

  def test_base60_frozen
    assert_raises FrozenError, "can't modify frozen NewBase60" do
      NewBase60.new("4JG").instance_variable_set('@to_i', 0)
    end
  end
end
