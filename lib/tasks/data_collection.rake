namespace :data_collection do
  desc "TODO"
  task angel: :environment do
    # https://api.angel.co/1/jobs

    # jobs
    #   id
    #   angel_id
    #   title
    #   description
    #   created_at
    #   updated_at
    #   equity_min
    #   equity_max
    #   currency_code
    #   job_type
    #   salary_min
    #   salary_max
    #   angellist_url
    #   location (tags.tag_type=LocationTag&name)
    #   role (tags.tag_type=RoleTag&name)
    #   company_name (startup.name)
    #   company_id (startup.id)
    #   logo_url (startup.logo_url)
    #   product_desc (startup.product_desc)
    #   high_concept (startup.high_concept)
    #   company_url (startup.company_url)
    #   page_id

    # jobs an hgel_id:integer title:string description:text listing_created_at:string listing_updated_at:datetime equity_min:float equity_max:float currency_code:string job_type:string salary_min:integer salary_max:integer angellist_url:string location:string role:string company_name:string company_id:integer logo_url:string product_desc:text high_concept:text company_url:string page_id:integer

    # job_skills
    #   angel_id
    #   job_id
    #   display_name

    # rails g JobSkill job:references name:string id:integer

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
        puts "hi \n\n\n"
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

        if job.save
          # Skills
          skills = []
          j["tags"].each do |t|
            if t["tag_type"] == "SkillTag"
              skill = JobSkill.new
              skill.angel_id = t["id"]
              skill.name = t["name"]
              skill.job_id = job.id
              skill.save
            end
          end
        end

        puts job.to_yaml
      end

      page = page + 1
    end
  end

end
