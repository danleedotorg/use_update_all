class HomeController < ApplicationController
  def update_using_each
    benchmarks =  Benchmark.measure do
      User.limit(number_param).each do |user|
        user.update_me_quickly = Time.zone.now
        user.save!
      end
    end
    render json: benchmarks
  end

  def update_using_update
    benchmarks =  Benchmark.measure do
      User.limit(number_param).all.update(update_me_quickly: Time.zone.now)
    end
    render json: benchmarks
  end

  def update_using_update_all
    benchmarks = Benchmark.measure do
      # update_all does not change updated_at or created_at fields, so do it manually
      User.limit(number_param).update_all(update_me_quickly: Time.zone.now, updated_at: Time.zone.now)
    end
    render json: benchmarks
  end

  def number_param
    Integer(params.require(:number))
  end
end
