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
module FulltextSearch

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def fulltext_join(options)
      unless options[:fulltext_terms].blank?
        max_results = options[:limit].blank? ? 100 : options[:limit].to_i
        <<-JOIN
        INNER JOIN (\n#{fulltext(options[:fulltext_terms])}\n
             LIMIT #{max_results}) search_results
             ON (search_results.search_result_id = people.id AND
                 search_results.rank > 0.3)
        JOIN
      end
    end

    def order()
      "rank DESC, last_name ASC, first_name ASC"
    end

    def fulltext_order(options)
      unless options[:fulltext_terms].blank?
        order()
      end
    end
    
    def fulltext(terms)
      names = terms.split(/\s/)
      first_name = names[0].upcase
      last_name = names[0].upcase
      operator = 'OR'
      similarity =  "(GREATEST(similarity(first_name, '#{first_name}'), similarity(last_name, '#{last_name}'))) "
      if(names.count > 1)
        last_name = names[names.count-1].upcase
        operator = 'AND'
        similarity =  "(sqrt(similarity(first_name, '#{first_name}')) + sqrt(similarity(last_name, '#{last_name}')))/2 "
        end
      end
      
      sql = "SELECT * FROM people WHERE upper(last_name) = '#{last_name}' " +
        "#{operator} upper(first_name) = '#{first_name}' LIMIT 1"

      # if an exact match finds anything, do an exact match
      if(Person.find_by_sql(sql).size > 0)
        results = "SELECT id AS search_result_id, #{similarity} as rank FROM people WHERE upper(last_name) = upper('#{last_name}') " +
         "#{operator} upper(first_name) = upper('#{first_name}') ORDER BY #{order()}"
      else
#        returning [] do |result|
#          result << "SELECT id AS search_result_id, #{similarity} as rank FROM people " 
#          result << "WHERE soundex(last_name) = soundex('#{last_name}') "
#          result << "#{operator} "
#          result << "soundex(first_name) = soundex('#{first_name}') "
#          result << "ORDER BY #{order()} "
#        end.join("\n")
        
        returning [] do |result|
          result << "SELECT id AS search_result_id, "
          result << similarity + "as rank "
          result << "FROM people WHERE (first_name % '#{first_name}' OR last_name % '#{last_name}') AND "
          result << similarity + " > 0.3 "
          result << "ORDER BY #{order()} "
        end.join("\n")
      end
    end
#          if(terms.count > 1)
#            join = "INNER JOIN (" +
#              "SELECT id AS search_result_id, (similarity(first_name, '#{first_name}') + similarity(last_name, '#{last_name}')) as rank " + 
#              "FROM people WHERE (first_name % '#{first_name}' OR last_name % '#{last_name}') AND " + 
#              "similarity(first_name, '#{first_name}')+similarity(last_name, '#{last_name}') > 0.3 LIMIT #{max_results}) "
#          else
#            join = "INNER JOIN (" +
#              "SELECT id AS search_result_id, GREATEST(similarity(first_name, '#{name}'), similarity(last_name, '#{name}')) as rank " + 
#              "FROM people WHERE (first_name % '#{name}' OR last_name % '#{name}') AND " + 
#              "GREATEST(first_name, '#{name}'), similarity(last_name, '#{name}') > 0.3 LIMIT #{max_results}) "
#          end    
  end
end
