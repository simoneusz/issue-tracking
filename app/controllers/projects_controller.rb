# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @project = if current_user
                 Project.by_user(current_user)
               else
                 Project.all
               end
  end

  def show
    @issues = @project.issues
  end

  def new
    @project = current_user.projects.build
  end

  def edit; end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def authorize_user!
    redirect_to projects_path, alert: 'Not authorized' unless @project.user == current_user
  end

  def project_params
    params.expect(project: %i[name description])
  end
end
