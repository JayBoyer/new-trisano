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

class FormReference < ActiveRecord::Base
  include FormBuilderDslHelper

  belongs_to :event
  belongs_to :form
  has_many :answers, :through => :event

  after_destroy :destroy_answers, :destroy_investigator_form_sections

  def destroy_investigator_form_sections
    section_ids = form.section_form_elements.map(&:id)
    investigator_form_sections = InvestigatorFormSection.find(:all, :conditions => ["event_id = ? AND section_element_id in (?)", event.id, section_ids])
    investigator_form_sections.map(&:destroy)
  end

  def destroy_answers
    question_ids = form.questions.map(&:id)
    answers = Answer.find(:all, :conditions => ["question_id in (?) and event_id = ?", question_ids, event.id])
    answers.map(&:destroy)
  end

end
