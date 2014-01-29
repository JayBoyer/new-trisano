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
        rank_date = search_rank_date(options)
        rank_name = search_rank_name(options)
        similarity = 
          "(CASE\n" +
          "  WHEN birth_date IS NULL THEN #{rank_name}\n" +
          "  WHEN first_name IS NULL AND last_name IS NULL THEN #{rank_date}\n" +
          "  ELSE (0.667*#{rank_name} + 0.333*#{rank_date})\n" +
          "END)"
      end
      return similarity
    end

    def search_rank_name(options)
      similarity = "1.0"
      unless options[:fulltext_terms].blank?
        terms = options[:fulltext_terms]
        names = terms.split(/\s/)
        similarity =  "(GREATEST(similarity(first_name, '#{names[0]}'), similarity(last_name, '#{names[0]}'))) "
        if(names.count > 1)
          similarity =  "(sqrt(similarity(first_name, '#{names[0]}'))/2 + sqrt(similarity(last_name, '#{names[1]}'))/2) "
        end
      end
      return similarity
    end
    
    def search_rank_date(options)
      similarity = "1.0"
      unless options[:birth_date].blank?
        if (options[:birth_date].to_s.size == 4 && options[:birth_date].to_i != 0)
          pattern = "YYYY"
        else
          pattern = "YYYY-MM-DD"
        end
        similarity = "similarity(to_char(birth_date, '#{pattern}'), '" + options[:birth_date].to_s + "')"
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
        similarity = search_rank_name(options)
        if(names.count > 1)
          last_name = names[names.count-1].upcase
          operator = 'AND'
          
          # We were expecting "first last", fix it if we got "last, first"
          if(first_name.end_with?(","))
            temp = first_name[0,first_name.size-1]
            first_name = last_name
            last_name = temp
          end
        end
      
        date_conditions = birth_date_conditions(options)
      
        sql = "SELECT * FROM people WHERE (upper(last_name) = '#{last_name}' " +
          "#{operator} upper(first_name) = '#{first_name}') " + 
          (date_conditions.blank?  ? "" : "AND " + date_conditions ) + 
          " LIMIT 1"

        # if an exact match finds anything, do an exact match
        if(!options.has_key?(:fuzzy_only) && Person.find_by_sql(sql).size > 0)
          results = " ((upper(last_name) = '#{last_name}' #{operator} upper(first_name) = '#{first_name}') " +
            (date_conditions.blank? ? ")" : "AND " + date_conditions + ")" )
        else
#         commented out a soundex search, it is very similar speed but search results are not as good
#         results = " (soundex(last_name) = soundex('#{last_name}') #{operator} soundex(first_name) = soundex('#{first_name}')) " +
         results = " (((first_name % '#{first_name}' OR last_name % '#{last_name}')\n  AND #{similarity} > 0.3) " +
            (date_conditions.blank? ? ")" : "OR " + date_conditions + ")" )
        end
      end
    end
    
    def birth_date_conditions(options)
      unless options[:birth_date].blank?
        if (options[:birth_date].to_s.size == 4 && options[:birth_date].to_i != 0)
          conditions = "(EXTRACT(YEAR FROM birth_date) = " + options[:birth_date].to_s + ")"
        else
          conditions = "(birth_date = '" + options[:birth_date].to_s  + "')"
        end
      end
    end

  end
end
