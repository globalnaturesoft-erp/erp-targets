module Erp::Targets
  class Target < ApplicationRecord
    belongs_to :creator, class_name: 'Erp::User'
    belongs_to :salesperson, class_name: 'Erp::User'
    belongs_to :period, class_name: 'Erp::Periods::Period'

    has_many :target_details, inverse_of: :target, dependent: :destroy
    accepts_nested_attributes_for :target_details, :reject_if => lambda { |a| a[:percent].blank? || a[:commission_amount].blank? }, :allow_destroy => true

    # class const
    STATUS_ACTIVE = 'active'
    STATUS_DELETED = 'deleted'

    def amount=(new_price)
      self[:amount] = new_price.to_s.gsub(/\,/, '')
    end

    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash

      # join with users table for search creator
      query = query.joins(:creator)

      # join with users table for search salesperson
      query = query.joins(:salesperson)

      # join with users table for search period
      query = query.joins(:period)

      and_conds = []

      #filters
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end

      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      # add conditions to query
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      # global filters
      global_filter = params[:global_filter]

      if global_filter.present?

				# filter by destination warehouse
				if global_filter[:period].present?
					query = query.where(period_id: global_filter[:period])
				end

				# filter by destination warehouse
				if global_filter[:salesperson].present?
					query = query.where(salesperson_id: global_filter[:salesperson])
				end

			end

      return query
    end

    def self.search(params)
      query = self.all
      query = self.filter(query, params)

      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      else
				query = query.order('created_at desc')
      end

      return query
    end

    def set_active
      update_columns(status: Erp::Targets::Target::STATUS_ACTIVE)
    end

    def set_deleted
      update_columns(status: Erp::Targets::Target::STATUS_DELETED)
    end

    def self.set_active_all
      update_all(status: Erp::Targets::Target::STATUS_ACTIVE)
    end

    def self.set_deleted_all
      update_all(status: Erp::Targets::Target::STATUS_DELETED)
    end

    def is_active?
      return self.status == Erp::Targets::Target::STATUS_ACTIVE
    end

    def is_deleted?
      return self.status == Erp::Targets::Target::STATUS_DELETED
    end

    def salesperson_name
			salesperson.present? ? salesperson.name : ''
		end

    def period_name
			period.present? ? period.name : ''
		end

  end
end
