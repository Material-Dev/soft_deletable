# frozen_string_literal: true

require_relative "../test_helper"

describe "Soft Deletable with Active Record" do
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

  with_model :User do
    table do |t|
      t.datetime :soft_deleted_at
    end

    # The model block is the Active Record model’s class body.
    model do
      include SoftDeletable
    end
  end

  describe "exclude_soft_deleted scope and default scope" do
    it "return records which are not soft deleted" do
      User.create
      User.create
      User.create(soft_deleted_at: Time.now)

      assert_equal(User.exclude_soft_deleted.count, 2)
    end
  end

  describe "soft_deleted scope" do
    it "return records which are soft deleted" do
      User.create
      User.create
      User.create(soft_deleted_at: Time.now)

      assert_equal(User.soft_deleted.count, 1)
    end
  end

  describe "soft_delete!" do
    it "soft deletes a record" do
      user = User.create
      user.soft_delete!
      refute_nil(user.soft_deleted_at)
    end
  end

  describe "restore_soft_delete" do
    it "restores a soft deleted record" do
      user = User.create(soft_deleted_at: Time.now)
      user.restore_soft_delete
      assert_nil(user.soft_deleted_at)
    end
  end
end


describe "Soft Deletable with MongoId" do
  class User
    include Mongoid::Document
    include SoftDeletable
  end

  describe "exclude_soft_deleted scope and default scope" do
    it "return criteria with selector for soft_deleted_at as nil" do
      users_criteria = User.exclude_soft_deleted
      assert_equal(users_criteria.selector, {"soft_deleted_at"=>nil})
    end
  end

  describe "soft_deleted scope" do
    it "return criteria with selector for soft_deleted_at as not nil" do
      users_criteria = User.soft_deleted
      assert_equal(users_criteria.selector, {"soft_deleted_at"=>{"$ne"=>nil}})
    end
  end

  describe "soft_delete!" do
    it "soft deletes a record" do
      user = User.new
      user.soft_delete!
      refute_nil(user.soft_deleted_at)
    end
  end

  describe "restore_soft_delete" do
    it "restores a soft deleted record" do
      user = User.new(soft_deleted_at: Time.now)
      user.restore_soft_delete
      assert_nil(user.soft_deleted_at)
    end
  end
end
