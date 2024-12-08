class SkillController < ApplicationController
  before_action :check_admin

  def index
    @skill = Kaminari.paginate_array(Skill.all).page(params[:page]).per(10)
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.create(skills_params)
    if @skill.save
      flash[:success] = "Skill Created!"
      redirect_to skill_index_path
    else
      flash[:error] = "Something went wrong!"
      redirect_to skill_index_path
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    if @skill
      @skill.destroy
      flash[:success] = "Skill deleted!"
      redirect_to skill_index_path
    else
      flash[:error] = "Something went wrong!"
      redirect_to skill_index_path
    end
  end

private
  def skills_params
    params.require(:skill).permit(:title)
  end
end