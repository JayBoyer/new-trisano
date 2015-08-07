class LabResultsController < ApplicationController

  def show
    @lab_result = LabResult.find(params[:id])
  end
  
  def move_lab
  lab_result = LabResult.find(params[:id])
    if(params[:commit] == "un-assign")
      result = lab_result.un_assign
      redis.delete_matched("staged_messages/#{lab_result.staged_message.id}*")  
      redirect_to('/staged_messages/'+lab_result.staged_message.id.to_s)
    else
      result = lab_result.move_to_event(params[:destination_event].strip)
      redirect_to request.env["HTTP_REFERER"]
    end
    redis.delete_matched("lab_results/#{params[:id]}*")  
    if(result[0,7] == "success")
      flash[:notice] = t(result)
    else
      flash[:error] = t(result)
    end
  end
end
