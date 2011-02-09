def xpath_to xpath_name
  case xpath_name

  when /the patient's last name/i
    '/morbidity-event/interested-party-attributes/person-entity-attributes/person-attributes/last-name'
    
  when /the first reported to public health date/i
    '/morbidity-event/first-reported-PH-date'

  else
    raise %W{Can't find mapping from "#{xpath_name}" to an xpath.}
  end
end
