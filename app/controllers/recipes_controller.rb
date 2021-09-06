class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    before_action :authorize, only: [:create,:index]

    def index
        recipes = Recipe.all
        render json: recipes
    end
    def create
        user = User.find_by(id: session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        render json: recipe, status: :created
    end

    private

    def recipe_params
        params.permit(:title,:instructions,:minutes_to_complete)
    end

    def authorize
        user = User.find_by(id: session[:user_id])
    
        render json: { errors: ["Not authorized"] }, status: :unauthorized unless user
    end

    def render_unprocessable_entity_response
        render json: { errors: ["Invalid Recipe"]}, status: :unprocessable_entity
    end
end
