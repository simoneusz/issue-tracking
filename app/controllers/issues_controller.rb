# frozen_string_literal: true

class IssuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_issue, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @issues = @project.issues
  end

  def show
    @comments = @issue.comments
  end

  def new
    @issue = @project.issues.build
  end

  def edit; end

  def create
    @issue = @project.issues.build(issue_params)
    @issue.user = current_user
    if @issue.save
      redirect_to project_issue_path(@project, @issue), notice: 'Issue was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @issue.update(issue_params)
      redirect_to project_issue_path(@project, @issue), notice: 'Issue was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    redirect_to project_path(@project), notice: 'Issue was successfully deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_issue
    @issue = @project.issues.find(params[:id])
  end

  def authorize_user!
    redirect_to project_path(@project), alert: 'Not authorized' unless @issue.user == current_user
  end

  def issue_params
    params.expect(issue: %i[title description status assignee_id])
  end
end
