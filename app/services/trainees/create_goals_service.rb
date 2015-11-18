module Trainees
  class CreateGoalsService
    def initialize(trainee)
      @trainee = trainee
    end

    def call
      create_weight_goal
      create_blood_pressure_goal
      create_fat_ratio_goal
    end

    private

    def create_weight_goal
      Trainees::Goals::CreateWeightService.new(@trainee).call
    end

    def create_blood_pressure_goal
      Trainees::Goals::CreateBloodPressureService.new(@trainee).call
    end

    def create_fat_ratio_goal
       Trainees::Goals::CreateFatRatioService.new(@trainee).call
    end
  end
end
