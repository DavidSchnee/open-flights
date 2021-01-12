class Api::V1::ReviewsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    @review = airline.reviews.new(review_params)

    if @review.save
      render json: ReviewSerializer.new(@review).serialized_json, status: 200
    else
      render json: { error: @airline.errors.full_messages }, status: 422
    end
  end

  def destroy
    @review = airline.reviews.find(params[:id])

    if @review.destroy
      head :no_content
    else
      render json: { error: @airline.errors.full_messages }, status: 422
    end
  end

  private

  def airline
    @airline ||= Airline.find(params[:airline_id])
  end

  def review_params
    params.require(:review).permit(:title, :description, :score, :airline_id)
  end
end