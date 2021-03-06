require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class DlValidatorTest < Test::Unit::TestCase
  context DlValidator do
    context '.invalid?' do

      Helper::VALID_DRIVERS_LICENSES.each do |state, licenses_array|
        licenses_array.each_with_index do |license, index|
          should "be a valid drivers license #{license} - #{state} index: #{index}" do
            assert !DlValidator.invalid?(license, state), state.inspect + ' ' + license.inspect
          end
        end
      end

      Helper::VALID_DRIVERS_LICENSES.each do |state, licenses_array|
        licenses_array.each_with_index do |license, index|
          should "not be a valid drivers license #{license} - #{state} index: #{index}" do
            assert DlValidator.invalid?(license + '123ABC', state), state.inspect + ' ' + license + '123ABC'
          end
        end
      end

      should 'return true for an undefined state abbreviation' do
        invalid = DlValidator.invalid?('123', 'QQ')
        assert invalid
      end

      should 'return true for an undefined full state name' do
        invalid = DlValidator.invalid?('123', 'BadState')
        assert invalid
      end

      should 'handle a state abbreviation with non-word characters' do
        state = '12}3 F (** __)L @ 5674``' # FL
        assert !DlValidator.invalid?(Helper::VALID_DRIVERS_LICENSES['FL'].first, state)
      end

      should 'handle a full state name with non-word characters' do
        state = '12_3 F (** )L o # R ^ I !!!! DA @   907' # FLORIDA
        assert !DlValidator.invalid?(Helper::VALID_DRIVERS_LICENSES['FL'].first, state)
      end

      should 'handle a state license with non-word characters' do
        license = 'F / @!!()_-=123  45%$#67  898?.,;76' # F123456789876
        assert !DlValidator.invalid?(license, 'FL')
      end

      should 'handle the state of Washington with an (*) in the License and should be valid' do
        license = 'DEOLID*237NS'
        assert DlValidator.valid?(license, 'WA')
      end

      should 'handle the state of Washington with an (*) in the License and should be invalid' do
        license = 'DEOLID*23dsdf7NS'
        assert !DlValidator.valid?(license, 'WA')
      end

      should 'return true for a nil drivers_license_number' do
        assert DlValidator.invalid?(drivers_license_number=nil, 'FL')
      end

      should 'return true for a nil drivers_license_state' do
        assert DlValidator.invalid?('123456', drivers_license_state=nil)
      end

      should 'return valid for Kentucky' do
        license = 'k12345678'
        assert DlValidator.valid?(license, 'KY')
      end

      should 'return invalid for Kentucky' do
        license = 'ka12345678'
        assert DlValidator.invalid?(license, 'KY')
      end

      should 'return valid for Illinois' do
        license = 'D61672179225'
        assert DlValidator.valid?(license, 'IL')
      end

      should 'return valid for Texas' do
        license = '38941528'
        assert DlValidator.valid?(license, 'TX')
        end

      should 'return valid for Virginia' do
        license = 'A62621386'
        assert DlValidator.valid?(license, 'VA')
      end




    end

    context '.get_abbreviation_key' do
      DlValidator::DlConfig::STATES.each do |state_abbreviation, state_name|
        should "return the correct state abbreviation #{state_abbreviation}" do
          assert_equal state_abbreviation, DlValidator.get_abbreviation_key(state_name)
        end
      end
    end

    context '.valid' do
      Helper::VALID_DRIVERS_LICENSES.each do |state, licenses_array|
        licenses_array.each_with_index do |license, index|
          should "be a valid drivers license #{license} - #{state} index: #{index}" do
            assert DlValidator.valid?(license, state), state.inspect + ' ' + license.inspect
          end
        end
      end

      Helper::VALID_DRIVERS_LICENSES.each do |state, licenses_array|
        licenses_array.each_with_index do |license, index|
          should "not be a valid drivers license #{license} - #{state} index: #{index}" do
            refute DlValidator.valid?(license + '123ABC', state), state.inspect + ' ' + license + '123ABC'
          end
        end
      end
    end
  end
end
