# app/controllers/todos_controller.rb
class SystemsController < ApplicationController
    before_action :set_system, only: [:show, :update, :destroy]
  
    # GET /systems
    def index
      @systems = System.all
      json_response(@systems)
    end
  
    # POST /systems
    def create
      @system = System.create!(system_params)
      json_response(@system, :created)
    end
  
    # GET /systems/:id
    def show
      json_response(@system)
    end
  
    # PUT /systems/:id
    def update
      @system.update(system_params)
      head :no_content
    end
  
    # DELETE /systems/:id
    def destroy
      @system.destroy
      head :no_content
    end
  
    private
  
    def system_params
      # whitelist params
      params.permit(:name)
    end
  
    def set_system
      @system = System.find(params[:id])
    end
  end