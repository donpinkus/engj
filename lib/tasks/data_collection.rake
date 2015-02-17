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
      path = "https://api.angel.co/1/jobs?access_token=eb754e725a3e3db031a51d18f831e878415d71501a0840d2&page=" + page.to_s

      buffer = open(path).read
      result = JSON.parse(buffer)
      puts result["jobs"].count

      result["jobs"].each do |j|
        puts "\n\n JOB \n"
        job = Job.new
        job.angel_id = j["id"]
        job.company_angel_id = j["startup"]["id"]

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


        begin
          if job.save
            puts job.to_yaml

            # Company
            company_angel_id = job.company_angel_id

            if !Company.exists?(angel_id: company_angel_id)
              puts "Getting company info for #{company_angel_id}"

              company = Company.new
              company.angel_id = company_angel_id

              response = HTTParty.get("https://api.angel.co/1/startups/#{angel_id}?access_token=eb754e725a3e3db031a51d18f831e878415d71501a0840d2")

              if response.code == 404
                puts "This company no longer exists."
                company.deleted = true
                company.save
                next
              elsif response.code == 403
                puts "Over rate limit."
                break
              end

              company_result = JSON.parse(response.body)

              puts company_result.to_yaml

              # Set company info
              company.hidden = company_result["hidden"]
              company.community_profile = company_result["community_profile"]
              company.name = company_result["name"]
              company.angellist_url = company_result["angellist_url"]
              company.logo_url = company_result["logo_url"]
              company.thumb_url = company_result["thumb_url"]
              company.quality = company_result["quality"]
              company.product_desc = company_result["product_desc"]
              company.high_concept = company_result["high_concept"]
              company.follower_count = company_result["follower_count"]
              company.company_url = company_result["company_url"]
              company.angel_created_at = company_result["angel_created_at"]
              company.angel_updated_at = company_result["angel_updated_at"]
              company.twitter_url = company_result["twitter_url"]
              company.blog_url = company_result["blog_url"]
              company.video_url = company_result["video_url"]

              company.save
            end

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

  task populate_angel_companies: :environment do
    # response = HTTParty.get('https://api.stackexchange.com/2.2/questions?site=stackoverflow')

    # puts response.body, response.code, response.message, response.headers.inspect

    company_angel_ids = Job.uniq.pluck(:company_angel_id)

    company_angel_ids.each do |angel_id|
      puts angel_id

      if !Company.exists?(angel_id: angel_id)
        puts "Getting company info for #{angel_id}"

        company = Company.new
        company.angel_id = angel_id

        # Fetch company info.
        response = HTTParty.get("https://api.angel.co/1/startups/#{angel_id}?access_token=eb754e725a3e3db031a51d18f831e878415d71501a0840d2")

        puts response.code

        if response.code == 404
          puts "This company no longer exists."
          company.deleted = true
          company.save
          next
        elsif response.code == 403
          puts "Over rate limit."
          break
        end

        company_result = JSON.parse(response.body)

        puts company_result.to_yaml

        # Set company info
        company.hidden = company_result["hidden"]
        company.community_profile = company_result["community_profile"]
        company.name = company_result["name"]
        company.angellist_url = company_result["angellist_url"]
        company.logo_url = company_result["logo_url"]
        company.thumb_url = company_result["thumb_url"]
        company.quality = company_result["quality"]
        company.product_desc = company_result["product_desc"]
        company.high_concept = company_result["high_concept"]
        company.follower_count = company_result["follower_count"]
        company.company_url = company_result["company_url"]
        company.angel_created_at = company_result["angel_created_at"]
        company.angel_updated_at = company_result["angel_updated_at"]
        company.twitter_url = company_result["twitter_url"]
        company.blog_url = company_result["blog_url"]
        company.video_url = company_result["video_url"]

        company.save
      end
    end
  end
end



















