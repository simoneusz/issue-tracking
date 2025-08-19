# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:assignee) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:issue) { create(:issue, project: project, user: user, assignee: assignee) }

  before do
    allow(controller).to receive_messages(authenticate_user!: true, current_user: user)
  end

  describe 'GET #show' do
    subject(:get_show) { get :show, params: { project_id: project.id, id: issue.id } }

    context 'when issue exists' do
      before { get_show }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @project' do
        expect(assigns(:project)).to eq(project)
      end

      it 'assigns @issue' do
        expect(assigns(:issue)).to eq(issue)
      end

      it 'assigns @comments' do
        expect(assigns(:comments)).to eq(issue.comments)
      end
    end

    context 'when issue does not exist' do
      subject(:get_show) { get :show, params: { project_id: project.id, id: 999 } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { get_show }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when project does not exist' do
      subject(:get_show) { get :show, params: { project_id: 999, id: issue.id } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { get_show }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #new' do
    subject(:get_new) { get :new, params: { project_id: project.id } }

    before { get_new }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @project' do
      expect(assigns(:project)).to eq(project)
    end

    it 'assigns new issue' do
      expect(assigns(:issue)).to be_a_new(Issue)
    end

    it 'assigns issue to project' do
      expect(assigns(:issue).project).to eq(project)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit) { get :edit, params: { project_id: project.id, id: issue.id } }

    context 'when user owns the issue' do
      before { get_edit }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @project' do
        expect(assigns(:project)).to eq(project)
      end

      it 'assigns @issue' do
        expect(assigns(:issue)).to eq(issue)
      end
    end

    context 'when user does not own the issue' do
      let(:issue) { create(:issue, project: project, user: another_user) }

      it 'redirects to project path' do
        get_edit
        expect(response).to redirect_to(project_path(project))
      end

      it 'sets alert message' do
        get_edit
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end

  describe 'POST #create' do
    subject(:create_issue) { post :create, params: { project_id: project.id, issue: issue_params } }

    context 'with valid parameters' do
      let(:issue_params) do
        { title: 'New Issue', description: 'Issue description', status: 'open', assignee_id: assignee.id }
      end

      it 'creates a new issue' do
        expect { create_issue }.to change(Issue, :count).by(1)
      end

      it 'assigns issue to current user' do
        create_issue
        expect(Issue.last.user).to eq(user)
      end

      it 'assigns issue to project' do
        create_issue
        expect(Issue.last.project).to eq(project)
      end

      it 'assigns issue to assignee' do
        create_issue
        expect(Issue.last.assignee).to eq(assignee)
      end

      it 'redirects to project issue' do
        create_issue
        expect(response).to redirect_to(project_issue_path(project, Issue.last))
      end

      it 'sets success notice' do
        create_issue
        expect(flash[:notice]).to eq('Issue was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:issue_params) { { title: '', description: '', status: '', assignee_id: assignee.id } }

      before { create_issue }

      it 'does not create an issue' do
        expect { create_issue }.not_to change(Issue, :count)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    subject(:update_issue) { patch :update, params: { project_id: project.id, id: issue.id, issue: issue_params } }

    context 'when user owns the issue' do
      context 'with valid parameters' do
        let(:issue_params) { { title: 'Updated Issue', description: 'Updated description', status: 'closed' } }

        before { update_issue }

        it 'updates the issue' do
          issue.reload
          expect(issue.title).to eq('Updated Issue')
        end

        it 'redirects to project issue' do
          expect(response).to redirect_to(project_issue_path(project, issue))
        end

        it 'sets success notice' do
          expect(flash[:notice]).to eq('Issue was successfully updated.')
        end
      end

      context 'with invalid parameters' do
        let(:issue_params) { { title: '', description: '', status: '' } }

        before { update_issue }

        it 'does not update the issue' do
          issue.reload
          expect(issue.title).not_to eq('')
        end

        it 'renders edit template' do
          expect(response).to render_template(:edit)
        end

        it 'returns unprocessable entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user does not own the issue' do
      let(:issue) { create(:issue, project: project, user: another_user) }
      let(:issue_params) { { title: 'Updated Issue' } }

      it 'redirects to project path' do
        update_issue
        expect(response).to redirect_to(project_path(project))
      end

      it 'sets alert message' do
        update_issue
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_issue) { delete :destroy, params: { project_id: project.id, id: issue.id } }

    context 'when user owns the issue' do
      let!(:issue) { create(:issue, project: project, user: user) }

      it 'deletes the issue' do
        expect { delete_issue }.to change(Issue, :count).by(-1)
      end

      it 'redirects to project path' do
        delete_issue
        expect(response).to redirect_to(project_path(project))
      end

      it 'sets success notice' do
        delete_issue
        expect(flash[:notice]).to eq('Issue was successfully deleted.')
      end
    end

    context 'when user does not own the issue' do
      let!(:issue) { create(:issue, project: project, user: another_user) }

      it 'does not delete the issue' do
        expect { delete_issue }.not_to change(Issue, :count)
      end

      it 'redirects to project path' do
        delete_issue
        expect(response).to redirect_to(project_path(project))
      end

      it 'sets alert message' do
        delete_issue
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end
end
