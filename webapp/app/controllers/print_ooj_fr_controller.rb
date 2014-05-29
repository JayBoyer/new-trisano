require 'date'
require 'dbi'
require 'dbd/Jdbc'
require 'jdbc/postgres'
require 'pdf_forms'

class PrintOojFrController < ApplicationController
    def pdfoojfr
        if params[:evnt_id] != '' && params[:evnt_id] != nil
            @@event_id = params[:evnt_id]
            #@@event_id = '46286'
            @@hash_pdf_fields_ooj = {"aka" => "ooj_aka",
                                    "complexion"  => "ooj_complexion",
                                    "current_gender" => "ooj_current_gender",
                                    "comorbidity" => "ooj_comorbidity",
                                    "hair" => "ooj_hair",
                                    "height" => "ooj_height",
                                    "marital_status" => "ooj_marital_status",
                                    "other_physical_desc" => "ooj_other_phys",
                                    "size" => "ooj_size",
                                    "fr_notes" => "ooj_notes_1",
                                    "ooj_area" => "ooj_county_area",
                                    "ooj_state" => "ooj_state",
                                    "freq_exp" => "ooj_frequency",
                                    "type_ref" => "ooj_type_referral",
                                    "ref_basis" => "ooj_referral_basis",
                                    "first_exp" => "ooj_expo_first",
                                    "last_exp" => "ooj_expo_last",
                                    "init_dt" => "ooj_date_initiated",
                                    "contact_to" => "ct_to",
                                    "ct_dispo" => "ooj_200_dispo",
                                    "ct_dispo_dt" => "ooj_200_date",
                                    "gc_dispo" => "ooj_300_dispo",
                                    "gc_dispo_dt" => "ooj_300_date",
                                    "syph_dispo" => "ooj_700_dispo",
                                    "syph_dispo_dt" => "ooj_700_date",
                                    "hiv_dispo" => "ooj_900_dispo",
                                    "hiv_dispo_dt" => "ooj_900_date",
                                    "dispo" => "generic",
                                    "dispo_dt" => "generic",
                                    "ct_condition" => "generic",
                                    "gc_condition" => "generic",
                                    "syph_condition" => "generic",
                                    "hiv_condition" => "generic",
                                    "contact_size" => "ooj_size",
                                    "contact_hair" => "ooj_hair",
                                    "contact_height" => "ooj_height",
                                    "contact_complexion"  => "ooj_complexion",
                                    "contact_info" => "ooj_other_phys",
                                    "initiating_agency" => "ooj_initiating_agency"
                                    }
                                    
            @@hash_pdf_fields_fr = {"aka" => "fr_aka",
                                    "complexion"  => "fr_complexion",
                                    "current_gender" => "fr_current_gender",
                                    "hair" => "fr_hair",
                                    "height" => "fr_height",
                                    "marital_status" => "fr_marital_status",
                                    "other_physical_desc" => "fr_other_phys",
                                    "size" => "fr_size",
                                    "contact_size" => "fr_size",
                                    "contact_hair" => "fr_hair",
                                    "contact_height" => "fr_height",
                                    "contact_complexion"  => "fr_complexion",
                                    "contact_info" => "fr_other_phys",
                                    "ref_basis" => "ct_to"
                                    }
                                    
            @@hash_dispo_fields =  {"ct_dispo" => "ooj_200_dispo",
                                    "ct_dispo_dt" => "ooj_200_date",
                                    "gc_dispo" => "ooj_300_dispo",
                                    "gc_dispo_dt" => "ooj_300_date",
                                    "syph_dispo" => "ooj_700_dispo",
                                    "syph_dispo_dt" => "ooj_700_date",
                                    "hiv_dispo" => "ooj_900_dispo",
                                    "hiv_dispo_dt" => "ooj_900_date",
                                    "dispo" => "generic",
                                    "dispo_dt" => "generic",
                                    "ct_condition" => "generic",
                                    "gc_condition" => "generic",
                                    "syph_condition" => "generic",
                                    "hiv_condition" => "generic"
                                    }
                                    
            @@hash_output = {}
            @@note_fields = Array.new
            @@sth = ''
            @@sqlStr = ''
            out_filename = ''
 
 
            pdftk_path = '/usr/bin/pdftk'
            
            if Rails.env.production? || Rails.env.uat?
                pdf_path = '/opt/TriSano/current/app/pdfs/'
                template = '/opt/TriSano/current/app/pdfs/template/ooj_fr_template.pdf'
            end
            if Rails.env.development?
                pdf_path = File.expand_path('~/code/trisano/webapp/app/pdfs/')
                template = File.expand_path('~/code/trisano/webapp/app/pdfs/template/ooj_fr_template.pdf')
            end
            if Rails.env.demo?
                pdf_path = '~/code/trisano/webapp/app/pdfs/'
                template = '~/code/trisano/webapp/app/pdfs/template/ooj_fr_template.pdf'
            end
            
            #pdf_path = 'C:/pdfs/'
            #pdftk_path = "C:/Program Files (x86)/PDF Labs/PDFtk Server/bin/pdftk.exe"
            #template = 'C:/pdfs/template/tb_fields_template.pdf'
            
            config   = Rails.configuration.database_configuration
            host     = config[Rails.env]["host"]
            database = config[Rails.env]["database"]
            username = config[Rails.env]["username"]
            pass = config[Rails.env]["password"]
            port = config[Rails.env]["port"]
            @@dbh = DBI.connect("DBI:Jdbc:postgresql:" + "//" + host + ":" + port.to_s + "/" + database, username, pass, 'driver' => 'org.postgresql.Driver')
            
            def limits(inputString, length)
                limit = 0
                if inputString != '' && inputString != nil
                    if inputString.length > length  
                        limit = length
                    elsif inputString.length > 0
                        limit = inputString.length
                    end
                    return limit
                end
            end

            def breakUp (inputString)
                if inputString != nil && inputString != ''
                    splitchars = inputString.chars.to_a
                    return splitchars
                end
            end

            def compareDateStrings(date1, date2, comparison)
                if (date1 && date2) != '' && (date1 && date2) != nil
                    date1 = Date.strptime date1, '%Y-%m-%d'
                    date2 = Date.strptime date2, '%Y-%m-%d'
                    compareDates(date1, date2, comparison)
                end
            end
            
            def compareDates()
                if (date1 < date2) && comparison == 'early'
                    return date1.to_s
                elsif (date1 > date2) && comparison == 'early'
                    return date2.to_s
                elsif (date1 < date2) && comparison == 'late'
                    return date2.to_s
                elsif (date1 > date2) && comparison == 'late'
                    return date1.to_s
                end
            end
            
            def formatDate(date)
                date.strftime("%m/%d/%Y")                  
            end
            
            def formatDateString(date_string)
                date = Date.strptime(date_string, '%Y-%m-%d')
                date_string = formatDate(date)
            end
            
            def reset
                @@sqlStr = ''
                @@sth = ''
            end

            @first_name = ''
            @last_name = ''
            @middle_name = ''
            @fullname = ''
            @birth_date = ''
            @birth_sex = ''
            @ethnicity = ''
            @race = ''
            @street_num = ''
            @street_name = ''
            @unit_number = ''
            @city = ''
            @state = ''
            @county = ''
            @postal_code = ''
            @subject_address = ''
            @investigator = ''
            space = ' '
            @time = ''
            @invfullname = ''
            @recordnum = ''
            
            @time = Time.new
            @time = @time.strftime("%m/%d/%Y")
            
            if @time != '' && @time != nil
                @@hash_output['letter_date'] = @time
            end 
            
            @@sqlStr = "SELECT DISTINCT p.first_name, p.last_name, p.middle_name, p.birth_date, ex.the_code as birth_sex, ext.the_code as ethnicity, p.date_of_death, extc.the_code as dead, extr.code_description as race, 
                        ad.street_number, ad.street_name, ad.unit_number, ad.city, exta.code_description as state, extad.code_description as county, ad.postal_code, u.last_name as inv_last, u.first_name as inv_first, e.record_number
                        FROM public.people p 
                        LEFT JOIN public.participations pa ON p.entity_id = pa.primary_entity_id 
                        LEFT JOIN public.events e ON pa.event_id = e.id 
                        LEFT JOIN public.external_codes ex ON p.birth_gender_id = ex.id 
                        LEFT JOIN public.external_codes ext ON p.ethnicity_id = ext.id 
                        LEFT JOIN public.disease_events de ON de.event_id = e.id 
                        LEFT JOIN public.external_codes extc ON de.died_id = extc.id 
                        LEFT JOIN public.people_races pr on pr.entity_id = p.entity_id
                        LEFT JOIN public.external_codes extr on extr.id = pr.race_id
                        LEFT JOIN public.addresses ad on ad.event_id = e.id
                        LEFT JOIN public.external_codes exta on exta.id = ad.state_id
                        LEFT JOIN public.external_codes extad on extad.id = ad.county_id
                        LEFT JOIN public.users u on u.id = e.investigator_id
                        WHERE e.id=" + @@event_id

            @@sth = @@dbh.execute(@@sqlStr)
            @@sth.each do |row|
                @first_name = row['first_name']
                @last_name = row['last_name']
                @middle_name = row['middle_name']
                @birth_date = row['birth_date']
                @birth_sex = row['birth_sex']
                @ethnicity = row['ethnicity']
                @race = row['race']
                @street_num = row['street_number']
                @street_name = row['street_name']
                @unit_number = row['unit_number']
                @city = row['city']
                @state = row['state']
                @county = row['county']
                @postal_code = row['postal_code']
                @invlast = row['inv_last']
                @invfirst = row['inv_first']
                @recordnum = row['record_number']
           
                if @first_name != '' && @first_name != nil
                    @@hash_output['ooj_first_name'] = @first_name
                    @@hash_output['fr_first_name'] = @first_name
                else
                   @first_name = ''
                end   

                if @last_name != '' && @last_name != nil
                    @@hash_output['ooj_last_name'] = @last_name
                    @@hash_output['fr_last_name'] = @last_name
                else
                    @last_name = ''
                end     

                if @middle_name != '' && @middle_name != nil
                    @@hash_output['ooj_middle_name'] = @middle_name
                    @@hash_output['fr_middle_name'] = @middle_name
                else
                    @middle_name = '' 
                end     

                @fullname = @last_name + ',' + space + @first_name + space + @middle_name
            
                if @fullname.length > 3
                    @@hash_output['full_name'] = @fullname
                end
            
                if @birth_date != '' && @birth_date != nil
                    @@hash_output['ooj_dob'] = formatDate(@birth_date)
                    @@hash_output['fr_dob'] = formatDate(@birth_date)
                end    
            
                if @birth_sex != '' && @birth_sex != nil
                    @@hash_output['ooj_birth_gender'] = @birth_sex
                    @@hash_output['fr_birth_gender'] = @birth_sex
                end
            
                if @ethnicity != '' && @ethnicity != nil
                    @@hash_output['ooj_ethnicity'] = @ethnicity
                    @@hash_output['fr_ethnicity'] = @ethnicity
                end
            
                if @race != '' && @race != nil
                    @@hash_output['ooj_race'] = @race
                    @@hash_output['fr_race'] = @race
                end
                        
                if @street_num != "" && @street_num != nil
                    @subject_address = @street_num 
                end 
                
                if @street_name != "" && @street_name != nil
                    @subject_address = @subject_address + space + @street_name
                end 
            
                if @subject_address.length > 1
                    @@hash_output['ooj_street_address'] = @subject_address
                    @@hash_output['fr_street_address'] = @subject_address
                end
            
                if @unit_number != '' && @unit_number != nil
                    @@hash_output['ooj_unit_number'] = @unit_number
                    @@hash_output['fr_unit_number'] = @unit_number
                end
            
                if @city != '' && @city != nil
                    @@hash_output['ooj_city'] = @city
                    @@hash_output['fr_city'] = @city
                end
            
                if @state != '' && @state != nil
                    @@hash_output['ooj_addr_state'] = @state
                    @@hash_output['fr_state'] = @state
                end
            
                if @county != '' && @county != nil
                    @@hash_output['ooj_county'] = @county
                    @@hash_output['fr_county'] = @county
                end
            
                if @postal_code != '' && @postal_code != nil
                    @@hash_output['ooj_zip'] = @postal_code
                    @@hash_output['fr_zip'] = @postal_code
                end

                if @invlast != '' && @invlast != nil
                    @invfullname = @invlast
                end
                
                if @invfirst != '' && @invfirst != nil
                    @invfullname = @invfullname + ',' + space + @invfirst
                end
                
                if @invfullname.length > 3
                    @@hash_output['snhd_rep'] = @invfullname
                end
            
                if @recordnum != '' && @recordnum != nil
                    @@hash_output['ooj_record_num'] = @recordnum 
                    @@hash_output['fr_record_num'] = @recordnum 
                    @@hash_output['letter_record_num'] = @recordnum 
                end
            end

            reset
            
            @@sqlStr = "SELECT Distinct t.*
                        FROM events e 
                        LEFT JOIN participations p on p.event_id = e.id
                        LEFT JOIN telephones t on t.entity_id = p.primary_entity_id 
                        where e.id=" + @@event_id
                        
            @@sth = @@dbh.execute(@@sqlStr)
                @phonenumbs = ''
                if @@sth.column_names().length > 0
                    @@sth.each_with_index do |row, index|
                        @areacode = row['area_code']
                        @phonenum = row['phone_number']
                        @extension = row['extension']
                        
                        if @areacode != '' && @areacode != nil
                            @phonenumbs = @phonenumbs + @areacode + "-"
                        end
                        if @phonenum != '' && @phonenum != nil
                            @phonenumbs = @phonenumbs + @phonenum
                        end
                        if @extension != '' && @extension != nil
                            @phonenumbs = @phonenumbs + "x" + @extension
                        end
                        if index != @@sth.column_names.length - 1
                            @phonenumbs = @phonenumbs + ", "
                        end
                    end
                end
                
                @@hash_output['ooj_phone'] = @phonenumbs
                @@hash_output['fr_phone'] = @phonenumbs
            
            reset
            
            @@sqlStr = "SELECT c.common_name as test_type, o.organism_name, ec.code_description as test_result, l.result_value, l.units, l.collection_date, l.lab_test_date   
                        FROM public.lab_results l 
                        LEFT JOIN public.participations pa ON l.participation_id = pa.id
                        LEFT JOIN public.organisms o ON l.organism_id = o.id 
                        LEFT JOIN public.common_test_types c ON l.test_type_id = c.id
                        LEFT JOIN public.external_codes ec ON l.test_result_id = ec.id
                        WHERE pa.event_id=" + @@event_id
                        
            @@sth = @@dbh.execute(@@sqlStr)
                @labs = ''
                if @@sth.column_names.length > 0
                    @@sth.each_with_index do |row, index|
                        @test_type = row['test_type']
                        @organism = row['organism_name']
                        @testresult = row['test_result']
                        @resultvalue = row['result_value']
                        @units = row['units']
                        @collectiondate = row['collection_date']
                        @labtestdate = row['lab_test_date']
                        
                        if @organism != '' && @organism != nil
                            if @organism.downcase.include? 'neisseria'
                                @organism = 'GC'
                            end
                            if @organism.downcase.include? 'chlamydia'
                                @organism = 'CT'
                            end
                            if @organism.downcase.include? 'treponema'
                                @organism = 'Syphilis'
                            end
                            if @organism.downcase.include? 'human immunodeficiency virus'
                                @organism = 'HIV'
                            end
                            @labs = @labs + @organism + "-"
                        end
                        if @test_type != '' && @test_type != nil
                            @labs = @labs + @test_type + "-"
                        end
                        if @testresult != '' && @testresult != nil
                            if @testresult.include? ' / '
                                @testresult = @testresult.gsub(/ \/ /,'\/')
                            end
                            
                            @labs = @labs + @testresult + "-"
                        end
                        if @resultvalue != '' && @resultvalue != nil
                            @labs = @labs + @resultvalue + "-"
                        end
                        if @units != '' && @units != nil
                            @labs = @labs + @units + "-"
                        end
                        if @collectiondate != '' && @collectiondate != nil
                            @labs = @labs + 'CollectDate:' + formatDate(@collectiondate)
                        end
                        if index != @@sth.column_names.length - 1
                            @labs = @labs + "; "
                        end
                    end
                end
                
                @@hash_output['ooj_labs'] = @labs
                            
            reset
            
            @@sqlStr = "SELECT a.event_id, a.question_id, q.short_name AS question_short_name, q.question_text, a.id AS answer_id, a.text_answer AS answer_text, s.name AS section_name, a.repeater_form_object_id, 
                        a.repeater_form_object_type, s.repeater AS s_repeater, f.short_name AS form_short_name, q.data_type AS question_data_type, e.investigation_started_date, a.code AS answer_code, de.disease_id, d.disease_name
                        FROM answers a
                        LEFT JOIN questions q ON q.id = a.question_id
                        LEFT JOIN form_elements fe ON q.form_element_id = fe.id
                        LEFT JOIN form_elements s ON s.id = fe.parent_id
                        LEFT JOIN forms f ON f.id = fe.form_id
                        LEFT JOIN events e ON e.id = a.event_id
                        LEFT JOIN disease_events de on de.event_id = e.id
                        LEFT JOIN diseases d on d.id = de.disease_id
                        WHERE e.id=" + @@event_id + "and lower(f.short_name) in ('std_new_field_record', 'std_field_record', 'std_physical_desc', 'std_coinfection', 'std_new_interview_record')
                        ORDER BY q.short_name"
                        
            @@sth = @@dbh.execute(@@sqlStr)
                if @@sth.column_names.length > 0
                    @@sth = @@sth
                else
                    reset
                    @@sqlStr = "SELECT a.event_id, a.question_id, q.short_name AS question_short_name, q.question_text, a.id AS answer_id, a.text_answer AS answer_text, s.name AS section_name, a.repeater_form_object_id, 
                        a.repeater_form_object_type, s.repeater AS s_repeater, f.short_name AS form_short_name, q.data_type AS question_data_type, e.investigation_started_date, a.code AS answer_code, de.disease_id, d.disease_name
                        FROM answers a
                        LEFT JOIN questions q ON q.id = a.question_id
                        LEFT JOIN form_elements fe ON q.form_element_id = fe.id
                        LEFT JOIN form_elements s ON s.id = fe.parent_id
                        LEFT JOIN forms f ON f.id = fe.form_id
                        LEFT JOIN events e ON e.id = a.event_id
                        LEFT JOIN disease_events de on de.event_id = e.id
                        LEFT JOIN diseases d on d.id = de.disease_id
                        WHERE e.id=" + @@event_id + "and lower(f.short_name) in ('std_contact_field_record', 'std_physical_desc', 'std_coinfection', 'std_new_interview_record')
                        ORDER BY q.short_name"
                        
                    @@sth = @@dbh.execute(@@sqlStr)
                end 
                
                
            @@sth.each do |row|
              @question_short_name = row['question_short_name']
              @answer_text = row['answer_text']
              @disease_name = row['disease_name']
              @data_type = row['question_data_type']
              
                pdf_field = ''
                                
                if @@hash_pdf_fields_ooj.key?(@question_short_name)
                    pdf_field = @@hash_pdf_fields_ooj[@question_short_name]
                    
                    if @answer_text != '' && @answer_text != nil
                    
                        @answer_text = @answer_text.gsub(/\'/,'')
                        @answer_text = @answer_text.gsub(/\"/,'')
                        
                        if @data_type == "date"
                            @answer_text = formatDateString(@answer_text)
                        end
                    
                        if !@@hash_dispo_fields.key?(@question_short_name)
                                                        
                            if @question_short_name != "fr_notes"
                                @@hash_output[pdf_field] = @answer_text
                            
                                    if @@hash_pdf_fields_fr.key?(@question_short_name)
                                        pdf_field = @@hash_pdf_fields_fr[@question_short_name]
                                        @@hash_output[pdf_field] = @answer_text
                                    end
                            else
                                if @answer_text.length > 115
                                    @@hash_output['ooj_notes_1'] = @answer_text[0,115]
                                    @@hash_output['ooj_notes_2'] = @answer_text[115..-1]
                                else
                                    @@hash_output['ooj_notes_1'] = @answer_text[0,115]
                                end
                            end
                        else
                            if @disease_name.downcase != "std/hiv co-infection"
                                if @question_short_name == "dispo"
                                    if @disease_name.downcase.include? "chlamydia"
                                        @@hash_output['ooj_200_dispo'] = @answer_text[0,1]
                                        @@note_fields.push('200')
                                    end
                                    if @disease_name.downcase.include? "gonococcal"
                                        @@hash_output['ooj_300_dispo'] = @answer_text[0,1]
                                        @@note_fields.push('300')
                                    end
                                    if @disease_name.downcase.include? "syphilis"
                                        @@hash_output['ooj_700_dispo'] = @answer_text[0,1]
                                        @@note_fields.push('700')
                                    end
                                    if @disease_name.downcase.include? "hiv" or @disease_name.downcase.include? "aids"
                                        @@hash_output['ooj_900_dispo'] = @answer_text[0,1]
                                        @@note_fields.push('900')
                                    end
                                end
                                if @question_short_name == "dispo_dt"
                                    if @disease_name.downcase.include? "chlamydia"
                                        @@hash_output['ooj_200_date'] = @answer_text
                                    end
                                    if @disease_name.downcase.include? "gonococcal"
                                        @@hash_output['ooj_300_date'] = @answer_text
                                    end
                                    if @disease_name.downcase.include? "syphilis"
                                        @@hash_output['ooj_700_date'] = @answer_text
                                    end
                                    if @disease_name.downcase.include? "hiv" or @disease_name.downcase.include? "aids"
                                        @@hash_output['ooj_900_date'] = @answer_text
                                    end
                                end
                            else
                                if @question_short_name == "ct_condition"
                                    if @answer_text.downcase.include? "yes"
                                        @@note_fields.push('200')
                                    end
                                end
                                if @question_short_name == "ct_dispo"
                                    @@hash_output['ooj_200_dispo'] = @answer_text[0,1]
                                end
                                if @question_short_name == "ct_dispo_dt"
                                    @@hash_output['ooj_200_date'] = @answer_text
                                end
                                
                                if @question_short_name == "gc_condition"
                                    if @answer_text.downcase.include? "yes"
                                        @@note_fields.push('300')
                                    end
                                end
                                if @question_short_name == "gc_dispo"
                                    @@hash_output['ooj_300_dispo'] = @answer_text[0,1]
                                end
                                if @question_short_name == "gc_dispo_dt"
                                    @@hash_output['ooj_300_date'] = @answer_text
                                end
                                
                                if @question_short_name == "syph_condition"
                                    if @answer_text.downcase.include? "7"
                                        @@note_fields.push('700')
                                    end
                                end
                                if @question_short_name == "syph_dispo"
                                    @@hash_output['ooj_700_dispo'] = @answer_text[0,1]
                                end
                                if @question_short_name == "syph_dispo_dt"
                                    @@hash_output['ooj_700_date'] = @answer_text
                                end
                                
                                if @question_short_name == "hiv_condition"
                                    if @answer_text.downcase.include? "9"
                                        @@note_fields.push('900')
                                    end
                                end
                                if @question_short_name == "hiv_dispo"
                                    @@hash_output['ooj_900_dispo'] = @answer_text[0,1]
                                end
                                if @question_short_name == "hiv_dispo_dt"
                                    @@hash_output['ooj_900_date'] = @answer_text
                                end
                                
                            end
                        
                        end
                    end
                end 
            end 

            
            for i in 0..@@note_fields.length
                field_name = ''
                field_name = 'note_' + i.to_s
                @@hash_output[field_name] = @@note_fields[i]
            end 

            @@dbh.disconnect

            if @@hash_output.size > 0
                fdf = PdfForms::Fdf.new @@hash_output
                fdf_filename = pdf_path + 'oojfr_' + @@event_id + '.fdf'
                fdf.save_to fdf_filename
                pdf_filename = pdf_path + 'oojfr_' + @@event_id + '.pdf'
                
                system (pdftk_path + ' ' + template + ' fill_form ' + fdf_filename + ' output ' + pdf_filename + ' dont_ask')
            end

            send_file(pdf_filename, :filename => pdf_filename, :type => "application/pdf")
    
        end
    end
        
end
    