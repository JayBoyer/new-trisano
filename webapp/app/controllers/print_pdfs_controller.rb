require 'date'
require 'pg' 
require 'pdf_forms'

class PrintPdfsController < ApplicationController
	def pdf
		if params[:evnt_id] != '' && params[:evnt_id] != nil
			@@count = 0
			@@boundary = 0
			@@event_id = params[:evnt_id]
			#@@event_id = '265'
			@@hash_pdf_fields = {}
			@@hash_output = {}
			@@indvChars = Array.new
			@@res = ''
			@@resnrq = ''
			@@sqlStr = ''
			@@idrs_var = ''
			@@fdrs_var = ''
			@@other_drug = ''
			@@tb_drug_test = ''
			@@tb_drug_test_result = ''
			@@setOther = false
			@@lateDate = '1900-01-01'
			@@smallx = 'x'
			@@bigX = 'X'
			out_filename = ''
			pdftk_path = '/usr/bin/pdftk'
			
			if Rails.env.production? || Rails.env.uat?
				pdf_path = '/opt/TriSano/current/app/pdfs/'
				template = '/opt/TriSano/current/app/pdfs/template/tb_fields_template.pdf'
			end
			if Rails.env.development?
				pdf_path = '/home/trisano/code/trisano/webapp/app/pdfs/'
				template = '/home/trisano/code/trisano/webapp/app/pdfs/template/tb_fields_template.pdf'
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
			@@conn = PGconn.open( :host => host, :dbname => database, :user => username, :password => pass, :port => port )
					
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

			def arrangeDate ( inputString )
					if inputString.length > 0 && inputString != nil
							inputString = inputString[4,2] + inputString[6,2] + inputString[0,4]
					end		
			end

			def trimDashes(inputString)
				if inputString.include? '-'
					inputString = inputString.gsub!(/-/,'')
				end
				return inputString
			end

			def formatDate (inputString)
				if inputString != '' && inputString != nil
					modString = trimDashes(inputString)
					modDateString = arrangeDate(modString)
				end
			end


			def reset 
				@@count = 0
				@@boundary = 0
				@@hash_pdf_fields = {}
				@@indvChars.clear
				@@sqlStr = ''
				@@repeat_id = 0
				@@idrs_var = ''
				@@other_drug = ''
				@@tb_drug_test = ''
				@@tb_drug_test_result = ''
				@@setOther = false
				@@lateDate = '1900-01-01'
				begin
					if !@@res.num_tuples.zero?
						@@res.clear
					end
				rescue
				end
			end

			def resetRpt
				@@repeatID = 0
				@@targetDate = '1900-01-01'
				@single_question_answer_r_orig = ''
				@single_question_answer_r = ''
				@phin_var_r = ''
				begin
					if !@@resrpt.num_tuples.zero?
						@@resrpt.clear
					end
				rescue
				end
			end

			def PdfMapping(varName)
				sqlStr = "SELECT * FROM tb_phin_pdfs where phin_var = '" + varName + "' order by var_order" 
				res = @@conn.exec(sqlStr)
				return res
			end

			def populatePdfFields(res)
				res.each do |row|
					pdf_field = ''
					pdf_field = row['pdf_var']
					@@hash_pdf_fields[@@count] = pdf_field
					@@count += 1
				end 
			end

			def populateArrayStatic(inputString, arrayLength)
				for i in 0..arrayLength
					@@indvChars[i] = inputString
				end 
			end

			def populateOutputHash(bound)
				if bound > 0
					for i in 0..bound - 1
						pdf_field_key = ''
						pdf_field_key = @@hash_pdf_fields[i] 
						pdf_field_value = ''
						pdf_field_value = @@indvChars[i]
						@@hash_output[pdf_field_key] = pdf_field_value
					end
				end 
			end

			def compareDates(date1, date2, comparison)
				if (date1 && date2) != '' && (date1 && date2) != nil
					date1 = Date.strptime date1, '%Y-%m-%d'
					date2 = Date.strptime date2, '%Y-%m-%d'
					
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
			end

			def repeatID(testDate, eventID, question)
				rpt_id = 0
				sqlStr = "SELECT repeater_form_object_id FROM tb_qa_views where answer_text = '" + testDate + "' and lower(question_short_name) = '" + question + "' and event_id =" + eventID 
				res = @@conn.exec(sqlStr)
				if !@@res.num_tuples.zero?
					res.each do |row|
						rpt_id =  row['repeater_form_object_id']
					end
				end
				return rpt_id
			end

			#INV111 and INV177
			@@sqlStr = "SELECT * FROM public.events where id =" + @@event_id
					  
			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
			  @investigation_started_date = row['investigation_started_date']
			  @first_reported_PH_date = row['first_reported_PH_date']
			end 

			year_reported = ''

			if @first_reported_PH_date != '' && @first_reported_PH_date != nil
				dateString = formatDate(@first_reported_PH_date)
				year_reported = dateString[4,8]
				@@indvChars = breakUp(dateString)
				res_inv111 = PdfMapping('inv111')
				populatePdfFields(res_inv111)
				@@boundary = limits(dateString, @@count)
				populateOutputHash(@@boundary)
				reset
			end
			
			if @investigation_started_date != '' && @investigation_started_date != nil
				dateString = formatDate(@investigation_started_date)
				@@indvChars = breakUp(dateString)
				res_inv177 = PdfMapping('inv177')
				populatePdfFields(res_inv177)
				@@boundary = limits(dateString, @@count)
				populateOutputHash(@@boundary)
				reset
			end
			
			#TB080, 081, 082
			@street_num = ''
			@street_name = ''
			@unit_number = ''
			@city = ''
			@state = ''
			@postal_code = ''

			@@sqlStr = "SELECT a.city, ex.code_description as county, a.postal_code, a.street_number, a.street_name, a.unit_number, ex.the_code as state FROM public.addresses a LEFT JOIN public.external_codes ex ON a.state_id = ex.id LEFT JOIN public.external_codes e ON a.county_id = e.id WHERE a.event_id=" + @@event_id

			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
			  @city = row['city']
			  @county = row['county']
			  @postal_code = row['postal_code']
			  @street_num = row['street_number']
			  @street_name = row['street_name']
			  @unit_number = row['unit_number']
			  @state = row['state']
			end 

			if @city != '' && @city != nil
				@@indvChars = breakUp(@city)
				res_tb080 = PdfMapping('tb080')
				populatePdfFields(res_tb080)
				@@boundary = limits(@city, @@count)
				populateOutputHash(@@boundary)
				reset
			else 
				@city = ''
			end	

			if @county != '' && @county != nil
				@@indvChars = breakUp(@county)
				res_tb081 = PdfMapping('tb081')
				populatePdfFields(res_tb081)
				@@boundary = limits(@county, @@count)
				populateOutputHash(@@boundary)
				reset
			else
				@county = ''
			end	

			if @postal_code != '' && @postal_code != nil
				@@indvChars = breakUp(@postal_code)
				res_tb082 = PdfMapping('tb082')
				populatePdfFields(res_tb082)
				@@boundary = limits(@postal_code, @@count)
				populateOutputHash(@@boundary)
				reset
			else
				@postal_code = ''
			end	

			#DEM162, DEM163, DEM165, DEM114, DEM115, DEM155, INV146	  
			space = ' '
			if @street_num == nil
				@street_num = ''	
			end
			if @street_name == nil
				@street_name = ''	
			end
			if @unit_number == nil
				@unit_number = ''	
			end	
			if @state == nil
				@state = ''	
			end
			
			@subject_address = @street_num + space + @street_name + space + @unit_number + space + @city + ',' + space + @state + space + space + @postal_code
			res_pg1_street_address = PdfMapping('street_address')
			populatePdfFields(res_pg1_street_address)
			populateArrayStatic(@subject_address, @@count)
			@@boundary = @@count
			populateOutputHash(@@boundary)
			reset 

			@@sqlStr = "SELECT DISTINCT p.first_name, p.last_name, p.middle_name, p.birth_date, ex.the_code as birth_sex, ext.the_code as ethnicity, p.date_of_death, extc.the_code as dead FROM public.people p LEFT JOIN public.participations pa ON p.entity_id = pa.primary_entity_id LEFT JOIN public.events e ON pa.event_id = e.id LEFT JOIN public.external_codes ex ON p.birth_gender_id = ex.id LEFT JOIN public.external_codes ext ON p.ethnicity_id = ext.id LEFT JOIN public.disease_events de ON de.event_id = e.id LEFT JOIN public.external_codes extc ON de.died_id = extc.id WHERE e.id=" + @@event_id

			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
			  @first_name = row['first_name']
			  @last_name = row['last_name']
			  @middle_name = row['middle_name']
			  @birth_date = row['birth_date']
			  @date_of_death = row['date_of_death']
			  @birth_sex = row['birth_sex']
			  @ethnicity = row['ethnicity']
			  @dead = row['dead']
			 end 

			 if @first_name != '' && @first_name != nil
				@@indvChars[0] = @first_name
				res_first_name = PdfMapping('patient_f_name')
				populatePdfFields(res_first_name)
				populateArrayStatic(@first_name, @@count)
				@@boundary = @@count
				populateOutputHash(@@boundary)
				reset
			end	

			if @last_name != '' && @last_name != nil
				@@indvChars[0] = @last_name
				res_last_name = PdfMapping('patient_l_name')
				populatePdfFields(res_last_name)
				populateArrayStatic(@last_name, @@count)
				@@boundary = @@count
				populateOutputHash(@@boundary)
				reset
			end	

			if @middle_name != '' && @middle_name != nil
				@@indvChars[0] = @middle_name
				res_middle_name = PdfMapping('patient_m_name')
				populatePdfFields(res_middle_name)
				populateArrayStatic(@middle_name, @@count)
				@@boundary = @@count
				populateOutputHash(@@boundary)
				reset
			end	

			if @postal_code != '' && @postal_code != nil
				@@indvChars[0] = @postal_code
				res_postal_code = PdfMapping('s_zipcode')
				populatePdfFields(res_postal_code)
				populateArrayStatic(@postal_code, @@count)
				@@boundary = @@count
				populateOutputHash(@@boundary)
				reset
			end	

			if @birth_date != '' && @birth_date != nil
				dateString = formatDate(@birth_date)
				@@indvChars = breakUp(dateString)
				res_dem115 = PdfMapping('dem115')
				populatePdfFields(res_dem115)
				@@boundary = limits(dateString, @@count)
				populateOutputHash(@@boundary)
				reset
			end	

			if @date_of_death != '' && @date_of_death != nil
				dateString = formatDate(@date_of_death)
				@@indvChars = breakUp(dateString)
				res_inv146 = PdfMapping('inv146')
				populatePdfFields(res_inv146)
				@@boundary = limits(dateString, @@count)
				populateOutputHash(@@boundary)
				reset
			end	

			if @birth_sex != '' && @birth_sex != nil
				if @birth_sex == 'M'
					@@hash_output['dem114_m'] = @@smallx
				elsif @birth_sex == 'F'
					@@hash_output['dem114_f'] = @@smallx
				end
			end

			if @ethnicity != '' && @ethnicity != nil
				if @ethnicity == 'H'
					@@hash_output['dem155_h'] = @@smallx
				elsif @ethnicity == 'NH'
					@@hash_output['dem155_n'] = @@smallx
				end
			end

			if @dead != '' && @dead != nil
				if @dead == 'Y'
					@@hash_output['tb101_d'] = @@smallx
				elsif @dead == 'N'
					@@hash_output['tb101_a'] = @@smallx
				end
			end


			#INV172, INV173
			@@sqlStr = "SELECT answer_text FROM tb_phin_qa_single_views WHERE phin_var = 'inv172_l' and event_id =" + @@event_id

			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
			  @city_case_num = row['answer_text']
			 end 

			if @city_case_num != '' && @city_case_num != nil
				@@indvChars = breakUp(@city_case_num)
				res_inv172 = PdfMapping('pg1_inv172_l')
				populatePdfFields(res_inv172)
				@@boundary = limits(@city_case_num, @@count)
				populateOutputHash(@@boundary)
				reset
				
				@@indvChars = breakUp(@city_case_num)
				res_inv172 = PdfMapping('pg4_inv172_l')
				populatePdfFields(res_inv172)
				@@boundary = limits(@city_case_num, @@count)
				populateOutputHash(@@boundary)
				reset
					
				@@indvChars = breakUp(@city_case_num)
				res_inv172 = PdfMapping('pg5_inv172_l')
				populatePdfFields(res_inv172)
				@@boundary = limits(@city_case_num, @@count)
				populateOutputHash(@@boundary)
				reset
				
				if year_reported != '' && year_reported != nil
					@@indvChars = breakUp(year_reported)
					res_inv172_y = PdfMapping('pg1_inv172_y')
					populatePdfFields(res_inv172_y)
					@@boundary = limits(year_reported, @@count)
					populateOutputHash(@@boundary)
					reset

					@@indvChars = breakUp(year_reported)
					res_inv172_y = PdfMapping('pg4_inv172_y')
					populatePdfFields(res_inv172_y)
					@@boundary = limits(year_reported, @@count)
					populateOutputHash(@@boundary)
					reset
					
					@@indvChars = breakUp(year_reported)
					res_inv172_y = PdfMapping('pg5_inv172_y')
					populatePdfFields(res_inv172_y)
					@@boundary = limits(year_reported, @@count)
					populateOutputHash(@@boundary)
					reset
				end
				
				#Hard Code State
				@@hash_output['pg1_inv172_s1'] = 'N'
				@@hash_output['pg1_inv172_s2'] = 'V'
				@@hash_output['pg4_inv172_s1'] = 'N'
				@@hash_output['pg4_inv172_s2'] = 'V'
				@@hash_output['pg5_inv172_s1'] = 'N'
				@@hash_output['pg5_inv172_s2'] = 'V'
			end

			@@sqlStr = "SELECT answer_text FROM tb_phin_qa_single_views WHERE phin_var = 'inv173_l' and event_id =" + @@event_id

			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
			  @state_case_num = row['answer_text']
			end 

			if @state_case_num != '' && @state_case_num != nil
				@@indvChars = breakUp(@state_case_num)
				res_inv173 = PdfMapping('pg1_inv173_l')
				populatePdfFields(res_inv173)
				@@boundary = limits(@state_case_num, @@count)
				populateOutputHash(@@boundary)
				reset
				
				@@indvChars = breakUp(@state_case_num)
				res_inv173 = PdfMapping('pg4_inv173_l')
				populatePdfFields(res_inv173)
				@@boundary = limits(@state_case_num, @@count)
				populateOutputHash(@@boundary)
				reset
					
				@@indvChars = breakUp(@state_case_num)
				res_inv173 = PdfMapping('pg5_inv173_l')
				populatePdfFields(res_inv173)
				@@boundary = limits(@state_case_num, @@count)
				populateOutputHash(@@boundary)
				reset
				
				if year_reported != '' && year_reported != nil
					@@indvChars = breakUp(year_reported)
					res_inv173_y = PdfMapping('pg1_inv173_y')
					populatePdfFields(res_inv173_y)
					@@boundary = limits(year_reported, @@count)
					populateOutputHash(@@boundary)
					reset
					
					@@indvChars = breakUp(year_reported)
					res_inv173_y = PdfMapping('pg4_inv173_y')
					populatePdfFields(res_inv173_y)
					@@boundary = limits(year_reported, @@count)
					populateOutputHash(@@boundary)
					reset
					
					@@indvChars = breakUp(year_reported)
					res_inv173_y = PdfMapping('pg5_inv173_y')
					populatePdfFields(res_inv173_y)
					@@boundary = limits(year_reported, @@count)
					populateOutputHash(@@boundary)
					reset
				end
				
				@@hash_output['pg1_inv173_s1'] = 'N'
				@@hash_output['pg1_inv173_s2'] = 'V'
				@@hash_output['pg4_inv173_s1'] = 'N'
				@@hash_output['pg4_inv173_s2'] = 'V'
				@@hash_output['pg5_inv173_s1'] = 'N'
				@@hash_output['pg5_inv173_s2'] = 'V'
			end	

			#Process non-repeating questions
			@@sqlStr = "SELECT * FROM  tb_phin_qa_single_views where phin_var is not null and event_id =" + @@event_id + " order by phin_var"

			@@resnrq = @@conn.exec(@@sqlStr)
			@@resnrq.each do |row|
			  @single_question_answer_orig = row['answer_text']
			  @single_question_answer = row['answer_text'].downcase
			  @single_question_answer_code = row['answer_code']
			  @phin_var = row['phin_var']
			  
				if @single_question_answer != '' && @single_question_answer != nil
					if @phin_var == 'dem126' 
						@@hash_output['dem126'] = @single_question_answer_orig
					end
					
					if @phin_var == 'dem152' 
						#Strip carriage returns from answer
						@single_question_answer = @single_question_answer.gsub(/\r?\n/, " ")
						if @single_question_answer.include? "american indian or alaska native"
							@@hash_output['dem152_am'] = @@smallx
						end
						if @single_question_answer.include? "asian"
							@@hash_output['dem152_as'] = @@smallx
						end
						if @single_question_answer.include? "black or african american"
							@@hash_output['dem152_b'] = @@smallx
						end
						if @single_question_answer.include? "native hawaiian or other pacific islander"
							@@hash_output['dem152_n'] = @@smallx
						end
						if @single_question_answer.include? "white"
							@@hash_output['dem152_w'] = @@smallx
						end
					end
					
					if @phin_var == 'dem152_as_1' 
						@@hash_output['dem152_as_1'] = @single_question_answer_orig
					end
					
					if @phin_var == 'dem153' 
						@@hash_output['dem153'] = @single_question_answer_orig
					end
					
					if @phin_var == 'dem2003' 
						if @single_question_answer == 'yes'
							@@hash_output['dem2003_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['dem2003_n'] = @@smallx
						end
					end
					
					if @phin_var == 'dem2005' 
						if @single_question_answer.include? '-'
							@single_question_answer = trimDashes(@single_question_answer)
						end
						@single_question_answer = @single_question_answer.rjust(6, '0')
						@@indvChars = breakUp(@single_question_answer)
						res_dem2005 = PdfMapping('dem2005')
						populatePdfFields(res_dem2005)
						@@boundary = limits(@single_question_answer, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb099' 
						if @single_question_answer == 'yes'
							@@hash_output['tb099_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb099_n'] = @@smallx
						end
					end
					
					if @phin_var == 'tb100' 
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb100 = PdfMapping('pg1_tb100')
						populatePdfFields(res_tb100)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
						
						dateString = dateString[4,8]
						@@indvChars = breakUp(dateString)
						res_tb100 = PdfMapping('pg4_tb100')
						populatePdfFields(res_tb100)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
						
						@@indvChars = breakUp(dateString)
						res_tb100 = PdfMapping('pg5_tb100')
						populatePdfFields(res_tb100)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb102' 
						if @single_question_answer == 'yes'
							@@hash_output['tb102_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb102_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb102_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb103' 
						@@indvChars = breakUp(@single_question_answer)
						res_tb103 = PdfMapping('tb103')
						populatePdfFields(res_tb103)
						@@boundary = limits(@single_question_answer, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb108' 
						if @single_question_answer == 'positive'
							@@hash_output['tb108_p'] = @@smallx
						elsif @single_question_answer == 'negative'
							@@hash_output['tb108_n'] = @@smallx
						elsif @single_question_answer == 'not done'
							@@hash_output['tb108_nd'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb108_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb109' 
						if @single_question_answer == 'positive'
							@@hash_output['tb109_p'] = @@smallx
						elsif @single_question_answer == 'negative'
							@@hash_output['tb109_n'] = @@smallx
						elsif @single_question_answer == 'not done'
							@@hash_output['tb109_nd'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb109_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb110' 
						if @single_question_answer == 'positive'
							@@hash_output['tb110_p'] = @@smallx
						elsif @single_question_answer == 'negative'
							@@hash_output['tb110_n'] = @@smallx
						elsif @single_question_answer == 'not done'
							@@hash_output['tb110_nd'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb110_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb111' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb111 = PdfMapping('tb111')
							populatePdfFields(res_tb111)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'tb113' 
						if @single_question_answer == 'positive'
							@@hash_output['tb113_p'] = @@smallx
						elsif @single_question_answer == 'negative'
							@@hash_output['tb113_n'] = @@smallx
						elsif @single_question_answer == 'not done'
							@@hash_output['tb113_nd'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb113_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb114' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb114 = PdfMapping('tb114')
							populatePdfFields(res_tb114)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'tb122' 
						if @single_question_answer == 'indeterminate'
							@@hash_output['tb122_i'] = @@smallx
						elsif @single_question_answer == 'negative'
							@@hash_output['tb122_n'] = @@smallx
						elsif @single_question_answer == 'not offered'
							@@hash_output['tb122_no'] = @@smallx
						elsif @single_question_answer == 'positive'
							@@hash_output['tb122_p'] = @@smallx
						elsif @single_question_answer == 'refused'
							@@hash_output['tb122_r'] = @@smallx
						elsif @single_question_answer == 'test done, results unknown'
							@@hash_output['tb122_ru'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb122_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb125' 
						@@indvChars = breakUp(@single_question_answer)
						res_tb125 = PdfMapping('tb125')
						populatePdfFields(res_tb125)
						@@boundary = limits(@single_question_answer, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb126' 
						@@indvChars = breakUp(@single_question_answer)
						res_tb126 = PdfMapping('tb126')
						populatePdfFields(res_tb126)
						@@boundary = limits(@single_question_answer, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb127' 
						if @single_question_answer == 'yes'
							@@hash_output['tb127_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb127_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb127_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb128' 
						if @single_question_answer == 'yes'
							@@hash_output['tb128_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb128_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb128_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb129' 
						if @single_question_answer == 'federal prison'
							@@hash_output['tb129_fp'] = @@smallx
						elsif @single_question_answer == 'juvenile correctional facility'
							@@hash_output['tb129_jc'] = @@smallx
						elsif @single_question_answer == 'local jail'
							@@hash_output['tb129_lj'] = @@smallx
						elsif @single_question_answer == 'other correctional facility'
							@@hash_output['tb129_oc'] = @@smallx
						elsif @single_question_answer == 'state prison'
							@@hash_output['tb129_sp'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb129_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb130' 
						if @single_question_answer == 'yes'
							@@hash_output['tb130_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb130_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb130_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb131' 
						if @single_question_answer == 'alcohol or drug treatment facility'
							@@hash_output['tb131_al'] = @@smallx
						elsif @single_question_answer == 'hospital-based facility'
							@@hash_output['tb131_hf'] = @@smallx
						elsif @single_question_answer == 'mental health residential facility'
							@@hash_output['tb131_mf'] = @@smallx
						elsif @single_question_answer == 'nursing home'
							@@hash_output['tb131_nh'] = @@smallx
						elsif @single_question_answer == 'other long-term care facility'
							@@hash_output['tb131_of'] = @@smallx
						elsif @single_question_answer == 'residential facility'
							@@hash_output['tb131_rf'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb131_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb148' 
						if @single_question_answer == 'yes'
							@@hash_output['tb148_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb148_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb148_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb148a' 
						if @single_question_answer == 'no'
							@@hash_output['tb148_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb148_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb149' 
						if @single_question_answer == 'yes'
							@@hash_output['tb149_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb149_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb149_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb149a' 
						if @single_question_answer == 'no'
							@@hash_output['tb149_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb149_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb150' 
						if @single_question_answer == 'yes'
							@@hash_output['tb150_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb150_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb150_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb150a' 
						if @single_question_answer == 'no'
							@@hash_output['tb150_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb150_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb153' 
						if @single_question_answer == 'count as a tb case'
							@@hash_output['tb153_ctb'] = @@bigX
						elsif @single_question_answer == 'verified case: counted by another u.s. area (e.g., county, state)'
							@@hash_output['tb153_ntb_c'] = @@bigX
						end
						if @single_question_answer == 'verified case: tb treatment initiated in another country'
							@@hash_output['tb153_ntb_t'] = @@bigX
						elsif @single_question_answer == 'verified case: recurrent tb within 12 months after completion of therapy'
							@@hash_output['tb153_ntb_r'] = @@bigX
						end
					end
					
					if @phin_var == 'tb156' 
						if @single_question_answer == 'yes'
							@@hash_output['tb156_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb156_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb156_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb157'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb157 = PdfMapping('tb157')
						populatePdfFields(res_tb157)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb173' 
						if @single_question_answer == 'yes'
							@@hash_output['tb173_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb173_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb173_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb175' 
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb175 = PdfMapping('tb175')
						populatePdfFields(res_tb175)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb176'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb176 = PdfMapping('tb176')
						populatePdfFields(res_tb176)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb177' 
						if @single_question_answer == 'adverse treatment event'
							@@hash_output['tb177_at'] = @@smallx
						elsif @single_question_answer == 'completed therapy'
							@@hash_output['tb177_ct'] = @@smallx
						end
						if @single_question_answer == 'died'
							@@hash_output['tb177_d'] = @@smallx
						elsif @single_question_answer == 'lost'
							@@hash_output['tb177_lo'] = @@smallx
						end
						if @single_question_answer == 'not tb'
							@@hash_output['tb177_ntb'] = @@smallx
						elsif @single_question_answer == 'other'
							@@hash_output['tb177_ot'] = @@smallx
						end
						if @single_question_answer == 'uncooperative or refused'
							@@hash_output['tb177_rf'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb177_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb178' 
						#Strip carriage returns from answer
						@single_question_answer = @single_question_answer.gsub(/\r?\n/, " ")
						if @single_question_answer.include? 'local/state health department (hd)'
							@@hash_output['tb178_hd'] = @@smallx
						end
						if @single_question_answer.include? 'institutional/correctional'
							@@hash_output['tb178_ic'] = @@smallx
						end 
						if @single_question_answer.include? 'inpatient care only'
							@@hash_output['tb178_ico'] = @@smallx
						end
						if @single_question_answer.include? 'ihs, tribal hd, or tribal corporation'
							@@hash_output['tb178_ihs'] = @@smallx
						end
						if @single_question_answer.include? 'private outpatient'
							@@hash_output['tb178_po'] = @@smallx
						end
						if @single_question_answer.include? 'other'
							@@hash_output['tb178_ot'] = @@smallx
						end
						if @single_question_answer.include? 'unknown'
							@@hash_output['tb178_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb179' 
						if @single_question_answer == 'no, totally self-administered'
							@@hash_output['tb179_ntsa'] = @@smallx
						elsif @single_question_answer == 'yes, both directly observed and self-administered'
							@@hash_output['tb179_ybdo'] = @@smallx
						elsif @single_question_answer == 'yes, totally directly observed'
							@@hash_output['tb179_ytdo'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb179_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb181'
						@@indvChars = breakUp(@single_question_answer)
						res_tb181 = PdfMapping('tb181')
						populatePdfFields(res_tb181)
						@@boundary = limits(@single_question_answer, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb182' 
						if @single_question_answer == 'yes'
							@@hash_output['tb182_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb182_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb182_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb183'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb183 = PdfMapping('tb183')
						populatePdfFields(res_tb183)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb205' 
						#Strip carriage returns from answer
						@single_question_answer = @single_question_answer.gsub(/\r?\n/, " ")
						
						if @single_question_answer.include? 'bone and/or joint'
							@@hash_output['tb205_bj'] = @@smallx
						end
						if @single_question_answer.include? 'genitourinary'
							@@hash_output['tb205_gu'] = @@smallx
						end
						if @single_question_answer.include? 'lymphatic: axillary'
							@@hash_output['tb205_la'] = @@smallx
						end
						if @single_question_answer.include? 'lymphatic: cervical'
							@@hash_output['tb205_lc'] = @@smallx
						end
						if @single_question_answer.include? 'lymphatic: intrathoracic'
							@@hash_output['tb205_li'] = @@smallx
						end
						if @single_question_answer.include? 'lymphatic: other'
							@@hash_output['tb205_lo'] = @@smallx
						end
						if @single_question_answer.include? 'lymphatic: unknown'
							@@hash_output['tb205_lu'] = @@smallx
						end
						if @single_question_answer.include? 'laryngeal'
							@@hash_output['tb205_ly'] = @@smallx
						end
						if @single_question_answer.include? 'meningeal'
							@@hash_output['tb205_mg'] = @@smallx
						end
						if @single_question_answer.include? 'site not stated'
							@@hash_output['tb205_ns'] = @@smallx
						end
						if @single_question_answer.include? 'other: enter anatomic code(s)'
							@@hash_output['tb205_ot'] = @@smallx
						end
						if @single_question_answer.include? 'pleural'
							@@hash_output['tb205_pl'] = @@smallx
						end
						if @single_question_answer.include? 'peritoneal'
							@@hash_output['tb205_pt'] = @@smallx
						end
						if @single_question_answer.include? 'pulmonary'
							@@hash_output['tb205_pu'] = @@smallx
						end
					end
					
					if @phin_var == 'tb205_1' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb205_1 = PdfMapping('tb205_1')
							populatePdfFields(res_tb205_1)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'tb205_2' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb205_2 = PdfMapping('tb205_2')
							populatePdfFields(res_tb205_2)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'tb205_3' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb205_3 = PdfMapping('tb205_3')
							populatePdfFields(res_tb205_3)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'tb206' 
						if @single_question_answer == 'health care worker'
							@@hash_output['tb206_hw'] = @@smallx
						elsif @single_question_answer == 'correctional facility employee'
							@@hash_output['tb206_cf'] = @@smallx
						elsif @single_question_answer == 'migrant/seasonal worker'
							@@hash_output['tb206_mw'] = @@smallx
						elsif @single_question_answer == 'other occupation'
							@@hash_output['tb206_oc'] = @@smallx
						elsif @single_question_answer == 'retired'
							@@hash_output['tb206_rt'] = @@smallx
						elsif @single_question_answer == 'unemployed'
							@@hash_output['tb206_un'] = @@smallx
						elsif @single_question_answer == 'not eligible for employment (eg. student, homemaker, disabled persons)'
							@@hash_output['tb206_nse'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb206_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb207_y' 
						@@indvChars = breakUp(@single_question_answer_orig)
						res_tb207_y = PdfMapping('tb207_y')
						populatePdfFields(res_tb207_y)
						@@boundary = limits(@single_question_answer_orig, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb207_s' 
						@@indvChars = breakUp(@single_question_answer_code)
						res_tb207_s = PdfMapping('tb207_s')
						populatePdfFields(res_tb207_s)
						@@boundary = limits(@single_question_answer_code, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb207_l' 
						@@indvChars = breakUp(@single_question_answer_orig)
						res_tb207_l = PdfMapping('tb207_l')
						populatePdfFields(res_tb207_l)
						@@boundary = limits(@single_question_answer_orig, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb208' 
						@@indvChars = breakUp(@single_question_answer_orig)
						res_tb208 = PdfMapping('tb208')
						populatePdfFields(res_tb208)
						@@boundary = limits(@single_question_answer_orig, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb209_y' 
						@@indvChars = breakUp(@single_question_answer_orig)
						res_tb209_y = PdfMapping('tb209_y')
						populatePdfFields(res_tb209_y)
						@@boundary = limits(@single_question_answer_orig, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb209_s' 
						@@indvChars = breakUp(@single_question_answer_code)
						res_tb209_s = PdfMapping('tb209_s')
						populatePdfFields(res_tb209_s)
						@@boundary = limits(@single_question_answer_code, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb209_l' 
						@@indvChars = breakUp(@single_question_answer_orig)
						res_tb209_l = PdfMapping('tb209_l')
						populatePdfFields(res_tb209_l)
						@@boundary = limits(@single_question_answer_orig, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb210' 
						@@indvChars = breakUp(@single_question_answer_orig)
						res_tb210 = PdfMapping('tb210')
						populatePdfFields(res_tb210)
						@@boundary = limits(@single_question_answer_orig, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb211' 
						@@hash_output['tb211'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb215' 
						if @single_question_answer == 'yes'
							@@hash_output['tb215_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb215_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb215_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb216' 
						@@hash_output['tb216'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb217' 
						@@hash_output['tb217'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb218' 
						@@hash_output['tb218'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb220' 
						if @single_question_answer == 'yes'
							@@hash_output['tb220_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb220_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb220_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb221'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb221 = PdfMapping('tb221')
						populatePdfFields(res_tb221)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb223'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb223 = PdfMapping('tb223')
						populatePdfFields(res_tb223)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb225'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb225 = PdfMapping('tb225')
						populatePdfFields(res_tb225)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb227' 
						if @single_question_answer == 'public health lab'
							@@hash_output['tb227_p'] = @@smallx
						elsif @single_question_answer == 'commercial lab'
							@@hash_output['tb227_c'] = @@smallx
						elsif @single_question_answer == 'other'
							@@hash_output['tb227_ot'] = @@smallx
						end
					end
					
					if @phin_var == 'tb228'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb228 = PdfMapping('tb228')
						populatePdfFields(res_tb228)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb230' 
						#Strip carriage returns from answer
						@single_question_answer = @single_question_answer.gsub(/\r?\n/, " ")
						
						if @single_question_answer.include? 'smear'
							@@hash_output['tb230_s'] = @@smallx
						end
						if @single_question_answer.include? 'pathology/cytology'
							@@hash_output['tb230_p'] = @@smallx
						end
					end
					
					if @phin_var == 'tb231'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb231 = PdfMapping('tb231')
						populatePdfFields(res_tb231)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb233'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb233 = PdfMapping('tb233')
						populatePdfFields(res_tb233)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb234' 
						if @single_question_answer == 'public health lab'
							@@hash_output['tb234_p'] = @@smallx
						elsif @single_question_answer == 'commercial lab'
							@@hash_output['tb234_c'] = @@smallx
						elsif @single_question_answer == 'other'
							@@hash_output['tb234_ot'] = @@smallx
						end
					end
					
					if @phin_var == 'tb235' 
						if @single_question_answer == 'indeterminate'
							@@hash_output['tb235_i'] = @@smallx
						elsif @single_question_answer == 'negative'
							@@hash_output['tb235_n'] = @@smallx
						elsif @single_question_answer == 'not done'
							@@hash_output['tb235_nd'] = @@smallx
						elsif @single_question_answer == 'positive'
							@@hash_output['tb235_p'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb235_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb236'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb236 = PdfMapping('tb236')
						populatePdfFields(res_tb236)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb238' 
						if @single_question_answer == 'yes'
							@@hash_output['tb238_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb238_n'] = @@smallx
						end
					end
					
					if @phin_var == 'tb239' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb239 = PdfMapping('tb239')
							populatePdfFields(res_tb239)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'tb240'
						dateString = formatDate(@single_question_answer)
						@@indvChars = breakUp(dateString)
						res_tb240 = PdfMapping('tb240')
						populatePdfFields(res_tb240)
						@@boundary = limits(dateString, @@count)
						populateOutputHash(@@boundary)
						reset
					end	
					
					if @phin_var == 'tb242' 
						if @single_question_answer == 'public health lab'
							@@hash_output['tb242_p'] = @@smallx
						elsif @single_question_answer == 'commercial lab'
							@@hash_output['tb242_c'] = @@smallx
						elsif @single_question_answer == 'other'
							@@hash_output['tb242_ot'] = @@smallx
						end
					end
					
					if @phin_var == 'tb254' 
						if @single_question_answer == 'contact investigation'
							@@hash_output['tb254_ci'] = @@smallx
						elsif @single_question_answer == 'employment/administrative testing'
							@@hash_output['tb254_et'] = @@smallx
						elsif @single_question_answer == 'health care worker'
							@@hash_output['tb254_hw'] = @@smallx
						elsif @single_question_answer == 'immigration medical exam'
							@@hash_output['tb254_ie'] = @@smallx
						elsif @single_question_answer == 'incidental lab result'
							@@hash_output['tb254_il'] = @@smallx
						elsif @single_question_answer == 'abnormal chest radiograph (consistent with tb)'
							@@hash_output['tb254_rad'] = @@smallx
						elsif @single_question_answer == 'tb symptoms'
							@@hash_output['tb254_tb'] = @@smallx
						elsif @single_question_answer == 'targeted testing'
							@@hash_output['tb254_tt'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb254_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb256' 
						if @single_question_answer == 'yes'
							@@hash_output['tb256_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb256_n'] = @@smallx
						end
					end
					
					if @phin_var == 'tb257' 
						#Strip carriage returns from answer
						@single_question_answer = @single_question_answer.gsub(/\r?\n/, " ")
						
						if @single_question_answer.include? 'diabetes mellitus'
							@@hash_output['tb257_dm'] = @@smallx
						end
						if @single_question_answer.include? 'immunosuppression(not hiv/aids)'
							@@hash_output['tb257_is'] = @@smallx
						end
						if @single_question_answer.include? 'contact of infectious tb patient'
							@@hash_output['tb257_itb'] = @@smallx
						end
						if @single_question_answer.include? 'incomplete ltbi therapy'
							@@hash_output['tb257_ltbi'] = @@smallx
						end
						if @single_question_answer.include? 'missed contact'
							@@hash_output['tb257_mc'] = @@smallx
						end
						if @single_question_answer.include? 'contact of mdr-tb patient'
							@@hash_output['tb257_mdr'] = @@smallx
						end
						if @single_question_answer.include? 'none'
							@@hash_output['tb257_n'] = @@smallx
						end
						if @single_question_answer.include? 'other, specify'
							@@hash_output['tb257_ot'] = @@smallx
						end
						if @single_question_answer.include? 'post-organ transplantation'
							@@hash_output['tb257_pot'] = @@smallx
						end
						if @single_question_answer.include? 'end-stage renal disease'
							@@hash_output['tb257_rd'] = @@smallx
						end
						if @single_question_answer.include? 'tnf-a antagonist therapy'
							@@hash_output['tb257_tnf'] = @@smallx
						end
					end
					
					if @phin_var == 'tb258' 
						@@hash_output['tb258'] = @single_question_answer
					end
					
					if @phin_var == 'tb259' 
						if @single_question_answer == 'not applicable'
							@@hash_output['tb259_na'] = @@smallx
						elsif @single_question_answer == 'employment visa'
							@@hash_output['tb259_ev'] = @@smallx
						elsif @single_question_answer == 'family/fiance visa'
							@@hash_output['tb259_fv'] = @@smallx
						elsif @single_question_answer == 'immigrant visa'
							@@hash_output['tb254_iv'] = @@smallx
						elsif @single_question_answer == 'other'
							@@hash_output['tb259_ois'] = @@smallx
						elsif @single_question_answer == 'asylee/parolee'
							@@hash_output['tb259_par'] = @@smallx
						elsif @single_question_answer == 'refugee'
							@@hash_output['tb259_ref'] = @@smallx
						elsif @single_question_answer == 'student visa'
							@@hash_output['tb259_sv'] = @@smallx
						elsif @single_question_answer == 'tourist visa'
							@@hash_output['tb259_tv'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb259_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb266' 
						if @single_question_answer == 'yes'
							@@hash_output['tb266_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb266_n'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb266_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb267' 
						@@indvChars = breakUp(@single_question_answer)
						res_tb267 = PdfMapping('tb267')
						populatePdfFields(res_tb267)
						@@boundary = limits(@single_question_answer, @@count)
						populateOutputHash(@@boundary)
						reset
					end
					
					if @phin_var == 'tb269' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb269 = PdfMapping('tb269')
							populatePdfFields(res_tb269)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'tb277' 
						if @single_question_answer == 'no follow-up sputum despite induction'
							@@hash_output['tb277_di'] = @@smallx
						elsif @single_question_answer == 'no follow-up sputum and no induction'
							@@hash_output['tb277_ni'] = @@smallx
						elsif @single_question_answer == 'died'
							@@hash_output['tb277_d'] = @@smallx
						elsif @single_question_answer == 'patient refused'
							@@hash_output['tb277_pr'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb277_u'] = @@smallx
						elsif @single_question_answer == 'patient lost to follow-up'
							@@hash_output['tb277_pl'] = @@smallx
						elsif @single_question_answer == 'other'
							@@hash_output['tb277_ot'] = @@smallx
						elsif @single_question_answer == 'clinically improved'
							@@hash_output['tb277_ot'] = @@smallx
							@@hash_output['tb278'] = @single_question_answer_orig
						end
					end
					
					if @phin_var == 'tb278' 
						@@hash_output['tb278'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb279' 
						if @single_question_answer == 'yes'
							@@hash_output['tb279_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb279_n'] = @@smallx
						end
					end
					
					if @phin_var == 'tb280' 
						if @single_question_answer == 'in state, out-of-jurisdiction'
							@@hash_output['tb280_is'] = @@smallx
						elsif @single_question_answer == 'out of state'
							@@hash_output['tb280_os'] = @@smallx
						elsif @single_question_answer == 'out of the u.s.'
							@@hash_output['tb280_ou'] = @@smallx
						end
					end
					
					if @phin_var == 'tb281' 
						if @single_question_answer == 'yes'
							@@hash_output['tb281_y'] = @@smallx
						elsif @single_question_answer == 'no'
							@@hash_output['tb281_n'] = @@smallx
						end
					end
					
					if @phin_var == 'tb282' 
						@@hash_output['tb282'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb284' 
						@@hash_output['tb284'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb286_1' 
						@@hash_output['tb286_1'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb286_2' 
						@@hash_output['tb286_2'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb288_1' 
						@@hash_output['tb288_1'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb288_2' 
						@@hash_output['tb288_2'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb290' 
						if @single_question_answer == 'related to tb disease'
							@@hash_output['tb290_tbd'] = @@smallx
						elsif @single_question_answer == 'related to tb therapy'
							@@hash_output['tb290_tbt'] = @@smallx
						elsif @single_question_answer == 'unrelated to tb disease'
							@@hash_output['tb290_utbd'] = @@smallx
						elsif @single_question_answer == 'unknown'
							@@hash_output['tb290_u'] = @@smallx
						end
					end
					
					if @phin_var == 'tb291' 
						#Strip carriage returns from answer
						@single_question_answer = @single_question_answer.gsub(/\r?\n/, " ")
						if @single_question_answer.include? 'rifampin resistance'
							@@hash_output['tb291_rr'] = @@smallx
						end
						if @single_question_answer.include? 'adverse drug reaction'
							@@hash_output['tb291_adr'] = @@smallx
						end 
						if @single_question_answer.include? 'non-adherence'
							@@hash_output['tb291_na'] = @@smallx
						end
						if @single_question_answer.include? 'failure'
							@@hash_output['tb291_f'] = @@smallx
						end
						if @single_question_answer.include? 'clinically indicated - other reasons'
							@@hash_output['tb291_ci'] = @@smallx
						end
						if @single_question_answer.include? 'other'
							@@hash_output['tb291_ot'] = @@smallx
						end
					end
					
					if @phin_var == 'tb292' 
						@@hash_output['tb292'] = @single_question_answer_orig
					end
					
					if @phin_var == 'tb293' 
						if @single_question_answer == 'sputum'
							@@hash_output['tb293'] = @@smallx
						end
					end
					
					if @phin_var == 'tb294' 
						if @single_question_answer.length >= 2
							@single_question_answer = @single_question_answer[0,2]
							@@indvChars = breakUp(@single_question_answer)
							res_tb294 = PdfMapping('tb294')
							populatePdfFields(res_tb294)
							@@boundary = limits(@single_question_answer, @@count)
							populateOutputHash(@@boundary)
							reset
						end
					end
					
					if @phin_var == 'pg5_comm_pg6_comm'
						@single_question_answer_orig = @single_question_answer_orig.chomp
						commArray = Array.new
						sentenceArray = Array.new
						tempSentence = ''
						sentence = ''
						@single_question_answer_orig.each_line { |l| commArray.push l.chomp}
						#Remove Empty or Nil Elements
						commArray = commArray - ["", nil]
						commArray.each do |el|
							if el.length > 115
								#standardize to a single space
								el = el.gsub(/\s+/, " ")
								wordArray = Array.new
								#Build array with each word
								wordArray = el.split(" ")
																
								wordArray.each_with_index do |wrd, index|
									tempSentence = tempSentence + wrd + ' '
									if tempSentence.length < 115
										sentence = tempSentence
									else
										sentenceArray.push sentence
										tempSentence = ''
										tempSentence = tempSentence + wrd + ' '
									end
									if tempSentence.length < 115 && index == wordArray.length-1
										sentenceArray.push sentence
									end
								end
							else
								sentenceArray.push el
							end
						end
						
						#Write it to pg5 and pg6 comment fields  						
						@@sqlStr = "SELECT * FROM  tb_phin_pdf_orig where phin_var = 'pg5_comm_pg6_comm' order by pdf_var, var_order"

						rescomm = @@conn.exec(@@sqlStr)
						rescomm.each_with_index do |row, index|
							pdf_comm_var = row['pdf_var']
								if sentenceArray.length > 0
									@@hash_output[pdf_comm_var] = sentenceArray[index]
								end
						end
					end
					
				end	
			 end 
			 
			#Populate Initial Drug Regimen
			 @@sqlStr = "SELECT * FROM  tb_initial_drug_regimen_views where event_id =" + @@event_id + " order by treatment_date"

			@@residr = @@conn.exec(@@sqlStr)
			treat_date_set = false
			treat_date_initial = ''
			@@residr.each do |row|
			  @idr_drug = row['pdf_var']
			  @treat_date = row['treatment_date']
				if @idr_drug != '' && @idr_drug != nil
					@@hash_output[@idr_drug] = @@smallx
				end
				
				if @treat_date != '' && @treat_date != nil && !treat_date_set
					treat_date_set = true
					treat_date_initial = @treat_date
				end
			end
			
			#Populate Initial Drug Regimen Other Drug
			@@sqlStr = "SELECT * FROM  tb_initial_drug_regimen_other_views where event_id =" + @@event_id + " order by treatment_date"

			@@residro = @@conn.exec(@@sqlStr)
			treat_date_set_o = false
			treat_date_initial_o = ''
			idr_setOther = false
			@@residro.each do |row|
			  @idr_drug_o = row['pdf_var']
			  @treat_date_o = row['treatment_date']
			  @drug_name_o = row['drug_name']
				
				if @treat_date_o != '' && @treat_date_o != nil && !treat_date_set_o
					treat_date_set_o = true
					treat_date_initial_o = @treat_date_set_o
				end
				
				if @idr_drug_o != '' && @idr_drug_o != nil
					if @idr_drug_o.include? 'tb146_tb264'
							if !idr_setOther
								@idro_var = 'tb146' + '_' + @idr_drug_o[-1,1]
								@@hash_output[@idro_var] = @@smallx
								@@hash_output['tb263'] = @drug_name_o
								idr_setOther = true
							else
								@@fdrs_var = 'tb264' + '_' + @idr_drug_o[-1,1]
								@@hash_output[@idro_var] = @@smallx
								@@hash_output['tb265'] = @drug_name_o
							end
					end
				end
			end
			
			#Populate tb147
			treat_date_final = ''
			
			if treat_date_initial != '' && treat_date_initial != nil && treat_date_initial_o != '' && treat_date_initial_o != nil
						treat_date_final = compareDates(treat_date_initial, treat_date_initial_o, 'early')
			end
			if (treat_date_initial == '' || treat_date_initial == nil) && (treat_date_initial_o != '' && treat_date_initial_o != nil)
						treat_date_final = treat_date_initial_o
			end
			if (treat_date_initial != '' && treat_date_initial != nil) && (treat_date_initial_o == '' || treat_date_initial_o == nil)
						treat_date_final = treat_date_initial
			end
			if treat_date_final != '' && treat_date_final != nil
				dateString = formatDate(treat_date_final)
				@@indvChars = breakUp(dateString)
				res_tb147 = PdfMapping('tb147')
				populatePdfFields(res_tb147)
				@@boundary = limits(dateString, @@count)
				populateOutputHash(@@boundary)
				reset
			end
						
			#Populate Initial Drug Susceptibility Results
			@@repeat_id = 0
			@@idrs_var = ''
			@@other_drug = ''
			@@tb_drug_test = ''
			@@tb_drug_test_result = ''
			@@setOther = false


			@@sqlStr = "SELECT * FROM  tb_initial_drug_susceptibility_results_views where event_id =" + @@event_id
			@@residrs = @@conn.exec(@@sqlStr)
			@@residrs.each_with_index do |row, index|
			  @idrs_question_short_name = row['question_short_name']
			  @idrs_answer_text = row['answer_text']
			  @idrs_repeat_id = row['repeater_form_object_id']
			  @idrs_pdf_var = row['pdf_var']
				if @idrs_answer_text != '' && @idrs_answer_text != nil
					def evalRecord
						if @@tb_drug_test == 'tb172_tb275'
							if !@@setOther
								@@idrs_var = 'tb172' + '_' + @@tb_drug_test_result
								@@hash_output[@@idrs_var] = @@smallx
								@@hash_output['tb274'] = @@other_drug
								@@setOther = true
							else
								@@idrs_var = 'tb275' + '_' + @@tb_drug_test_result
								@@hash_output[@@idrs_var] = @@smallx
								@@hash_output['tb276'] = @@other_drug
							end
						else
							@@idrs_var = @@tb_drug_test + '_' + @@tb_drug_test_result
							@@hash_output[@@idrs_var] = @@smallx
						end
					end
					if index > 0 && (@@repeat_id != @idrs_repeat_id)
							evalRecord
					end
					
					if @idrs_pdf_var != '' && @idrs_pdf_var != nil
						@@repeat_id = @idrs_repeat_id
					end
							
					if @idrs_question_short_name == 'other_drug_name_init'
						@@other_drug = @idrs_answer_text
					end
					
					if @idrs_question_short_name.downcase == 'tb_drug_test_init'
						@@tb_drug_test = @idrs_pdf_var
					end
					
					if @idrs_question_short_name.downcase == 'tb_drug_test_result_init'
						@@tb_drug_test_result = @idrs_pdf_var
					end
					
					if index == @@residrs.num_tuples - 1
						evalRecord
					end
				end
			end

			reset

			#Populate Final Drug Susceptibility Results
			@@sqlStr = "SELECT * FROM  tb_final_drug_susceptibility_results_views where event_id =" + @@event_id
			@@resfdrs = @@conn.exec(@@sqlStr)
			@@resfdrs.each_with_index do |row, index|
			  @fdrs_question_short_name = row['question_short_name']
			  @fdrs_answer_text = row['answer_text']
			  @fdrs_repeat_id = row['repeater_form_object_id']
			  @fdrs_pdf_var = row['pdf_var']
				if @fdrs_answer_text != '' && @fdrs_answer_text != nil
					def evalRecord
						if @@tb_drug_test == 'tb198_tb300'
							if !@@setOther
								@@fdrs_var = 'tb198' + '_' + @@tb_drug_test_result
								@@hash_output[@@fdrs_var] = @@smallx
								@@hash_output['tb299'] = @@other_drug
								@@setOther = true
							else
								@@fdrs_var = 'tb300' + '_' + @@tb_drug_test_result
								@@hash_output[@@fdrs_var] = @@smallx
								@@hash_output['tb301'] = @@other_drug
							end
						else
							@@fdrs_var = @@tb_drug_test + '_' + @@tb_drug_test_result
							@@hash_output[@@fdrs_var] = @@smallx
						end
					end
					if index > 0 && (@@repeat_id != @fdrs_repeat_id)
							evalRecord
					end
					
					if @fdrs_pdf_var != '' && @fdrs_pdf_var != nil
						@@repeat_id = @fdrs_repeat_id
					end
							
					if @fdrs_question_short_name == 'other_drug_name_final'
						@@other_drug = @fdrs_answer_text
					end
					
					if @fdrs_question_short_name.downcase == 'tb_drug_test_final'
						@@tb_drug_test = @fdrs_pdf_var
					end
					
					if @fdrs_question_short_name.downcase == 'tb_drug_test_result_final'
						@@tb_drug_test_result = @fdrs_pdf_var
					end
					
					if index == @@resfdrs.num_tuples - 1
						evalRecord
					end
				end
			end


			#Populate Tuberculin Skin Test at Diagnosis
			@@sqlStr = "SELECT * FROM tb_qa_views where question_short_name IN ('DIAG_TST_PLACED_DATE') and event_id = " + @@event_id + " order by repeater_form_object_id, 
			question_short_name, answer_text"
			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
				@diag_test_placed_date = row['answer_text']
					if @diag_test_placed_date != '' && @diag_test_placed_date != nil
						@@lateDate = compareDates(@@lateDate, @diag_test_placed_date, 'late')
					end

			end

			@@targetDate = @@lateDate
			@@repeatID = repeatID(@@targetDate, @@event_id, 'diag_tst_placed_date')
			reset

			if @@repeatID != '' && @@repeatID != nil && @@repeatID.to_i > 0
				@@sqlStr = "SELECT *, CASE
										WHEN question_short_name = 'DIAG_TST_PLACED_DATE' THEN 'tb248'
										WHEN question_short_name = 'DIAG_TST_TEST' THEN 'tb119'
										WHEN question_short_name = 'DIAG_TST_INDURATION' THEN 'tb120'
										END AS phin_var 
										FROM tb_qa_views where question_short_name IN ('DIAG_TST_TEST', 'DIAG_TST_PLACED_DATE', 'DIAG_TST_INDURATION') and event_id = " + @@event_id + 
										" and repeater_form_object_id = " + @@repeatID + " order by repeater_form_object_id, question_short_name, answer_text"
				@@resrpt = @@conn.exec(@@sqlStr)
				@@resrpt.each do |row|
					@single_question_answer_r_orig = row['answer_text']
					@single_question_answer_r = row['answer_text'].downcase
					@phin_var_r = row['phin_var']
						if @single_question_answer_r != '' && @single_question_answer_r != nil
							if @phin_var_r == 'tb120' 
								if @single_question_answer_r.length >= 2
									@single_question_answer_r = @single_question_answer_r[0,2]
									@@indvChars = breakUp(@single_question_answer_r)
									res_tb120 = PdfMapping('tb120')
									populatePdfFields(res_tb120)
									@@boundary = limits(@single_question_answer_r, @@count)
									populateOutputHash(@@boundary)
									reset
								end
							end
							
							if @phin_var_r == 'tb248'
								dateString = formatDate(@single_question_answer_r)
								@@indvChars = breakUp(dateString)
								res_tb248 = PdfMapping('tb248')
								populatePdfFields(res_tb248)
								@@boundary = limits(dateString, @@count)
								populateOutputHash(@@boundary)
								reset
							end	
							
							if @phin_var_r == 'tb119' 
								if @single_question_answer_r == 'positive'
									@@hash_output['tb119_p'] = @@smallx
								elsif @single_question_answer_r == 'negative'
									@@hash_output['tb119_n'] = @@smallx
								elsif @single_question_answer_r == 'not done'
									@@hash_output['tb119_nd'] = @@smallx
								elsif @single_question_answer_r == 'unknown'
									@@hash_output['tb119_u'] = @@smallx
								end
							end
						
						end

				end

			end
			resetRpt


			#Populate Initial Chest Radiograph 
			@@sqlStr = "SELECT * FROM tb_qa_views where question_short_name IN ('CHEST_RADIOGRAPH_DATE') and event_id = " + @@event_id + " order by repeater_form_object_id, 
			question_short_name, answer_text"
			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
				@chest_radiograph_date = row['answer_text']
					if @chest_radiograph_date != '' && @chest_radiograph_date != nil
						@@lateDate = compareDates(@@lateDate, @chest_radiograph_date, 'late')
					end
			end


			@@targetDate = @@lateDate
			@@repeatID = repeatID(@@targetDate, @@event_id, 'chest_radiograph_date')
			reset

			if @@repeatID != '' && @@repeatID != nil && @@repeatID.to_i > 0
			@@sqlStr = "SELECT *, CASE
									WHEN question_short_name = 'CHEST_RADIOGRAPH_RESULT' THEN 'tb116'
									WHEN question_short_name = 'DIAG_CXR_CAVITY' THEN 'tb243'
									WHEN question_short_name = 'DIAG_CXR_MILIARY' THEN 'tb244'
									END AS phin_var 
									FROM tb_qa_views where question_short_name IN ('CHEST_RADIOGRAPH_DATE', 'CHEST_RADIOGRAPH_RESULT', 'DIAG_CXR_CAVITY', 'DIAG_CXR_MILIARY') and event_id = " + @@event_id + 
									" and repeater_form_object_id = " + @@repeatID + " order by repeater_form_object_id, question_short_name, answer_text"
			@@resrpt = @@conn.exec(@@sqlStr)
			@@resrpt.each do |row|
				@single_question_answer_r_orig = row['answer_text']
				@single_question_answer_r = row['answer_text'].downcase
				@phin_var_r = row['phin_var']
					if @single_question_answer_r != '' && @single_question_answer_r != nil
						if @phin_var_r == 'tb116' 
							if @single_question_answer_r == 'normal'
								@@hash_output['tb116_n'] = @@smallx
							elsif @single_question_answer_r == 'abnormal cxr (consistent with tb)'
								@@hash_output['tb116_a'] = @@smallx
							elsif @single_question_answer_r == 'not done'
								@@hash_output['tb116_nd'] = @@smallx
							elsif @single_question_answer_r == 'unknown'
								@@hash_output['tb116_u'] = @@smallx
							end
						end
						
						if @phin_var_r == 'tb243' 
							if @single_question_answer_r == 'yes'
								@@hash_output['tb243_y'] = @@smallx
							elsif @single_question_answer_r == 'no'
								@@hash_output['tb243_n'] = @@smallx
							elsif @single_question_answer_r == 'unknown'
								@@hash_output['tb243_u'] = @@smallx
							end
						end
						
						if @phin_var_r == 'tb244' 
							if @single_question_answer_r == 'yes'
								@@hash_output['tb244_y'] = @@smallx
							elsif @single_question_answer_r == 'no'
								@@hash_output['tb244_n'] = @@smallx
							elsif @single_question_answer_r == 'unknown'
								@@hash_output['tb244_u'] = @@smallx
							end
						end
					
					end

			end

			end

			resetRpt

			#Populate Other Chest Imaging Study
			@@sqlStr = "SELECT * FROM tb_qa_views where question_short_name IN ('CHEST_CT_IMAGING_DATE') and event_id = " + @@event_id + " order by repeater_form_object_id, 
			question_short_name, answer_text"
			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
				@chest_ct_imaging_date = row['answer_text']
					if @chest_ct_imaging_date != '' && @chest_ct_imaging_date != nil
						@@lateDate = compareDates(@@lateDate, @chest_ct_imaging_date, 'late')
					end
			end

			@@targetDate = @@lateDate
			@@repeatID = repeatID(@@targetDate, @@event_id, 'chest_ct_imaging_date')
			reset

			if @@repeatID != '' && @@repeatID != nil && @@repeatID.to_i > 0
				@@sqlStr = "SELECT *, CASE
										WHEN question_short_name = 'CHEST_CT_IMAGING_RESULT' THEN 'tb245'
										WHEN question_short_name = 'DIAG_CT_IMAGING_CAVITY' THEN 'tb246'
										WHEN question_short_name = 'DIAG_CT_IMAGING_MILIARY' THEN 'tb247'
										END AS phin_var 
										FROM tb_qa_views where question_short_name IN ('CHEST_CT_IMAGING_DATE', 'CHEST_CT_IMAGING_RESULT', 'DIAG_CT_IMAGING_CAVITY', 'DIAG_CT_IMAGING_MILIARY') and event_id = " + @@event_id + 
										" and repeater_form_object_id = " + @@repeatID + " order by repeater_form_object_id, question_short_name, answer_text"
				@@resrpt = @@conn.exec(@@sqlStr)
				@@resrpt.each do |row|
					@single_question_answer_r_orig = row['answer_text']
					@single_question_answer_r = row['answer_text'].downcase
					@phin_var_r = row['phin_var']
						if @single_question_answer_r != '' && @single_question_answer_r != nil
							if @phin_var_r == 'tb245' 
								if @single_question_answer_r == 'normal'
									@@hash_output['tb245_n'] = @@smallx
								elsif @single_question_answer_r == 'abnormal cxr (consistent with tb)'
									@@hash_output['tb245_a'] = @@smallx
								elsif @single_question_answer_r == 'not done'
									@@hash_output['tb245_nd'] = @@smallx
								elsif @single_question_answer_r == 'unknown'
									@@hash_output['tb245_u'] = @@smallx
								end
							end
							
							if @phin_var_r == 'tb246' 
								if @single_question_answer_r == 'yes'
									@@hash_output['tb246_y'] = @@smallx
								elsif @single_question_answer_r == 'no'
									@@hash_output['tb246_n'] = @@smallx
								elsif @single_question_answer_r == 'unknown'
									@@hash_output['tb246_u'] = @@smallx
								end
							end
							
							if @phin_var_r == 'tb247' 
								if @single_question_answer_r == 'yes'
									@@hash_output['tb247_y'] = @@smallx
								elsif @single_question_answer_r == 'no'
									@@hash_output['tb247_n'] = @@smallx
								elsif @single_question_answer_r == 'unknown'
									@@hash_output['tb247_u'] = @@smallx
								end
							end
						
						end

				end

			end

			resetRpt

			#Populate Interferon Gamma Release Assay for Mycobacterium tuberculosis at Diagnosis
			@@sqlStr = "SELECT * FROM tb_qa_views where question_short_name IN ('DIAG_IGRA_COLLECT_DATE') and event_id = " + @@event_id + " order by repeater_form_object_id, 
			question_short_name, answer_text"
			@@res = @@conn.exec(@@sqlStr)
			@@res.each do |row|
				@diag_igra_collect_date = row['answer_text']
					if @diag_igra_collect_date != '' && @diag_igra_collect_date != nil
						@@lateDate = compareDates(@@lateDate, @diag_igra_collect_date, 'late')
					end
			end

			@@targetDate = @@lateDate
			@@repeatID = repeatID(@@targetDate, @@event_id, 'diag_igra_collect_date')
			reset

			if @@repeatID != '' && @@repeatID != nil && @@repeatID.to_i > 0
				@@sqlStr = "SELECT *, CASE
										WHEN question_short_name = 'DIAG_IGRA_RESULT' THEN 'tb250'
										WHEN question_short_name = 'DIAG_IGRA_COLLECT_DATE' THEN 'tb251'
										WHEN question_short_name = 'DIAG_IGRA_TEST_TYPE' THEN 'tb253'
										END AS phin_var
										FROM tb_qa_views where question_short_name IN ('DIAG_IGRA_COLLECT_DATE', 'DIAG_IGRA_RESULT', 'DIAG_IGRA_TEST_TYPE') and event_id = " + @@event_id + 
										" and repeater_form_object_id = " + @@repeatID + " order by repeater_form_object_id, question_short_name, answer_text"
				@@resrpt = @@conn.exec(@@sqlStr)
				@@resrpt.each do |row|
					@single_question_answer_r_orig = row['answer_text']
					@single_question_answer_r = row['answer_text'].downcase
					@phin_var_r = row['phin_var']
						if @single_question_answer_r != '' && @single_question_answer_r != nil
							if @phin_var_r == 'tb250' 
								if @single_question_answer_r == 'positive'
									@@hash_output['tb250_p'] = @@smallx
								elsif @single_question_answer_r == 'negative'
									@@hash_output['tb250_n'] = @@smallx
								elsif @single_question_answer_r == 'not done'
									@@hash_output['tb250_nd'] = @@smallx
								elsif @single_question_answer_r == 'indeterminate'
									@@hash_output['tb250_i'] = @@smallx
								elsif @single_question_answer_r == 'unknown'
									@@hash_output['tb250_u'] = @@smallx
								end
							end
							
							if @phin_var_r == 'tb251'
								dateString = formatDate(@single_question_answer_r)
								@@indvChars = breakUp(dateString)
								res_tb251 = PdfMapping('tb251')
								populatePdfFields(res_tb251)
								@@boundary = limits(dateString, @@count)
								populateOutputHash(@@boundary)
								reset
							end	
							
							if @phin_var_r == 'tb253' 
							@@hash_output['tb253'] = @single_question_answer_r_orig
						end
						
						end

				end

			end
			
			reset
			resetRpt
			@@conn.close

			if @@hash_output.size > 0
				fdf = PdfForms::Fdf.new @@hash_output
				fdf_filename = pdf_path + 'rvct_' + @@event_id + '.fdf'
				fdf.save_to fdf_filename
				pdf_filename = pdf_path + 'rvct_' + @@event_id + '.pdf'
				
				system (pdftk_path + ' ' + template + ' fill_form ' + fdf_filename + ' output ' + pdf_filename + ' dont_ask')
			end

			send_file(pdf_filename, :filename => pdf_filename, :type => "application/pdf")
	
		end
	end
		
end
	