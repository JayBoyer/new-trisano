class FollowUpElement < FormElement
  
  attr_accessor :parent_element_id
  
  validates_presence_of :condition
  
    def save_and_add_to_form
    if self.valid?
      transaction do
        parent_element = FormElement.find(parent_element_id)
        self.tree_id = parent_element.tree_id
        self.form_id = parent_element.form_id
        self.save
        parent_element.add_child(self)
      end
    end
  end
  
end
