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

require 'ruby-hl7'

module HL7
  class Message

    def orders
      select{|s| s.to_s =~ /^OBR/}.collect{ |s| StagedMessages::ObrWrapper.new(s, :full_message => self) }
    end

  end
end

module StagedMessages
  class ObrWrapper
    attr_reader :obr_segment
    attr_accessor :full_message
  
    def initialize(obr_segment, options={})
      @obr_segment = obr_segment
      @full_message = options[:full_message]
    end
    
    def lab
      begin
        obr_segment.e4.split('^').join(' ')
      rescue
        "Could not be determined"
      end
    end
    
    def lab_test_date
      begin
        obr_segment.e22
      rescue
        "Could not be determined"
      end
    end

    def specimen_source
      begin
        obr_segment.e15
      rescue
        "Could not be determined"
      end
    end
  
    def collection_date
      begin
        obr_segment.e7
      rescue
        "Could not be determined"
      end
    end

    def tests
      full_message.select { |s| s.to_s =~ /^OBX/}.collect{|s| StagedMessages::ObxWrapper.new(s)}
    end
  end

  class ObxWrapper
    attr_reader :obx_segment
    
    def initialize(obx_segment)
      @obx_segment = obx_segment
    end
    
    def result
      begin
        obx_segment.e5 + (obx_segment.e6.blank? ? '' : " #{obx_segment.e6}")
      rescue
        "Could not be determined"
      end
    end
  
    def reference_range
      begin
        obx_segment.e7
      rescue
        "Could not be determined"
      end
    end

    def test_type
      begin
        obx_segment.e3
      rescue
        "Could not be determined"
      end
    end
  end
end
