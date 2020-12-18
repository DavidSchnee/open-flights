class Api::V1::AirlinesController < ApplicationController
  before_action :find_airline, only: [:show, :update, :destroy]

  protect_from_forgery with: :null_session
  def index
    render json: AirlineSerializer.new(Airline.all, options).serialized_json
  end

  def show
    render json: AirlineSerializer.new(@airline, options).serialized_json
  end

  def create
    @airline = Airline.new(airline_params)

    if @airline.update(airline_params)
      render json: AirlineSerializer.new(@airline).serialized_json, status: 200
    else
      render json: { error: @airline.errors.full_messages }, status: 422
    end
  end

  def update
    if @airline.update(airline_params)
      render json: AirlineSerializer.new(@airline, options).serialized_json, status: 200
    else
      render json: { error: @airline.errors.full_messages }, status: 422
    end
  end

  def destroy
    if @airline.destroy
      head :no_content
    else
      render json: { error: @airline.errors.full_messages }, status: 422
    end
  end

  private

  def find_airline
    @airline = Airline.find_by(slug: params[:slug])
  end

  def airline_params
    params.require(:airline).permit(:name, :image_url)
  end

  def options
    @options ||= { include: %i[reviews] }
  end
end