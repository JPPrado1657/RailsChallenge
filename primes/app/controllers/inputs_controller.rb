require 'net/http'

class InputsController < ApplicationController
    before_action :set_system
    before_action :set_system_input, only: [:show, :update, :destroy]
  
    # GET /systems/:system_id/inputs
    def index
      json_response(@system.inputs)
    end
  
    # GET /systems/:system_id/inputs/:id
    def show
      json_response(@input)
    end

    # GET /systems/:system_id/inputs/by_number/:number
    def by_number
      @input = @system.inputs.find_by(input: params[:number]) if @system
      if @input
        json_response({:data => @input.output, :kept => true})
      else
        url = URI.parse('https://raw.githubusercontent.com/koorukuroo/Prime-Number-List/master/primes.json')
        res = JSON.parse(Net::HTTP.get_response(url).body)
        key = res.key(params[:number].to_i).to_i
        i = 0
        array = []
        until i > key
          array.push(res[i.to_s])
          i += 1
        end
        json_response({:data => array, :kept => false})
      end
    end
  
    # POST /systems/:system_id/inputs
    def create
      print(input_params)
      @system.inputs.create!(input_params)
      json_response(@system, :created)
    end
  
    # PUT /systems/:system_id/inputs/:id
    def update
      @input.update(input_params)
      head :no_content
    end
  
    # DELETE /systems/:system_id/inputs/:id
    def destroy
      @input.destroy
      head :no_content
    end
  
    private
  
    def input_params
      params.permit(:input, :output, :validInput)
    end
  
    def set_system
      @system = System.find(params[:system_id])
    end
  
    def set_system_input
      @input = @system.inputs.find_by!(id: params[:id]) if @system
    end
  end