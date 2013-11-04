class MainController < ApplicationController
  include MainHelper
  
  @projects_list_array = []
  @current_project_id = 0
  @unfinished_todos_list_array = []
  @finished_todos_list_array = []
  @unfinished_todos_list_completed_todos = {}
  @finished_todos_list_completed_todos = {}
  
  def index
    
  end
  
  def projects_list
    @@login = params[:main][:login]
    @@pass = params[:main][:password]
    @@bc_id = params[:main][:basecamp_id]
    bc_response = make_bc_request("projects.json")
    
    if bc_response.code == 200
      @projects_list_array = JSON.parse(bc_response.body)
    else
      render :text => bc_response.code.to_s
    end
  end
  
  def todos_list
    @unfinished_todos_list_completed_todos = Hash.new("WTF..nothing here")
    @finished_todos_list_completed_todos = Hash.new("WTF..nothing here")
    
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts @unfinished_todos_list_completed_todos.inspect
    puts @finished_todos_list_completed_todos.inspect
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    
    @current_project_id = params[:project_id].blank? ? @current_project_id : params[:project_id]
    bc_response = make_bc_request("projects/" + @current_project_id.to_s + "/todolists.json")
    if bc_response.code == 200
      @unfinished_todos_list_array = JSON.parse(bc_response.body)
    else
      render :text => bc_response.code.to_s
    end
    
    @unfinished_todos_list_array.each { |todo|
      id = todo["id"].to_s
      bc_response = make_bc_request("projects/" + @current_project_id.to_s + "/todolists/" + id + ".json")
      if bc_response.code == 200
        unless id.nil?
          #puts "============================================================================================================"
          @unfinished_todos_list_completed_todos.store(id.to_sym, JSON.parse(bc_response.body)["todos"]["completed"])
        end
      else
        render :text => bc_response.code.to_s
      end
    }
    
    bc_response = make_bc_request("projects/" + @current_project_id.to_s + "/todolists/completed.json")
    if bc_response.code == 200
      @finished_todos_list_array = JSON.parse(bc_response.body)
    else
      render :text => bc_response.code.to_s
    end
    
    @finished_todos_list_array.each { |todo| 
      id = todo["id"].to_s
      bc_response = make_bc_request("/projects/" + @current_project_id.to_s + "/todolists/" + id + ".json")
      if bc_response.code == 200
        unless id.nil?
          #puts "=========================================================================================================="
          @finished_todos_list_completed_todos.store(id.to_sym, JSON.parse(bc_response.body)["todos"]["completed"])
        end
      else
        render :text => bc_response.code.to_s
      end
    }
    
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts @unfinished_todos_list_completed_todos.inspect
    puts @finished_todos_list_completed_todos.inspect
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  end
  
  def upload_build
    require 'fileutils'
    tmp = params[:upload_build][:datafile].tempfile
    
    tf_params = {
          :api_token => params[:upload_build][:api_token],
          :team_token => params[:upload_build][:team_token],
          :file => tmp,
          :notes => params[:upload_build][:release_notes],
          :distribution_lists => params[:upload_build][:accsses_list],
          :notify => true
        }
    
    tf_response = upload_build_to_tf(tf_params)
    if bc_response.code != 200
        render :text => bc_response.code.to_s
    end
  end
end
