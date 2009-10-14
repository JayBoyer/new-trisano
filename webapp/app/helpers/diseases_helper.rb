# Copyright (C) 2007, 2008, 2009 The Collaborative Software Foundation
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

module DiseasesHelper

  def show_hide_disease_section_link
    link_to_function '[&nbsp;Show&nbsp;|&nbsp;Hide&nbsp;Details&nbsp;]' do |page|
      page << "$(this).up().up().up().next().toggle()"
    end
  end

  def disease_check_boxes(name, checked_values=[])
    Disease.all(:order => 'disease_name').each do |disease|
      id = name.gsub('[', '_').gsub(']', '') + disease.id.to_s
      haml_tag :label, :for => id do
        haml_concat check_box_tag(name, disease.id, checked_values.include?(disease.id), :id => id)
        haml_concat disease.disease_name
      end
    end
  end
end
