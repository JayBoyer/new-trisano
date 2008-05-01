require File.dirname(__FILE__) + '/../spec_helper'

describe AnswerSetElement do
  before(:each) do
    @answer_set_element = AnswerSetElement.new
  end

  it "should be valid" do
    @answer_set_element.should be_valid
  end
  
  describe "when created with 'save and add to form'" do
    
    it "should be a child of the question provided" do
      question_element = QuestionElement.create({:form_id => 1})
      @answer_set_element.save_and_add_to_form(question_element.id)
      
      @answer_set_element.parent_id.should_not be_nil
      
      question_element = FormElement.find(question_element.id)
      question_element.children[0].id.should == @answer_set_element.id 
    end
    
  end
end
