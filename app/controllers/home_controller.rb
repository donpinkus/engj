class HomeController < ApplicationController
  def index
  end

  def summary
    job_skills = JobSkill.where(name: params[:skill_name])
    jobs = Job.joins(:job_skills).where(job_skills: {name: params[:skill_name]}, jobs: {currency_code: "USD"}).where.not(jobs: {salary_max: nil, salary_min: nil})

    # Get avg salary
    avg_min_salary = (jobs.pluck(:salary_min).sum.to_f / jobs.count).to_i

    avg_max_salary = (jobs.pluck(:salary_max).sum.to_f / jobs.count).to_i

    summary = {
      total_jobs: jobs.count,
      avg_min_salary: avg_min_salary,
      avg_max_salary: avg_max_salary,
      skill: params[:skill_name]
    }

    render json: summary
  end
end
