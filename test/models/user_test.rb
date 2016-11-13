require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "A Lincoln", email: "al@gmail.com", password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "should validate for presence of name" do
		@user.name = "  "
		assert_not @user.valid?
	end

	test "should validate for presence of email" do
		@user.email = "  "
		assert_not @user.valid?
	end

	test "name should not be that long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not be that long" do
		@user.email = "#{'a' * 255}@gmail.com"
		assert_not @user.valid?
	end

	test "email validation should accept valid emails" do
		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
    	@user.email = address
    	assert @user.valid?, "#{address.inspect} should be valid"
    end
	end

	test "should reject invalid emails" do
		invalid_addresses = %w[ a gambo@gmail invalid_email@email@email ]
		invalid_addresses.each do |address|
			@user.email = address
			assert_not @user.valid?, "#{address.inspect} should be invalid"
		end
	end

	test "should validate email uniqueness" do
		duplicate_user = @user.dup
		@user.save
		assert_not duplicate_user.valid?
	end

	test "should ignore case when validating email uniquness" do
		duplicate_user = @user.dup
		duplicate_user.email.upcase!
		@user.save
		assert_not duplicate_user.valid?
	end

	test "password should be non-blank" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "password should be at least six characters long" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end
end
