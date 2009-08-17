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

def path_to(page_name)
  case page_name
  
  when /the homepage/i
    root_path

  when /the admin dashboard page/i
    admin_path
  
  when /the jurisdictions page/i
    jurisdictions_path

  when /the show jurisdiction page/i
    jurisdiction_path

  # Add more page name => path mappings here
  when /the new CMR page/i
    new_cmr_path

  when /the investigator user edit page/i
    "/users/4/edit"
  
  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end
