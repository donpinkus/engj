class HomeController < ApplicationController
  def index
  end

  def summary
    total_jobs = Job.count
    distinct_skills = JobSkill.distinct.count(:name)
    skill_counts = JobSkill.group(:name).count

    if params[:role_filter] && params[:role_filter] != 'null'
      where_clause = " WHERE jobs.role = '#{params[:role_filter]}' "
      and_clause = " AND jobs.role = '#{params[:role_filter]}' "
    else
      where_clause = ' '
      and_clause = ' '
    end

    sql = "
      SELECT
        COUNT(1) as skill_occurrences,
        name
      FROM job_skills
      LEFT OUTER JOIN jobs
      ON job_skills.job_id = jobs.id
      " + where_clause + "
      GROUP BY name
      HAVING COUNT(1) > 1
      ORDER BY skill_occurrences DESC
      LIMIT 50"

    records = ActiveRecord::Base.connection.execute(sql)
    skill_frequencies = records.to_json

    sql = "
      SELECT
        CAST(AVG(salary) AS INT) AS avg_salary,
        skill_name,
        COUNT(1) AS skill_frequency
      FROM (
        SELECT
          (salary_max + salary_min) / 2 AS salary,
          job_skills.name AS skill_name
        FROM jobs
        INNER JOIN job_skills
        ON jobs.id = job_skills.job_id
        WHERE currency_code = 'USD'
        AND salary_max < 250000
        AND salary_max > 10000
        AND salary_min > 40000
        AND salary_min < salary_max
        " + and_clause + "
        ORDER BY skill_name ASC
      ) as t1
      GROUP BY skill_name
      HAVING COUNT(1) > 10
      ORDER BY avg_salary DESC"

    records = ActiveRecord::Base.connection.execute(sql)
    frequency_vs_salary = records.to_json

    summary = {
      total_jobs: total_jobs,
      distinct_skills: distinct_skills,
      skill_frequencies: skill_frequencies,
      frequency_vs_salary: frequency_vs_salary
    }

    render json: summary
  end

  def skill_analyzer
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


    # Related Skills
    related_skills_sql = "
      SELECT
        COUNT(1) AS occurrences,
        job_skills.name
      FROM (
        -- Get all jobs for the skill
        SELECT DISTINCT job_id AS job_id
        FROM job_skills
        WHERE name = '#{params[:skill_name]}'
      ) job_ids
      INNER JOIN job_skills
      ON job_ids.job_id = job_skills.job_id
      WHERE name <> '#{params[:skill_name]}'
      GROUP BY job_skills.name
      ORDER BY occurrences DESC
      LIMIT 20
    "

    related_skills_records = ActiveRecord::Base.connection.execute(related_skills_sql)

    related_skills_json = related_skills_records.to_json


    summary = {
      total_jobs: jobs.count,
      new_jobs_this_week: new_jobs_this_week,
      new_jobs_by_month: new_jobs_by_month,
      med_min_salary: med_min_salary,
      med_max_salary: med_max_salary,
      salary_buckets: bucketed_salaries_json,
      related_skills: related_skills_json,
      skill: params[:skill_name]
    }

    render json: summary
  end
end
