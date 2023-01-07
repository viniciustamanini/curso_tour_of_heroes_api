class Api::HeroesController < ApplicationController
  include Authenticable
  
  before_action :authenticate_with_token, except: %i[index show]
  before_action :set_hero, only: %i[show update destroy]

  def index
    @heroes = Hero.all.search(params[:term]).sorted_by_name

    render json: @heroes
  end

  def show
    render json: @hero
  end

  def create
    @hero = Hero.new(hero_params)

    if @hero.save
      render json: @hero, status: :created, location: api_hero_url(@hero)
    else
      render json: @hero.errors, status: :unprocessable_entity
    end
  end

  def update
    if @hero.update(hero_params)
      render json: @hero
    else
      render json: @hero.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @hero.destroy
  end

  private
    def set_hero
      @hero = Hero.find(params[:id])
    end

    def hero_params
      params.require(:hero).permit(:name)
    end
end
