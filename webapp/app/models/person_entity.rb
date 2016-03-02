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

class PersonEntity < Entity
  include FulltextSearch

  has_one :person, :foreign_key => "entity_id", :class_name => "Person"
  accepts_nested_attributes_for :person, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }, :allow_destroy => true

  has_and_belongs_to_many :races,
    :foreign_key => 'entity_id',
    :class_name => 'ExternalCode',
    :join_table => 'people_races',
    :association_foreign_key => 'race_id',
    :order => 'code_description'

  has_many :interested_parties, :foreign_key => :primary_entity_id
  has_many :human_events, :through => :interested_parties

  def xml_fields
    [[:race_ids, {:rel => 'https://wiki.csinitiative.com/display/tri/Relationship+-+Race'}]]
  end
  
  class << self
    def find_exact_match(person_attributes)
      options = {}
      options[:last_name] = person_attributes[:last_name]
      options[:middle_name] = person_attributes[:middle_name]
      options[:first_name] = person_attributes[:first_name]
      options[:birth_date] = person_attributes[:birth_date]
      options[:birth_gender_id] = person_attributes[:birth_gender_id]
      person = Person.find_exact_match(options)
      unless(person.blank?)
        return person.entity_id
      end
      return nil
    end
  end  
  
end
