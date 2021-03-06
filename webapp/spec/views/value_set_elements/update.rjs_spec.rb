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

require File.dirname(__FILE__) + '/../../spec_helper'

describe "/value_set_elements/update.rjs" do

  before do
    @form = Factory.build(:form)
    @form.save_and_initialize_form_elements
    parent_id = @form.investigator_view_elements_container.id
    assigns[:form] = @form

    @value_set = Factory.build(:value_set_element, :parent_element_id => parent_id)
    @value_set.save_and_add_to_form
    assigns[:value_set_element] = @value_set

    assigns[:library_elements] = []
  end

  it "renders" do
    render "value_set_elements/update.rjs"
  end

end
