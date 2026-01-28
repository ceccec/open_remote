module Assets
  module SolarParkAttributes
    def total_capacity
      (attributes_data || {})["totalCapacity"]
    end

    def total_power_output
      (attributes_data || {})["totalPowerOutput"]
    end

    def total_energy_generated
      (attributes_data || {})["totalEnergyGenerated"]
    end

    def daily_energy_generated
      (attributes_data || {})["dailyEnergyGenerated"]
    end

    def forecasted_generation
      (attributes_data || {})["forecastedGeneration"]
    end

    def performance_ratio
      (attributes_data || {})["performanceRatio"]
    end

    def location
      (attributes_data || {})["location"]
    end

    def update_performance_ratio!
      return unless total_capacity.to_f.positive?

      ratio = (total_power_output.to_f / total_capacity.to_f) * 100.0
      self.attributes_data ||= {}
      attributes_data["performanceRatio"] = ratio
      save!
    end
  end
end
