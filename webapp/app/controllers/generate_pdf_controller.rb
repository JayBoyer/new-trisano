require 'date'
require 'dbi'
require 'dbd/Jdbc'
require 'jdbc/postgres'
require 'pdf_forms'

class GeneratePdfController < ApplicationController
  include ApplicationHelper

  def generatepdf
    if params[:evnt_id] != '' && params[:evnt_id] != nil
      event_id = params[:evnt_id]
                  
      output_fields = {}
      out_filename = ''
      pdftk_path = '/usr/bin/pdftk'
      event = Event.find(event_id)
      template_pdf_name = params[:pdf_name]
      person = event.interested_party.person_entity.person
      birth_date = person.birth_date
      if(template_pdf_name == "hars")
        if(!birth_date.blank?)
          age = calculate_age(birth_date)
          if(age <= 12)
            template_pdf_name = "hars_pediatric"
          end
        end
      end
      
      #get the list of STD conditions
      diseases = Disease.find_by_sql("Select d.disease_name from diseases d " +
        "INNER join disease_events de on de.disease_id = d.id AND de.event_id = " + event_id)
      disease_name = "STD/HIV Co-Infection"
      if(!diseases.blank? && !diseases[0].blank?)
        disease_name = diseases[0].disease_name.strip
      end
      
      disease_to_code = { 
        "AIDS Adult" => "950",
        "AIDS Pediatric"=> "950",
        "Chlamydia trachomatis infection" => "200",
        "Gonococcal Infection" => "300",
        "HIV Infection, adult" => "900",
        "HIV Infection, pediatric" => "900",
        "HIV pediatric seroreverter" => "900",
        "HIV perinatal exposure" => "900",
        "Syphilis" => "700",
        "Syphilis, congenital" => "790",
        "Syphilis, early latent" => "730",
        "Syphilis, late latent" => "745",
        "Syphilis, late with clinical manifestations other than neurosyphilis" => "750",
        "Syphilis, neurosyphilis" => "700",
        "Syphilis, primary" => "710",
        "Syphilis, secondary" => "720",
        "Syphilis, unknown latent" => "700"
      }
      
      # check for multiple conditions
      std_condition_values = []
      form_short_name = "STD_field_record"
      form_coinfect = "std_coinfection"
      if (event.type == "ContactEvent")
        form_short_name = "STD_contact_field_record"
        form_coinfect = "std_contact_coinfection"
      end
      answer = fetch_answers(:first, event_id, form_short_name, "ref_basis")
      ref_basis = (!answer.blank? ? answer.text_answer : '')
      answer = fetch_answers(:first, event_id, form_short_name, "init_dt")
      init_dt = (!answer.blank? ? answer.text_answer : '')
      if(disease_name.include?("Co-Infection"))
        
        keys = [
          ["ct_condition", "ct_dispo"],
          ["gc_condition", "gc_dispo"],
          ["syph_condition", "syph_dispo"],
          ["hiv_condition", "hiv_dispo"],
        ]
        keys.each do |key|
          values = []
          values[0] = ref_basis
          answer = fetch_answers(:first, event_id, form_coinfect, key[0])
          disease_name = (!answer.blank? ? answer.text_answer : '').strip
          if(!disease_name.blank?)
            if(disease_name.length > 2)
              code = disease_name.slice(0,3)
              if (code == 'Yes')
                code = (key[0] == 'ct_condition')  ? '200' : '300'
              end
              values[1] = code
              values[2] = init_dt
              answer = fetch_answers(:first, event_id, form_short_name, key[1])
              values[3] = (!answer.blank? ? answer.text_answer : '')
              std_condition_values.push(values)
            end
          end
        end
      else
        values = []
        values[0] = ref_basis
        values[1] = disease_to_code[disease_name]
        values[2] = init_dt
        answer = fetch_answers(:first, event_id, form_short_name, "dispo")
        values[3] = (!answer.blank? ? answer.text_answer : '')
        std_condition_values[0] = values
      end
      
      pdf_path = Rails.root.to_s + "/app/pdfs/"
      template = pdf_path + "template/" + template_pdf_name + "_template.pdf"

      mappings = GeneratePdfMapping.find(:all, 
        :conditions => ["template_pdf_name = ?", template_pdf_name], :order => "id ASC")

      stack = []
      mappings.each do |mapping|
        values = []
        values[0] = ''
        # figure out if we are getting text answer or corresponding code from a form question
        use_code = (mapping.operation == 'answer_code')
        
        # if data from a core field
        if(mapping.form_short_name == "core")
          core_field_path = mapping['form_field_name']
          if(!core_field_path.blank?)
            elements = core_field_path.split("|")
            obj = event
            elements.each do |element|
              if(obj.blank?)
                break
              end
              obj = obj.try(element)
              if (obj != nil && obj.is_a?(Array))
                obj = obj[0]
              end
            end
            if(obj != nil)
              values[0] = obj.to_s.strip
              if(!mapping['code_name'].blank? && !values[0].blank?)
                external_code = ExternalCode.find(:first, :conditions => ["code_name = ? AND external_codes.id = ? ", mapping['code_name'], values[0]])
                begin
                values[0] = external_code.the_code.to_s
                rescue
                end
              end
            end
          end
        elsif(mapping.form_short_name.length > 0) # form field
          which = :last
          if(mapping.operation == "multi_line" || mapping.operation == "std_check_box")
            which = :all
          end
          answers = fetch_answers(which, event_id, mapping['form_short_name'], mapping['form_field_name'])
          if (answers.is_a?(Array))
            if(answers.length > 0)
              values = []
              answers.each do |answer|
                values.push(use_code ? answer['code'].strip() : answer['text_answer'].strip())
              end
            end
          elsif(!answers.blank?)
            values[0] = use_code ? answers['code'].strip() : answers['text_answer'].strip()
          end
        end

        case mapping.operation
        when "push"
          stack.push(values[0])
        when "age_subtract"
          text_birth_date = stack.pop()
          if(!text_birth_date.blank? && !values[0].blank?)
            # we expect a date formatted like 2012-02-24
            begin
              birth_date = Date.parse(text_birth_date)
              calc_date = Date.parse(values[0])
              output_fields[mapping['template_field_name']] = calculate_age(birth_date, calc_date).to_s
            rescue
            end
          end
        when "date_m_d_y"
          if(values[0].length > 9)
            output_fields[mapping['template_field_name']] = values[0][5..6] + mapping['concat_string'] + values[0][8..9] + mapping['concat_string'] + values[0][0..3]
          end
        when "concat"
          if(!values[0].blank?)
            output_fields[mapping['template_field_name']] += mapping['concat_string'] + values[0]
          end
        when "multi_line"
          output_fields[mapping['template_field_name']] = ''
          values.each do |value|
            output_fields[mapping['template_field_name']] += value + mapping['concat_string']
          end
        when "check_box"
          if(values[0] == mapping['match_value'])
            output_fields[mapping['template_field_name']] = 'On'
          end
        when "check_box_invert"
          if(values[0] != mapping['match_value'])
            output_fields[mapping['template_field_name']] = 'On'
          end
        when "fill_if_yes"
          test = stack.pop()
          if(test.length > 0 && test.upcase()[0,1] == "Y")
            output_fields[mapping['template_field_name']] = values[0]
          end
        when "fill_if_no"
          test = stack.pop()
          if(test.length > 0 && test.upcase()[0,1] == "N")
            output_fields[mapping['template_field_name']] = values[0]
          end
        when "date_now"
          output_fields[mapping['template_field_name']] = Date.today().to_s
        when "date_plus_week"
          output_fields[mapping['template_field_name']] = (Date.today()+7).to_s
        when "replace_if_dst_blank"
          if(output_fields[mapping['template_field_name']].blank?)
            output_fields[mapping['template_field_name']] = values[0]
          end
        when "replace_if_dst_blank_strip_alpha"
          if(output_fields[mapping['template_field_name']].blank?)
            output_fields[mapping['template_field_name']] = values[0].gsub(/[^0-9\-]/, "")
          end
        when /replace_if_src_not_blank|answer_code/
          if(!values[0].blank?)
            output_fields[mapping['template_field_name']] = values[0]
          end
        when "record_number"
          output_fields[mapping['template_field_name']] = event.record_number.to_s
        when "age"
          if(!birth_date.blank?)
            output_fields[mapping['template_field_name']] = calculate_age(birth_date).to_s
          end
        when "lab_results"
          output_fields[mapping['template_field_name']] = ''
          sql = "SELECT COALESCE(ctt.common_name, '') as test_type, " +
            "COALESCE(ec.code_description, '') as result, " +
            "COALESCE(lr.result_value, '') as result_value, " +
            "COALESCE(to_char(lr.collection_date, 'DD-MM-YY'), '') as collection_date " + 
              "FROM lab_results lr " + 
              "INNER JOIN participations p ON p.id = lr.participation_id AND p.event_id =" + event_id.to_s + " " +
              "LEFT JOIN external_codes ec ON ec.id = lr.test_result_id " +
              "LEFT JOIN common_test_types ctt ON ctt.id = test_type_id"
          
          lab_results = LabResult.find_by_sql(sql)
          lab_results.each do |lab_result|
            date = lab_result['collection_date']
            collection_date = ''
            if(!date.blank?) 
              # fix screwed up collection dates
              year = date.year
              month = date.mon
              day = date.day
              if(date.year < 1900)
                collection_date = (2000+day).to_s + "-" + month.to_s.rjust(2, "0") + "-" + year.to_s.rjust(2, "0")
              else
                collection_date = year.to_s + "-" + month.to_s,rjust(2, "0") + "-" + day.to_s.rjust(2, "0")
              end
            end
           output_fields[mapping['template_field_name']] += "Test type: " + lab_result['test_type'] + 
                ", Result: " + lab_result['result'] + "," + lab_result['result_value'] + ", Collection date: " + collection_date + "\n"
          end
        when "treatments"
          sql = "SELECT COALESCE(to_char(pt.treatment_date, 'YYYY-MM-DD'), '') as treatment_date, COALESCE(t.treatment_name, '') as treatment_name " +
                  "FROM participations_treatments pt " +
                    "INNER JOIN participations p ON p.id = pt.participation_id AND p.event_id = " + event_id.to_s + " " +
                    "INNER JOIN treatments t ON t.id = pt.treatment_id " +
                    "INNER JOIN external_codes ec on pt.treatment_given_yn_id = ec.id AND ec.code_description = 'Yes'"
          treatments = ParticipationsTreatment.find_by_sql(sql)
          output_fields[mapping['template_field_name']] = ''
          treatments.each do |treatment|
            output_fields[mapping['template_field_name']] += treatment['treatment_date'].to_s + ": " + treatment['treatment_name'] + "\n"
          end
        when "std_condition_code"
          indices = mapping['match_value'].split(",")
          i = indices[0].to_i
          j = indices[1].to_i
          if(std_condition_values.length >= i)
            output_fields[mapping['template_field_name']] = std_condition_values[i-1][j-1]
          end
        when "strip_alpha"
          output_fields[mapping['template_field_name']] = values[0].gsub(/[^0-9\-]/, "")
        when "std_check_box"
          values.each do |value|
            if(value.upcase.include?(mapping['match_value'].upcase))
              output_fields[mapping['template_field_name']] = 'On'
              break
            end
          end
        else # treat as replace
          output_fields[mapping['template_field_name']] = values[0]
        end
      end

      # put the fetched data into the hash
      if output_fields.size > 0
      
        # put the hash contents into the pdf
        fdf = PdfForms::Fdf.new output_fields
        fdf_filename = pdf_path + 'generate_' + event_id + '.fdf'
        fdf.save_to fdf_filename
        pdf_filename = pdf_path + 'generate_' + event_id + '.pdf'
        
        if(File.exists?(pdf_filename))
          begin
            File.delete(pdf_filename)
          rescue Exception => e
            logger.info(e.backtrace.inspect)
          end
        end
        
        # run the task in background, otherwise the jruby system call hangs
        system (pdftk_path + ' ' + template + ' fill_form ' + fdf_filename + ' output ' + pdf_filename + ' dont_ask' + ' &')
      end
      if(!File.exists?(pdf_filename))
        sleep(0.33)
      end
      if(File.exists?(pdf_filename))
        send_file(pdf_filename, :filename => template_pdf_name + event_id + '.pdf', :type => "application/pdf")
      end
    end
  end
  
  def fetch_answers(which, event_id, form_short_name, form_field_name)
    return Answer.find(which, :conditions => ["answers.event_id = ?", event_id], :joins=> 
      "INNER JOIN form_references fr ON fr.event_id = " + event_id + 
      " INNER JOIN forms f ON f.id = fr.form_id AND f.short_name = '" + form_short_name + "'" +
      " INNER JOIN form_elements fe ON fe.form_id = f.id " +
      " INNER JOIN questions q ON q.form_element_id = fe.id AND q.short_name = '" + form_field_name + "'" +
      " AND q.id = answers.question_id", :order => "id ASC")
  end
end
  