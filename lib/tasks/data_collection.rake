namespace :data_collection do
  desc "TODO"
  task angel: :environment do
    require 'open-uri'
    require 'json'
    require 'pp'

    last_page = 303
    page = 1

    while (page <= 303)
      # Get Jobs
      path = "https://api.angel.co/1/jobs?page=" + page.to_s

      buffer = open(path).read
      result = JSON.parse(buffer)
      puts result["jobs"].count

      result["jobs"].each do |j|
        puts "\n\n JOB \n"
        job = Job.new
        job.angel_id = j["id"]
        job.title = j["title"]
        job.description = j["description"]
        job.listing_created_at = j["created_at"]
        job.listing_updated_at = j["updated_at"]
        job.equity_min = j["equity_min"]
        job.equity_max = j["equity_max"]
        job.currency_code = j["currency_code"]
        job.job_type = j["job_type"]
        job.salary_min = j["salary_min"]
        job.salary_max = j["salary_max"]
        job.angellist_url = j["angellist_url"]

        location = nil
        j["tags"].each do |t|
          if t["tag_type"] == "LocationTag"
            location = t["name"]
          end
        end
        job.location = location

        role = nil
        j["tags"].each do |t|
          if t["tag_type"] == "RoleTag"
            role = t["name"]
          end
        end
        job.role = role

        # Company details
        startup = j["startup"]
        job.company_name = startup["name"]
        job.company_id = startup["id"]
        job.logo_url = startup["logo_url"]
        job.product_desc = startup["product_desc"]
        job.high_concept = startup["high_concept"]
        job.company_url = startup["company_url"]
        job.page_id = result["page"]

        begin
          if job.save
            puts job.to_yaml

            # Skills
            j["tags"].each do |t|
              if t["tag_type"] == "SkillTag"

                puts t["name"]
                skill = JobSkill.new
                skill.angel_id = t["id"]
                skill.name = t["name"]
                skill.job_id = job.id
                if skill.save
                else
                  puts "-- SKILL FAILED TO SAVE --"
                end
              end
            end
          end
        rescue
        end
      end

      page = page + 1
    end
  end

end
