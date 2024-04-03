# frozen_string_literal: true

# This gives mongo models and icmibr models the ability to be soft-deleted.
# We give the model a soft deleted at field and then default scope it
# where records are not soft deleted.
# Some things to note:
# A default scope will assign a default
# value when creating a new record.  So we make sure the default is nil.
# see: https://stackoverflow.com/questions/32994650/mongoid-default-scope-overrides-default-value-why

require 'active_record'
require 'mongoid'

module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :exclude_soft_deleted, -> { where(soft_deleted_at: nil) }
    default_scope -> { exclude_soft_deleted }

    if ancestors.include?(ActiveRecord::Base)
      scope :soft_deleted, -> { unscoped.where.not(soft_deleted_at: nil) }
    elsif included_modules.include?(Mongoid::Document)
      scope :soft_deleted, -> { unscoped.excludes(soft_deleted_at: nil) }

      field :soft_deleted_at, type: DateTime
      index soft_deleted_at: 1
    end
  end

  # we are allowing soft_delete! to receive a block of code
  # to be executed once the record is soft deleted.
  # by default - we are performing a delayed job to remove record from index.
  def soft_delete!(&block)
    if self.class.ancestors.include?(ActiveRecord::Base)
      update_column('soft_deleted_at', Time.current)
    elsif self.class.included_modules.include?(Mongoid::Document)
      set(soft_deleted_at: Time.now)
    end

    block ||= proc do
      if defined?(Delayed::Job) && defined?(ElasticsearchRemoveFromIndexJob) && respond_to?(:should_index?)
        # here we are checking if the record is indexed using method respond_to?(:should_index?)
        # then we are performing `ElasticsearchRemoveFromIndexJob` through delayed job
        # which is responsible for removing record from search index
        Delayed::Job.enqueue(ElasticsearchRemoveFromIndexJob.new(klass: self.class, id: id))
      end
    end
    block.call

    self
  end

  def restore_soft_delete
    if self.class.ancestors.include?(ActiveRecord::Base)
      update_column('soft_deleted_at', nil)
    elsif self.class.included_modules.include?(Mongoid::Document)
      set(soft_deleted_at: nil)
    end

    self
  end
end
