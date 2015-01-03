class HomeController < ApplicationController
  def index
  end

  def summary
    job_skills = JobSkill.where(name: params[:skill_name])

    jobs = Job.joins(:job_skills).where(job_skills: {name: params[:skill_name]}, jobs: {currency_code: "USD"}).where.not(jobs: {salary_max: nil, salary_min: nil}).where("salary_min < salary_max")

    # JOBS
    if Rails.env == "development"
      new_jobs_this_week = jobs.where("listing_created_at > datetime('now', '-7 days')").count
    else
      new_jobs_this_week = jobs.where("listing_created_at > LOCALTIMESTAMP - INTERVAL '7 days'").count
    end

    # SALARIES

    # avg_min_salary = (jobs.pluck(:salary_min).sum.to_f / jobs.count).to_i

    # avg_max_salary = (jobs.pluck(:salary_max).sum.to_f / jobs.count).to_i

    len = jobs.length
    sorted = jobs.pluck(:salary_min).sort
    med_min_salary = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2

    sorted = jobs.pluck(:salary_max).sort
    med_max_salary = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2

    sql = "
        SELECT
          CASE
            WHEN bucket < 6
            THEN 60
            WHEN bucket >= 6 AND bucket < 13
            THEN bucket * 10
            WHEN bucket >= 13
            THEN 13 * 10
          END AS bucket,
          SUM(job_count) as job_count
        FROM (
          select bucket, count(*) as job_count
          from (
            SELECT CAST(salary_min/10000 AS int) AS bucket
            FROM jobs
            INNER JOIN job_skills
            ON jobs.id = job_skills.job_id
            AND job_skills.name = '#{params[:skill_name]}'
            WHERE currency_code = 'USD'
            AND salary_min < 250000
            AND salary_min > 10000
          ) as t1
          GROUP BY bucket
        )
        GROUP BY bucket
        ORDER BY bucket ASC
      "

    records_array = ActiveRecord::Base.connection.execute(sql)

    records_json = records_array.to_json

    summary = {
      total_jobs: jobs.count,
      med_min_salary: med_min_salary,
      med_max_salary: med_max_salary,
      new_jobs_this_week: new_jobs_this_week,
      salary_buckets: records_json,
      skill: params[:skill_name]
    }

    render json: summary
  end
end
