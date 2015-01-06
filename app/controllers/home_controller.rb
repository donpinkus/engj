class HomeController < ApplicationController
  def index
  end

  def summary
    job_skills = JobSkill.where(name: params[:skill_name])

    jobs = Job.joins(:job_skills).where(job_skills: {name: params[:skill_name]}, jobs: {currency_code: "USD"}).where.not(jobs: {salary_max: nil, salary_min: nil}).where("salary_min < salary_max")

    # JOBS
    new_jobs_this_week = jobs.where("listing_created_at > LOCALTIMESTAMP - INTERVAL '7 days'").count

    sql = "
      SELECT
        date_part('month', listing_created_at) AS month,
        COUNT(1) AS new_job_count
      FROM jobs
      INNER JOIN job_skills
        ON jobs.id = job_skills.job_id
        AND job_skills.name = '#{params[:skill_name]}'
      WHERE currency_code = 'USD'
      GROUP BY month"


    records = ActiveRecord::Base.connection.execute(sql)
    new_jobs_by_month = records.to_json


    # SALARIES
    len = jobs.length
    sorted = jobs.pluck(:salary_min).sort
    med_min_salary = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2

    sorted = jobs.pluck(:salary_max).sort
    med_max_salary = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2

    bucketed_salaries_sql = "
        SELECT
          CASE
            WHEN bucket < 6
            THEN 60
            WHEN bucket >= 6 AND bucket < 15
            THEN bucket * 10
            WHEN bucket >= 15
            THEN 15 * 10
          END AS bucket,
          SUM(job_count) as job_count
        FROM (
          select bucket, count(*) as job_count
          from (
            SELECT CAST(salary_max/10000 AS int) AS bucket
            FROM jobs
            INNER JOIN job_skills
            ON jobs.id = job_skills.job_id
            AND job_skills.name = '#{params[:skill_name]}'
            WHERE currency_code = 'USD'
            AND salary_max < 250000
            AND salary_max > 10000
          ) as t1
          GROUP BY bucket
        ) as t2
        GROUP BY bucket
        ORDER BY bucket ASC
      "

    bucketed_salaries_records = ActiveRecord::Base.connection.execute(bucketed_salaries_sql)

    bucketed_salaries_json = bucketed_salaries_records.to_json

    summary = {
      total_jobs: jobs.count,
      new_jobs_this_week: new_jobs_this_week,
      new_jobs_by_month: new_jobs_by_month,
      med_min_salary: med_min_salary,
      med_max_salary: med_max_salary,
      salary_buckets: bucketed_salaries_json,
      skill: params[:skill_name]
    }

    render json: summary
  end
end
