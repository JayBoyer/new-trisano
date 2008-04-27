class Form < ActiveRecord::Base
  belongs_to :disease
  belongs_to :jurisdiction
  belongs_to :form_status
  
  has_many :sections, :order => :position
  
  validates_presence_of :disease
  validates_presence_of :jurisdiction
  
  def self.find_form_for_cmr(params)
    
    form = nil
    responses = []
    
    filled_in_form = Response.find(:first, :select => "distinct form_id", :conditions => {:cmr_id => params[:cmr_id], :form_template_id => params[:id]})
    
    if filled_in_form.nil?
      form = Form.find(:first, :conditions => {:template_form_id => params[:id], :form_status_id => FormStatus.find_by_name("live").id})
    else
      form = Form.find(filled_in_form.form_id)
      responses = Response.find_all_by_form_id_and_cmr_id(filled_in_form.form_id, params[:cmr_id])
    end
    
    return form, responses
  end
  
  def save_responses!(params)
    self.sections.each do |section|
      section.groups.each do |group|
        save_group_responses(group, params)
      end
    end
  end
  
  def publish!

    begin
      # Look at the ordering of cloning activities to try mass assignment
      # Transactional
      published_form = Form.new({:is_template => false, :template_form_id => self.id})
      published_form.name = self.name
      published_form.description = self.description
      published_form.disease_id = self.disease_id
      published_form.jurisdiction_id = self.jurisdiction_id
      
      published_form.save!
    
      self.sections.each do |section|
      
        published_section = Section.new({:form_id => published_form.id})
        published_section.name = section.name
        published_section.save!
        
        section.groups.each do |group|
          publish_group(group, published_section)
        end
      end
      
      live_status = FormStatus.find_by_name("live")
      current_live_form = Form.find_by_template_form_id_and_form_status_id(self.id, live_status)
      
      unless current_live_form.nil?
        current_live_form.form_status_id = 666
        current_live_form.save!
      end
      
      published_form.form_status_id = FormStatus.find_by_name("live")
      published_form.save!
      self.form_status = FormStatus.find_by_name("published")
      self.save!
    
    rescue Exception => ex
      p ex
      raise ex
      # ...
      # Mop up
      # or
      # Get transactional
    end
    
  end
  
  private
  
  def save_group_responses(group, params)
    
    group.questions.each do |question|

      response = Response.new({:cmr_id => params[:cmr_id], :form_template_id => params[:id], :form_id => params[:form_instance_id], :question_id => question.id})
      form_field_value = params["question_#{question.id}"]
          
      if question.question_type.has_answer_set
        response.answer_id = form_field_value.to_i
      else
        response.response = form_field_value
      end
          
      response.save!
      
      follow_up_group = question.process_conditional(response.value)
      
      unless follow_up_group.nil?
        save_group_responses(follow_up_group, params)
      end
    
    end
  end
  
  def publish_group(group, published_section=nil)
    
    published_group = Group.new
    published_group.section_id = published_section.id unless published_section.nil?
    published_group.name = group.name
    published_group.description = group.description
    published_group.save!
          
    group.questions.each do |question|
      published_question = Question.new({:group_id => published_group.id})
      published_question.text = question.text
      published_question.help = question.help
      published_question.question_type_id = question.question_type_id
      published_question.condition = question.condition
      
      unless question.follow_up_group_id.nil?
        published_question.follow_up_group_id = publish_group(question.follow_up_group)
      end
            
      published_question.save!
            
      if published_question.question_type.has_answer_set == true
              
        published_answer_set = AnswerSet.new({:question_id => published_question.id})
        published_answer_set.name = question.answer_set.name
        published_answer_set.save!
              
        question.answer_set.answers.each do |answer|
          published_answer = Answer.new({:answer_set_id => published_answer_set.id})
          published_answer.text = answer.text
          published_answer.save!
        end
              
      end
    end
    
    published_group.id
  end
  
end
