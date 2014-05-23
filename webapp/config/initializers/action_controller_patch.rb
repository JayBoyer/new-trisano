class ActionController::Base
  # This is a patch for actionpackcsi_2.3.5.p8 gem
  # OVERWRITE candidate_for_layout? in ActionController to prevent jruby/performance hit for using throw/rescue
  #TODO Jay
  private
    def candidate_for_layout?(options)

      template = options[:template]
      if(options[:nothing])
        return false
      end         
      template ||= default_template(options[:action])
      if options.values_at(:text, :xml, :json, :file, :inline, :partial, :nothing, :update).compact.empty?
        begin
          template_object = self.view_paths.find_template(template, default_template_format)
          # this restores the behavior from 2.2.2, where response.template.template_format was reset
          # to :html for :js requests with a matching html template.
          # see v2.2.2, ActionView::Base, lines 328-330
          @real_format = :html if response.template.template_format == :js && template_object.format == "html"
          !template_object.exempt_from_layout?
        rescue ActionView::MissingTemplate
          true
        end
      end
    rescue ActionView::MissingTemplate
      false
    end
end