require "aaq/version"
module ActiveRecord; module Acts; end; end 

module ActiveRecord::Acts::Aaq

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def aaq(options = {})
      parse_options!(options)
      extend(AaqClassMethods)
      send(:include, InstanceMethods)
    end

    private
    def parse_options!(options)
      cattr_accessor :queryable_fields,
        :queryable_field_names, :queryable_fields_array,
        :sortable_field_names, :sortable_fields_array,
        :filterable_field_names, :filterable_fields_array,
        :queryable_default_fields,
        :queryable_default_page,
        :queryable_default_order,
        :queryable_default_filters,
        :queryable_default_columns,
        :queryable_key_field,
        :queryable_field_kinds,
        :queryable_scopes

      self.queryable_fields = options.delete(:fields)
      self.queryable_field_names = self.queryable_fields.keys.sort
      self.filterable_field_names = self.queryable_fields.reject { |key, opts| opts[:filterable] == false }.keys.sort
      self.sortable_field_names = self.queryable_fields.reject { |key, opts| opts[:sortable] == false }.keys.sort

      self.queryable_fields_array = queryable_field_names.map { |field| [ field.humanize.titlecase, field ] }
      self.filterable_fields_array = filterable_field_names.map { |field| [ field.humanize.titlecase, field ] }
      self.sortable_fields_array = sortable_field_names.map { |field| [ field.humanize.titlecase, field ] }

      self.queryable_default_fields = options.delete(:default_fields) || {}
      self.queryable_default_order = options.delete(:default_order) || nil
      self.queryable_default_filters = options.delete(:default_filters) || nil
      self.queryable_default_page = options.delete(:default_page) || 1
      self.queryable_key_field = options.delete(:key_field) || 'id'
      self.queryable_scopes = options.delete(:scopes) || {}

      self.queryable_field_kinds = self.queryable_field_names.inject({}) { |hsh, field|
        hsh[field] = self.queryable_fields[field][:kind] || "string"; hsh
      }

      fail("Unknown option(s): #{ options.keys.join(', ') }") unless options.empty?
    end

    module AaqClassMethods
    end

    module InstanceMethods
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Aaq)
