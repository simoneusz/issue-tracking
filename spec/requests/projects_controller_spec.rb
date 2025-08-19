# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    allow(controller).to receive_messages(authenticate_user!: true, current_user: user)
  end

  describe 'GET #index' do
    subject(:get_index) { get :index, params: {} }

    context 'when user is authenticated' do
      before do
        create_list(:project, 3)
        get_index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @projects' do
        expect(assigns(:projects)).to eq(Project.all)
      end
    end

    context 'when user is not authenticated' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        allow(controller).to receive(:authenticate_user!).and_call_original
      end

      it 'calls authenticate_user!' do
        expect(controller).to receive(:authenticate_user!)
        get_index
      end
    end
  end

  describe 'GET #show' do
    subject(:get_show) { get :show, params: { id: project.id } }

    context 'when project exists' do
      before { get_show }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @project' do
        expect(assigns(:project)).to eq(project)
      end

      it 'assigns @issues' do
        expect(assigns(:issues)).to eq(project.issues)
      end
    end

    context 'when project does not exist' do
      subject(:get_show) { get :show, params: { id: 999 } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { get_show }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #new' do
    subject(:get_new) { get :new }

    before { get_new }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns new project' do
      expect(assigns(:project)).to be_a_new(Project)
    end

    it 'assigns project to current user' do
      expect(assigns(:project).user).to eq(user)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit) { get :edit, params: { id: project.id } }

    context 'when user owns the project' do
      before { get_edit }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @project' do
        expect(assigns(:project)).to eq(project)
      end
    end

    context 'when user does not own the project' do
      let(:project) { create(:project, user: another_user) }

      it 'redirects to projects path' do
        get_edit
        expect(response).to redirect_to(projects_path)
      end

      it 'sets alert message' do
        get_edit
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end

  describe 'POST #create' do
    subject(:create_project) { post :create, params: { project: project_params } }

    context 'with valid parameters' do
      let(:project_params) { { name: 'New Project', description: 'Project description' } }

      it 'creates a new project' do
        expect { create_project }.to change(Project, :count).by(1)
      end

      it 'assigns project to current user' do
        create_project
        expect(Project.last.user).to eq(user)
      end

      it 'redirects to project' do
        create_project
        expect(response).to redirect_to(Project.last)
      end

      it 'sets success notice' do
        create_project
        expect(flash[:notice]).to eq('Project was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:project_params) { { name: '', description: '' } }

      before { create_project }

      it 'does not create a project' do
        expect { create_project }.not_to change(Project, :count)
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
    subject(:update_project) { patch :update, params: { id: project.id, project: project_params } }

    context 'when user owns the project' do
      context 'with valid parameters' do
        let(:project_params) { { name: 'Updated Project', description: 'Updated description' } }

        before { update_project }

        it 'updates the project' do
          project.reload
          expect(project.name).to eq('Updated Project')
        end

        it 'redirects to project' do
          expect(response).to redirect_to(project)
        end

        it 'sets success notice' do
          expect(flash[:notice]).to eq('Project was successfully updated.')
        end
      end

      context 'with invalid parameters' do
        let(:project_params) { { name: '', description: '' } }

        before { update_project }

        it 'does not update the project' do
          project.reload
          expect(project.name).not_to eq('')
        end

        it 'renders edit template' do
          expect(response).to render_template(:edit)
        end

        it 'returns unprocessable entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user does not own the project' do
      let(:project) { create(:project, user: another_user) }
      let(:project_params) { { name: 'Updated Project' } }

      it 'redirects to projects path' do
        update_project
        expect(response).to redirect_to(projects_path)
      end

      it 'sets alert message' do
        update_project
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_project) { delete :destroy, params: { id: project.id } }

    context 'when user owns the project' do
      let!(:project) { create(:project, user: user) }

      it 'deletes the project' do
        expect { delete_project }.to change(Project, :count).by(-1)
      end

      it 'redirects to projects path' do
        delete_project
        expect(response).to redirect_to(projects_path)
      end

      it 'sets success notice' do
        delete_project
        expect(flash[:notice]).to eq('Project was successfully deleted.')
      end
    end

    context 'when user does not own the project' do
      let!(:project) { create(:project, user: another_user) }

      it 'does not delete the project' do
        expect { delete_project }.not_to change(Project, :count)
      end

      it 'redirects to projects path' do
        delete_project
        expect(response).to redirect_to(projects_path)
      end

      it 'sets alert message' do
        delete_project
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end
end
