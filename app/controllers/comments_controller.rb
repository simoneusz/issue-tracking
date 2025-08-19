# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_issue
  before_action :set_comment, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]

  def create
    @comment = @issue.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to project_issue_path(@project, @issue), notice: 'Comment added.'
    else
      redirect_to project_issue_path(@project, @issue), alert: 'Failed to add comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to project_issue_path(@project, @issue), notice: 'Comment deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_issue
    @issue = @project.issues.find(params[:issue_id])
  end

  def set_comment
    @comment = @issue.comments.find(params[:id])
  end

  def authorize_user!
    redirect_to project_issue_path(@project, @issue), alert: 'Not authorized' unless @comment.user == current_user
  end

  def comment_params
    params.expect(comment: [:body])
  end
end
