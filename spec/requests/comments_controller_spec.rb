# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:issue) { create(:issue, project: project, user: user) }
  let(:comment) { create(:comment, issue: issue, user: user) }

  before do
    allow(controller).to receive_messages(authenticate_user!: true, current_user: user)
  end

  describe 'POST #create' do
    subject(:create_comment) do
      post :create, params: { project_id: project.id, issue_id: issue.id, comment: comment_params }
    end

    context 'with valid parameters' do
      let(:comment_params) { { body: 'This is a test comment' } }

      it 'creates a new comment' do
        expect { create_comment }.to change(Comment, :count).by(1)
      end

      it 'assigns comment to current user' do
        create_comment
        expect(Comment.last.user).to eq(user)
      end

      it 'assigns comment to issue' do
        create_comment
        expect(Comment.last.issue).to eq(issue)
      end

      it 'redirects to project issue' do
        create_comment
        expect(response).to redirect_to(project_issue_path(project, issue))
      end

      it 'sets success notice' do
        create_comment
        expect(flash[:notice]).to eq('Comment added.')
      end
    end

    context 'with invalid parameters' do
      let(:comment_params) { { body: '' } }

      before { create_comment }

      it 'does not create a comment' do
        expect { create_comment }.not_to change(Comment, :count)
      end

      it 'redirects to project issue' do
        expect(response).to redirect_to(project_issue_path(project, issue))
      end

      it 'sets alert message' do
        expect(flash[:alert]).to eq('Failed to add comment.')
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_comment) { delete :destroy, params: { project_id: project.id, issue_id: issue.id, id: comment.id } }

    context 'when user owns the comment' do
      let!(:comment) { create(:comment, issue: issue, user: user) }

      it 'deletes the comment' do
        comment
        expect { delete_comment }.to change(Comment, :count).by(-1)
      end

      it 'redirects to project issue' do
        delete_comment
        expect(response).to redirect_to(project_issue_path(project, issue))
      end

      it 'sets success notice' do
        delete_comment
        expect(flash[:notice]).to eq('Comment deleted.')
      end
    end

    context 'when user does not own the comment' do
      let(:comment) { create(:comment, issue: issue, user: another_user) }

      it 'does not delete the comment' do
        comment
        expect { delete_comment }.not_to change(Comment, :count)
      end

      it 'redirects to project issue' do
        delete_comment
        expect(response).to redirect_to(project_issue_path(project, issue))
      end

      it 'sets alert message' do
        delete_comment
        expect(flash[:alert]).to eq('Not authorized')
      end
    end

    context 'when comment does not exist' do
      subject(:delete_comment) { delete :destroy, params: { project_id: project.id, issue_id: issue.id, id: 999 } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { delete_comment }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when issue does not exist' do
      subject(:delete_comment) { delete :destroy, params: { project_id: project.id, issue_id: 999, id: comment.id } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { delete_comment }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when project does not exist' do
      subject(:delete_comment) { delete :destroy, params: { project_id: 999, issue_id: issue.id, id: comment.id } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { delete_comment }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
