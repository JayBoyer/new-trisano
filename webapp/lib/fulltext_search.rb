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

  #TODO delete
    def fulltext_join(options)
      unless options[:fulltext_terms].blank?
        <<-JOIN
        INNER JOIN 
          (SELECT id AS search_result_id, 
            #{similarity} + "as rank 
            FROM people WHERE 
              #{fulltext(options)} 
            AND similarity + " > 0.3 
          ) search_results
          ON (search_results.search_result_id = people.id AND #{search_rank(options)} > 0.3)
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
    
    def search_rank(options)
      similarity = "1.0"
      unless options[:fulltext_terms].blank?
        terms = options[:fulltext_terms]
        names = terms.split(/\s/)
        similarity =  "(GREATEST(similarity(first_name, '#{names[0]}'), similarity(last_name, '#{names[0]}'))) "
        if(names.count > 1)
          similarity =  "(sqrt(similarity(first_name, '#{names[0]}')) + sqrt(similarity(last_name, '#{names[1]}')))/2 "
        end
      end
      return similarity
    end
    
    def fulltext(options)
      unless options[:fulltext_terms].blank?
        terms = options[:fulltext_terms]
        names = terms.split(/\s/)
        first_name = names[0].upcase
        last_name = names[0].upcase
        operator = 'OR'
        similarity = search_rank(options)
        if(names.count > 1)
          last_name = names[names.count-1].upcase
          operator = 'AND'
        end
      
        sql = "SELECT * FROM people WHERE upper(last_name) = '#{last_name}' " +
          "#{operator} upper(first_name) = '#{first_name}' LIMIT 1"

        # if an exact match finds anything, do an exact match
        if(Person.find_by_sql(sql).size > 0)
          results = " (upper(last_name) = '#{last_name}' #{operator} upper(first_name) = '#{first_name}') "
        else
#          results = " (soundex(last_name) = '#{last_name}' #{operator} soundex(first_name) = '#{first_name}') "
         results = " ((first_name % '#{first_name}' OR last_name % '#{last_name}')\n  AND #{similarity} > 0.3) "
        end
      end
    end
  end
end
