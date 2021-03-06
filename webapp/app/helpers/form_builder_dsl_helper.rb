# Copyright (C) 2007, 2008, 2009, 2010, 2011, 2012, 2013 The Collaborative Software Foundation
#
# This file is part of TriSano.
#
# TriSano is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the
# Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# TriSano is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

module FormBuilderDslHelper

  def concat_core_field(mode, before_or_after, attribute, form_builder)
    return if  (@event.nil? || @event.form_references.nil?)
    @event.form_references.each do |form_reference|

      # What we are doing here is looking for ALL forms that have been attached to this event
      # while this event may have been a contact event, assessment event and so on.
      # We build the output based on the correct event type for the form, then change
      # the path to represent the current event type
      current_core_path = (form_builder.core_path << attribute).to_s #valid core path
      alternate_forms_core_path_prefix = form_builder.core_path.clone
      alternate_forms_core_path_prefix[0] = form_reference.form.event_type
      alternate_forms_core_path = (alternate_forms_core_path_prefix << attribute).to_s
      output = core_customization(form_reference, alternate_forms_core_path, @event_form, before_or_after, mode, form_builder)
      if output.present?
        # before we render this output, update the path to be usable on current form
        output.gsub!(alternate_forms_core_path, current_core_path)
        concat(output)
      end 
    end #form referneces
  end

  def core_customization(form_reference, core_path, current_form, before_or_after, mode, local_form_builder)
    customizations = form_reference.form.form_element_cache.all_cached_field_configs_by_core_path(core_path)

    customization = ""

    customizations.each do |config|
      element = before_or_after == :before ? element = form_reference.form.form_element_cache.children(config).first : form_reference.form.form_element_cache.children(config)[1]

      customization << case mode
      when :edit
        render_investigator_view(element, current_form, form_reference.form, local_form_builder)
      when :show
        show_investigator_view(element, form_reference.form, current_form, local_form_builder)
      when :print
        print_investigator_view(element, form_reference.form, current_form, local_form_builder)
      end
    end #configs

    return customization
  end

  def render_investigator_element(form_elements_cache, element, f, local_form_builder=nil)
    result = ""

    case element.class.name

    when "SectionElement"
      result << render_investigator_section(form_elements_cache, element, f)
    when "GroupElement"
      result << render_investigator_group(form_elements_cache, element, f)
    when "QuestionElement"
      result << render_investigator_question(form_elements_cache, element, f, local_form_builder)
    when "FollowUpElement"
      result << render_investigator_follow_up(form_elements_cache, element, f)
    end

    result
  end

  # Show mode counterpart to #render_investigator_element
  def show_investigator_element(form_elements_cache, element, f, local_form_builder=nil)
    result = ""

    case element.class.name

    when "SectionElement"
      result << show_investigator_section(form_elements_cache, element, f)
    when "GroupElement"
      result << show_investigator_group(form_elements_cache, element, f)
    when "QuestionElement"
      result << show_investigator_question(form_elements_cache, element, f, local_form_builder)
    when "FollowUpElement"
      result << show_investigator_follow_up(form_elements_cache, element, f)
    end

    result
  end

  # Print mode counterpart to #render_investigator_element and #show_investigator_element
  def print_investigator_element(form_elements_cache, element, f, local_form_builder=nil)
    result = ""
    case element.class.name

    when "SectionElement"
      result << print_investigator_section(form_elements_cache, element, f)
    when "GroupElement"
      result << print_investigator_group(form_elements_cache, element, f)
    when "QuestionElement"
      result << print_investigator_question(form_elements_cache, element, f, local_form_builder)
    when "FollowUpElement"
      result << print_investigator_follow_up(form_elements_cache, element, f)
    end

    result
  end

  def investigator_section(partial, form_elements_cache, section_element, f, investigator_form=nil)
    render(:partial => partial, :locals => {:form_elements_cache => form_elements_cache,
                                            :section => section_element,
                                            :f => f,
                                            :investigator_form => investigator_form})
  end

  def render_investigator_section(form_elements_cache, section_element, f)
    begin
      partial = "events/investigate_section_element.html.haml" 
      result = render(:partial => "events/investigate_section_element_header.html.haml",
                      :locals => { :section => section_element } )


      if section_element.repeater?

        current_section_ids = f.object.investigator_form_sections.map(&:section_element_id)
        # If investigator form section exists, build one so user is shown a blank form entry
        # it will be discarded if left empty by :reject_if => :nested_attributes_blank?
        unless current_section_ids.include?(section_element.id)
          f.object.investigator_form_sections.build(:section_element_id => section_element.id)
        end

        # TODO: This fields_for loop is inefficient. We shouldn't loop through each form section, hunting
        # for the right one. Not sure how to better design this though.
        f.fields_for(:investigator_form_sections, :builder => ExtendedFormBuilder) do |investigator_form|
          if investigator_form.object.section_element_id == section_element.id
            result << investigator_section(partial, form_elements_cache, section_element, f, investigator_form)
          end
        end

        result << content_tag(:div, nil, :id => "repeater_section_investigate_#{h(section_element.id)}")

        f.fields_for(:investigator_form_sections,
                     InvestigatorFormSection.new(:event_id => f.object.id, 
                                                 :section_element_id => section_element.id), 
                     :child_index => "NEW_RECORD",
                     :builder => ExtendedFormBuilder) do |new_investigator_form|

          result << content_tag(:p, :style => 'clear:both') do
                             add_record_link(f, :answers, "Add another #{section_element.name} section", 
                                          {:partial => partial, 
                                           :locals => {:form_elements_cache => form_elements_cache, 
                                                       :section => section_element,
                                                       :f => f,
                                                       :investigator_form => new_investigator_form}, 
                                           :insert => "repeater_section_investigate_#{h(section_element.id)}", 
                                           :object => section_element})
          end
        end

      else
        result << investigator_section(partial, form_elements_cache, section_element, f)
      end

      result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:section_element), :id => section_element.id)
    end
  end

  def render_investigator_group(form_elements_cache, element, f)
    begin
      result = ""

      group_children = form_elements_cache.children(element)

      if group_children.size > 0
        group_children.each do |child|
          result << render_investigator_element(form_elements_cache, child, f)
        end
      end

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:group_element), :id => element.id)
    end
  end

  def rendering_core_field(attribute, form_builder)
    cf = form_builder.core_field(attribute)
    if cf.rendered_on_event?(@event)
      concat_before_core_partials(cf.key, form_builder)
      yield(cf)
      concat_after_core_partials(cf.key, form_builder)
    end
  end

  def concat_before_core_partials(key, form_builder)
    before_core_partials[key].each do |before_partial|
      locals = before_partial[:locals] || {}
      before_partial[:locals] = {:f => form_builder}.merge(locals)
      concat(render(before_partial))
    end
  end

  def concat_after_core_partials(key, form_builder)
    after_core_partials[key].each do |after_partial|
      locals = after_partial[:locals] || {}
      after_partial[:locals] = { :f => form_builder }.merge(locals)
      concat(render(after_partial))
    end
  end

  def concat_block_or_replacement(core_field, form_builder, &block)
    replacement = core_replacement_partial[core_field.key]
    if replacement && core_field.replaced?(@event)
      locals = replacement[:locals] || {}
      replacement[:locals] = { :f => form_builder }.merge(locals)
      concat(render(replacement))
    else
      block.call
    end
  end

  def core_section(attribute, form_builder, css_class='form', &block)
    rendering_core_field(attribute, form_builder) do |cf|
      concat("<fieldset class='#{css_class}'>")
      concat("<legend>#{cf.name}</legend>")
      concat_block_or_replacement(cf, form_builder, &block)
      concat("</fieldset>")
    end
  end

  def core_tab(attribute, form_builder, &block)
    rendering_core_field(attribute, form_builder) do |cf|
      concat "<div id=\"#{attribute.to_s}\" class=\"tab\">"
      concat_block_or_replacement cf, form_builder, &block
      concat "<br clear=\"all\"/>"
      concat link_to_top
      concat "</div>"
    end
  end

  def core_element(attribute, form_builder, css_class, mode=:edit, &block)
    rendering_core_field(attribute, form_builder) do |cf|
      concat_core_field(mode, :before, attribute, form_builder)
      concat("<span class='#{css_class}'>")
      concat_block_or_replacement(cf, form_builder, &block)
      concat(render_core_field_help_text(attribute, form_builder, @event))
      concat("&nbsp;</span>")
      concat_core_field(mode, :after, attribute, form_builder)
    end
  end

  def core_element_show(attribute, form_builder, css_class, &block)
    core_element(attribute, form_builder, css_class, :show, &block)
  end

  def core_element_print(attribute, form_builder, css_class, &block)
    core_element(attribute, form_builder, css_class, :print, &block)
  end

  def investigator_view(mode, view, form, f, local_form_builder=nil)
    return "" if view.nil?
    result = ""
    # To simplify the calls create a method reference which we can invoke below
    # example modes include :render_investigator_element, :show_investigator_element, :print_investigator_element 
    method_ref = method(mode + "_investigator_element")

    form_elements_cache = form.nil? ? FormElementCache.new(view) : form.form_element_cache

    form_elements_cache.children(view).each do |element|
      if !element.core_path.nil? && form.event_type != @event.type.underscore
        historical_element = element.dup #must use dup instead of clone to get element.id
        historical_element.core_path.sub!(form.event_type, @event.type.underscore)
        result << method_ref.call(form_elements_cache, historical_element, f, local_form_builder)
      else
        result << method_ref.call(form_elements_cache, element, f, local_form_builder)
      end
    end #form_elements_cache.children

    result
  end

  def render_investigator_view(view, f, form=nil, local_form_builder=nil)
    investigator_view("render", view, form, f, local_form_builder)
  end

  def show_investigator_view(view, form=nil, f = nil, local_form_builder=nil)
    investigator_view("show", view, form, f, local_form_builder)
  end

  def print_investigator_view(view, form=nil, f = nil, local_form_builder=nil)
    investigator_view("print", view, form, f, local_form_builder)
  end

  def render_help_text(element)
    if element.is_a?(QuestionElement)
      return "" if element.question.nil?
      help_text = element.question.help_text
    else
      return "" if element.nil? || element.help_text.blank?
      help_text = element.help_text
    end

    identifier = element.class.name.underscore[0..element.class.name.underscore.index("_")-1]

    result = tooltip("#{identifier}_help_text_#{element.id}") do
      image_tag('help.png', :border => 0)
    end
    result << "<span id='#{h(identifier)}_help_text_#{h(element.id)}' style='display: none;'>#{simple_format(help_text)}</span>"
  end

  def render_core_field_help_text(attribute, form_builder, event)
    return "" unless event
    core_field = form_builder.core_field(attribute)
    core_field ? render_help_text(core_field) : ""
  end

  def collect_answer_object(question, form_builder)


    answer_attributes = {:question_id => question.id, 
                         :event_id => @event.id}

    return @event.get_or_initialize_answer(answer_attributes) if form_builder.nil?



    # Must define local var outside of loop below.
    # Cannot use instance var; persists and returns wrong values later
    local_answer_object = nil

    answerable = form_builder.object && form_builder.object.respond_to?(:answers)
    if answerable
      if form_builder.respond_to?(:repeater_form?) and form_builder.repeater_form?
        # This is critical to use #base_class here because polymorphic with STI
        # requires use of base class!
        # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
        # see "Polymorphic Associations"
        answer_attributes[:repeater_form_object_type] = form_builder.object.class.base_class.name

        # This must be nil for new records so we get blank templates
        answer_attributes[:repeater_form_object_id] = form_builder.object.id

        form_builder.object.answers.each do |answer|
          local_answer_object = answer if answer.question_id          == answer_attributes[:question_id] and
                                          answer.event_id             == answer_attributes[:event_id] and
                                          answer.repeater_form_object == form_builder.object
        end


      else
        #Not repeater, but answerable

        form_builder.object.answers.each do |answer|
          local_answer_object = answer if answer.question_id == answer_attributes[:question_id] and
                                          answer.event_id    == answer_attributes[:event_id]
        end
      end
    end


    local_answer_object || @event.get_or_initialize_answer(answer_attributes)
  end

  def render_investigator_question(form_elements_cache, element, f, local_form_builder=nil)
    question_element = element
    question = question_element.question
    question_style = question.style.blank? ? "vert" : question.style
    result = "<div id='question_investigate_#{h(question_element.id)}' class='#{h(question_style)}'>"

    if !local_form_builder.nil? && local_form_builder.repeater_form?
      answer_object = collect_answer_object(question, local_form_builder)
      inner_prefix = answer_object.new_record? ? "new_repeater_answers" : "repeater_answers"
      outer_prefix = local_form_builder.object_name
    else
      answer_object = collect_answer_object(question, f)
      inner_prefix = answer_object.new_record? ? "new_answers" : "answers"
      outer_prefix = @event
    end

    if answer_object.new_record?
      index = ""
    else
      # This worked fine when the index was always based off the @event,
      # now that we have all sorts of elements which can have answers
      # will this global index counter still work properly?

      # Probably, as the point is just to increment
      # Moreover, the dyanmic quesiton method checks if @object has an id and uses it
      # Pretty repeatative, needs big refactoring
      @form_index = 0 unless @form_index
      index = @form_index += 1
    end
    
    fields_for(outer_prefix) do |f|
      f.fields_for(inner_prefix, answer_object, :builder => ExtendedFormBuilder) do |answer_template|
        result << answer_template_dynamic_question(answer_template, form_elements_cache, question_element, index, question)
      end
    end

    follow_up_group = question_element.process_condition(answer_object,
      @event.id,
      :form_elements_cache => form_elements_cache)

    unless follow_up_group.empty?
      result << "<div id='follow_up_investigate_#{h(question_element.id)}'>"
      follow_up_group.each do |follow_up|
        result << render_investigator_follow_up(form_elements_cache, follow_up, f)
      end
      result << "</div>"
    else
      result << "<div id='follow_up_investigate_#{h(question_element.id)}'></div>"
    end

    result << "</div>"

    return result
    #rescue
    #logger.warn("Formbuilder rendering: #{$!.message}")
    #return "Could not render question element (#{element.id})"
  end

  def answer_template_dynamic_question(answer_template, form_elements_cache, element, index, question)
    result = ""
    # We must start included answer_id because now questions can be repeated
    # causing duplicate IDs in the DOM.
    # However, there can only be one answer for a question or it's a new answer.
    answer_id = answer_template.object.id || "new_answer"
    result << answer_template.dynamic_question(form_elements_cache, element, @event, index, {:id => "investigator_answer_#{h(element.id)}_#{answer_id}"})
    result << render_help_text(element) unless question.help_text.blank?
    result
  end

  def render_investigator_follow_up(form_elements_cache, element, f)
    begin
      result = ""

      unless element.core_path.blank?
        result << render_investigator_core_follow_up(form_elements_cache, element, f)
        return result
      end

      questions = form_elements_cache.children(element)

      if questions.size > 0
        questions.each do |child|
          result << render_investigator_element(form_elements_cache, child, f)
        end
      end

      return result
    rescue
      logger.warn($!.message)
      logger.error $!.backtrace.join("\n")
      return t(:could_not_render, :thing => t(:follow_up_element), :id => element.id)
    end
  end

  def eval_core_path(options)

    object = options[:object]
    core_path = options[:core_path]
    core_path_array = options[:core_path_array] || ExtendedFormBuilder::CorePath[core_path]

    core_path_array.shift #remove event type from core_path

    core_value = object
    core_path_array.each do |method|
      if core_value.is_a?(Array)
        core_value = core_value.collect { |cf| cf.try(:send, method) } 
        core_value.delete_if { |value| value.nil? }
      else
        core_value = core_value.try(:send, method)
      end
    end
    
    core_value

  end

  def render_investigator_core_follow_up(form_elements_cache, element, f, ajax_render=false)
    begin
      result = ""
      include_children = false

      unless (ajax_render)
        core_value = eval_core_path(:object => @event, :core_path => element.core_path)
        include_children = true if element.condition_match?(core_value.to_s)
      end

      result << "<div id='follow_up_investigate_#{element.id}'>" unless ajax_render

      if (include_children || ajax_render)
        questions = form_elements_cache.children(element)
        if questions.size > 0
          questions.each do |child|
            result << render_investigator_element(form_elements_cache, child, f)
          end
        end
      end

      result << "</div>" unless ajax_render

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:core_follow_up_element), :id => element.id)
    end
  end

  # Show mode counterpart to #render_investigator_section
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def  show_investigator_section(form_elements_cache, section_element, f)
    begin
      partial = "events/investigate_section_element_show.html.haml" 
      result = render(:partial => "events/investigate_section_element_header.html.haml", :locals => {:section => section_element})
      
      if section_element.repeater?
        if f.object.investigator_form_sections.map(&:section_element_id).include?(section_element.id)
          f.fields_for(:investigator_form_sections, :builder => ExtendedFormBuilder) do |investigator_form|
            if (investigator_form.object.section_element_id == section_element.id) || investigator_form.object.new_record?
              result << investigator_section(partial, form_elements_cache, section_element, f, investigator_form)
            end
          end

        else
          result << "No #{section_element.name} have been recorded for this #{f.object.class.name.underscore.humanize.downcase}"
        end

      else
        result << investigator_section(partial, form_elements_cache, section_element, f)
      end
      result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:section_element), :id => section_element.id)
    end
  end

  # Show mode counterpart to #render_investigator_group
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def show_investigator_group(form_elements_cache, element, f)
    begin
      result = ""

      group_children = form_elements_cache.children(element)

      if group_children.size > 0
        group_children.each do |child|
          result << show_investigator_element(form_elements_cache, child, f)
        end
      end

      return result
   rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:group_element), :id => element.id)
    end
  end

  # Show mode counterpart to #render_investigator_question
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def show_investigator_question(form_elements_cache, element, f, local_form_builder=nil)
    begin
      question = element.question
      question_style = question.style.blank? ? "vert" : question.style
      result = "<div id='question_investigate_#{element.id}' class='#{question_style}'>"
      result << "<label>#{question.question_text}&nbsp;"
      result << render_help_text(element) unless question.help_text.blank?
      result << "</label>"
      answer = collect_answer_object(question, local_form_builder)
      result << answer.text_answer.to_s unless answer.nil?
      result << "</div>"

      unless answer.nil?
        follow_up_group = element.process_condition(
          {:response => answer.text_answer},
          @event.id,
          :form_elements_cache => form_elements_cache
        )

        unless follow_up_group.empty?
          result << "<div id='follow_up_investigate_#{element.id}'>"
          follow_up_group.each do |follow_up|
            result << show_investigator_follow_up(form_elements_cache, follow_up, f)
          end
          result << "</div>"
        end
      end

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:group_element), :id => element.id)
    end
  end

  # Show mode counterpart to #render_investigator_follow_up
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def show_investigator_follow_up(form_elements_cache, element, f)
    begin
      result = ""

      unless element.core_path.blank?
        result << show_investigator_core_follow_up(form_elements_cache, element, f) unless element.core_path.blank?
        return result
      end

      questions = form_elements_cache.children(element)

      if questions.size > 0
        questions.each do |child|
          result << show_investigator_element(form_elements_cache, child, f)
        end
      end

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:follow_up_element), :id => element.id)
    end
  end

  # Show mode counterpart to render_investigator_core_follow_up
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def show_investigator_core_follow_up(form_elements_cache, element, f, ajax_render =false)
    begin
      result = ""

      include_children = false

      unless (ajax_render)
        core_value = eval_core_path(:object => @event, :core_path => element.core_path)

        if (element.condition_match?(core_value.to_s))
          include_children = true
        end
      end

      result << "<div id='follow_up_investigate_#{element.id}'>" unless ajax_render

      if (include_children || ajax_render)
        questions = form_elements_cache.children(element)

        if questions.size > 0
          questions.each do |child|
            result << show_investigator_element(form_elements_cache, child, f)
          end
        end
      end

      result << "</div>" unless ajax_render

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:core_follow_up_element), :id => element.id)
    end
  end

  # Print mode counterpart to #render_investigator_section
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def  print_investigator_section(form_elements_cache, section_element, f)
    begin
      partial = "events/investigate_section_element_print.html.haml" 
      content_tag(:div, :class => "print-element") do
        result = render(:partial => "events/investigate_section_element_header_print.html.haml", :locals => {:section => section_element})

        if section_element.repeater?

          # TODO: This fields_for loop is inefficient. We shouldn't loop through each form section, hunting
          # for the right one. Not sure how to better design this though.
          f.fields_for(:investigator_form_sections, :builder => ExtendedFormBuilder) do |investigator_form|
            if investigator_form.object.section_element_id == section_element.id
              result << investigator_section(partial, form_elements_cache, section_element, f, investigator_form)
            end
          end

          result << content_tag(:div, nil, :id => "repeater_section_investigate_#{h(section_element.id)}")

        else
          result << investigator_section(partial, form_elements_cache, section_element, f)
        end

        result
      end
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return "Could not render section element (#{section_element.id})<br/>"
    end
  end

  # Print mode counterpart to #render_investigator_group
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def print_investigator_group(form_elements_cache, element, f)
    begin
      result = ""

      group_children = form_elements_cache.children(element)

      if group_children.size > 0
        group_children.each do |child|
          result << print_investigator_element(form_elements_cache, child, f)
        end
      end

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:group_element), :id => element.id)
    end
  end

  # Print mode counterpart to #render_investigator_question
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def print_investigator_question(form_elements_cache, element, f, local_form_builder=nil)
    begin
      question = element.question
      question_style = question.style.blank? ? "vert" : question.style
      result = "<div id='question_investigate_#{element.id}' class='#{question_style}'>"
      result << "<span class='print-label'>#{question.question_text}:</span>&nbsp;"
      answer = collect_answer_object(question, local_form_builder)
      result << "<span class='print-value'>#{answer.text_answer}</span>" unless answer.nil?
      result << "</div>"

      follow_up_group = element.process_condition({:response => answer.text_answer}, @event.id, :form_elements_cache => form_elements_cache) unless answer.nil?

      unless follow_up_group.nil?
        result << "<div id='follow_up_investigate_#{element.id}'>"
        result << print_investigator_follow_up(form_elements_cache, follow_up_group, f)
        result << "</div>"
      end

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:question_element), :id => element.id)
    end
  end

  # Print mode counterpart to #render_investigator_follow_up
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def print_investigator_follow_up(form_elements_cache, element, f)
    begin
      result = ""

      if element.respond_to?(:core_path) and !element.core_path.blank?
        result << print_investigator_core_follow_up(form_elements_cache, element, f) 
        return result

        questions = form_elements_cache.children(element)

        if questions.size > 0
          questions.each do |child|
            result << print_investigator_element(form_elements_cache, child, f)
          end
        end
      end

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:follow_up_element), :id => element.id) + "<br/>"
    end
  end

  # Print mode counterpart to #render_investigator_core_follow_up
  #
  # Debt? Dupliactes most of the render method. Consider consolidating.
  def print_investigator_core_follow_up(form_elements_cache, element, f)
    begin
      result = ""

      include_children = false

      core_value = eval_core_path(:object => @event, :core_path => element.core_path)

      if (element.condition_match?(core_value.to_s))
        questions = form_elements_cache.children(element)

        if questions.size > 0
          questions.each do |child|
            result << print_investigator_element(form_elements_cache, child, f)
          end
        end
      end

      return result
    rescue Exception => e
      logger.warn($!.message)
      logger.debug(e.backtrace.join("\n"))
      return t(:could_not_render, :thing => t(:core_follow_up_element), :id => element.id) + "<br/>"
    end
  end

end
