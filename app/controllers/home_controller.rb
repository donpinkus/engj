class HomeController < ApplicationController
  def index
  end

  def summary
    job_skills = JobSkill.where(name: params[:skill_name])

    jobs = Job.joins(:job_skills).where(job_skills: {name: params[:skill_name]}, jobs: {currency_code: "USD"}).where.not(jobs: {salary_max: nil, salary_min: nil}).where("salary_min < salary_max")

    # JOBS
    new_jobs_this_week = jobs.where("listing_created_at > datetime('now', '-7 days')").count
    # new_jobs_this_week = jobs.where("listing_created_at BETWEEN LOCALTIMESTAMP - INTERVAL '14 days' AND LOCALTIMESTAMP")


    # SALARIES

    # avg_min_salary = (jobs.pluck(:salary_min).sum.to_f / jobs.count).to_i

    # avg_max_salary = (jobs.pluck(:salary_max).sum.to_f / jobs.count).to_i

    len = jobs.length
    sorted = jobs.pluck(:salary_min).sort
    med_min_salary = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2

    sorted = jobs.pluck(:salary_max).sort
    med_max_salary = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2


    summary = {
      total_jobs: jobs.count,
      med_min_salary: med_min_salary,
      med_max_salary: med_max_salary,
      new_jobs_this_week: new_jobs_this_week,
      skill: params[:skill_name]
    }

    render json: summary
  end
end
