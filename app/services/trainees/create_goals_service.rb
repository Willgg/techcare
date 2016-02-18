module Trainees
  class CreateGoalsService
    def initialize(trainee)
      @trainee = trainee
    end

    def call
      create_weight_goal
      create_blood_pressure_goal
      create_fat_ratio_goal
      create_step_goal
    end

    def only_for(measure_type_id)
      case measure_type_id
      when 1
        create_weight_goal
      when 2
        create_blood_pressure_goal
      when 3
        create_fat_ratio_goal
      when 4
        create_step_goal
      else
        raise ArgumentError, 'Measure type is not recognized'
      end
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

    def create_step_goal
      Trainees::Goals::CreateStepService.new(@trainee).call
    end
  end
end
