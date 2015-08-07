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

module LabResultsHelper
  def loinc_code_name(loinc_code_id)
    begin
      loinc_code = LoincCode.find(loinc_code_id).loinc_code
    rescue
      loinc_code = loinc_code_id
    end
  end
  
  def lab_name(id)
    Place.find_by_entity_id(Participation.find(LabResult.find(id).participation_id).secondary_entity_id).name
  end
  
  def lab_result_value_name(external_code_id)
    begin
      code_description = ExternalCode.find(external_code_id).code_description
    rescue
      code_description = external_code_id
    end
  end
end
