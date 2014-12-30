class HomeController < ApplicationController
  def index
  end

  def summary
    job_skills = JobSkill.where(name: params[:skill_name])
    jobs = Job.joins(:job_skills).where(job_skills: {name: params[:skill_name]}, jobs: {currency_code: "USD"}).where.not(jobs: {salary_max: nil, salary_min: nil})

    # Get avg salary
    tot_min_salary = 0

    jobs.each do |j|
      if j.salary_min
        tot_min_salary = tot_min_salary + j.salary_min
      end
    end

    avg_min_salary = tot_min_salary / jobs.count

    # Get avg salary
    tot_max_salary = 0

    jobs.each do |j|
      if j.salary_max
        tot_max_salary = tot_max_salary + j.salary_max
      end
    end

    avg_max_salary = tot_max_salary / jobs.count

    summary = {
      total_jobs: jobs.count,
      avg_min_salary: avg_min_salary,
      avg_max_salary: avg_max_salary,
      skill: params[:skill_name]
    }

    render json: summary
  end
end
