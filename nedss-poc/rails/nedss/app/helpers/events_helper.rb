module EventsHelper
  def render_core_data_element(element)
    question = element.question
    field_name = question.core_data_attr
    model_name = "@" + field_name.gsub("[", ".").gsub("]", "")
    id = field_name.chop.gsub(/[\[\]]/, "_") 
    data_type = Event.exposed_attributes[field_name][:type]
    value = eval model_name

    input_element = case data_type
    when :single_line_text
      text_field_tag(field_name, value, :id => id)
    when :text_area
      text_area_tag(field_name, value, :id => id)
    when :date
      calendar_date_select_tag(field_name, value, :id => id)
    end

    content_tag(:label) do
      question.question_text + " " + input_element
    end
    
  end
  
  def render_investigator_view(view, f)
    result = ""
    element_levels = {}
    
    view.full_set.each do |element|
      
      result += close_containers(element_levels, element)
      
      case element.class.name
        
      when "SectionElement"
        result += open_section(element)
      when "FollowUpElement"
        result += open_follow_up(element)
      when "QuestionElement"
        if element.question.core_data
          result += render_core_data_element(element)
        else
          @answer_object = @event.get_or_initialize_answer(element.question.id)
          result += f.fields_for(:answers, @answer_object, :builder => ExtendedFormBuilder) do |answer_template|
            answer_template.dynamic_question(element, @form_index += 1)
          end
        end
      end
      
    end
    
    result += close_containers(element_levels)
    
    result
  end
  
  private
  
  def close_containers(element_levels, element = nil)
    result = ""
    to_close = {}
    
    if (element)
      element_levels.each { |key, value|  to_close[key] = value if (key >= element.level && 
            (value.is_a?(SectionElement) || value.is_a?(FollowUpElement)))  }
      element_levels[element.level] = element
      element_levels.delete_if {|key, value| key > element.level}
    else
      to_close = element_levels
    end
    
    to_close.sort.reverse_each {|element_to_close| result += close_container(element_to_close[1])}
    
    result
  end
  
  def close_container(element)
    result = ""
    
    case element.class.name
      
    when "SectionElement"
      result += close_section
    when "FollowUpElement"
      result += close_follow_up
    end
    
    result
  end
  
  def open_section(element)
    result = "<br/>"
    section_id = "section_investigate_#{element.id}";
    hide_id = section_id + "_hide";
    show_id = section_id + "_show"
    result +=  "<fieldset class='form_section'>"
    result += "<legend>#{element.name} "
    result += "<span id='#{hide_id}' onClick=\"Element.hide('#{section_id}'); Element.hide('#{hide_id}'); Element.show('#{show_id}'); return false;\">[Hide]</span>"
    result += "<span id='#{show_id}' onClick=\"Element.show('#{section_id}'); Element.hide('#{show_id }'); Element.show('#{hide_id}'); return false;\" style='display: none;'>[Show]</span>"
    result += "</legend>"
    result += "<div id='#{section_id}'>"
    result
  end
  
  def close_section
    "</div></fieldset><br/>"
  end
  
  def open_follow_up(element)
    # Debt? May be some way to get this without having to do another query
    answer = Answer.find_by_event_id_and_question_id(@event.id, element.parent.question.id)
    if (answer.nil? || answer.text_answer != element.condition)
      display = "none"
    else
      display = "inline"
    end
    
   "<div style='display: #{display};' id='follow_up_investigate_#{element.id}'>"
  end
  
  def close_follow_up
    "</div>"
  end
  
end
