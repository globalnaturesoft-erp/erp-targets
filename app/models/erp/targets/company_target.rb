module Erp::Targets
  class CompanyTarget < ApplicationRecord
    belongs_to :creator, class_name: 'Erp::User'
    belongs_to :period, class_name: 'Erp::Periods::Period'

    validates :name, :amount, :period_id, :bonus_percent, presence: true

    # class const
    STATUS_ACTIVE = 'active'
    STATUS_DELETED = 'deleted'

    def amount=(new_price)
      self[:amount] = new_price.to_s.gsub(/\,/, '')
    end

    def bonus_percent=(new_price)
      self[:bonus_percent] = new_price.to_s.gsub(/\,/, '')
    end

    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash

      # join with users table for search creator
      query = query.joins(:creator)

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

    # display period name
    def period_name
			period.present? ? period.name : ''
		end

    def self.get_by_period(period)
      self.where(period_id: period.id).first
    end

    def revenue
      Erp::Payments::PaymentRecord.revenue_by_period(self.period)
    end

    def revenue_1_percent
      revenue*0.01
    end

    def reached_target?
      self.revenue >= self.amount
    end

    def commission_amount
      self.reached_target? ? self.revenue_1_percent/(Erp::User.employee_count) : 0
    end
  end
end
