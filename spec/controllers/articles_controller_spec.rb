require 'rails_helper'

describe ArticlesController do
	before do
		@user = create(:user)
		session[:user_id] = @user.id
  end

  after do
  	session[:user_id] = nil
  end

	describe 'Get#index' do
		it "should render the article index template" do
			get :index
			expect(response).to render_template :index
		end

		it "should create an array (@articles) of articles to display in the view" do
			article1 = create(:article, title:'first test', author: @user)
			article2 = create(:article, title:'second test', author: @user)
			get :index
			expect(assigns(:articles)).to match_array([article1, article2])
		end

	end

	describe 'Get#show' do
		it "should render the template for a single article(show view)" do
			article = create(:article, author:@user)
			get :show, id: article
			expect(response).to render_template :show
		end

		it "should assign requested article to @articles" do
			article = create(:article, author:@user)
			get :show, id: article
			expect(assigns(:article)).to eq article
		end

	end

	describe 'Get#edit' do
		it "should render the template for the edit form." do
			article = create(:article, author:@user)
			get :edit, id: article
			expect(response).to render_template :edit
		end

		it "should assign requested article to @article" do
			article = create(:article, author:@user)
			get :edit, id: article
			expect(assigns(:article)).to eq article
		end

	end

	describe 'Put#update' do

		context 'Valid update' do

			before :each do
				@article = create(:article, author:@user)
			end
			it "should update valid attributes for requested article" do
				put :update, id: @article, article: attributes_for(:article, title:'changing title', content:'changing content')
				@article.reload
				expect(@article.title).to eq('changing title')
				expect(@article.content).to eq('changing content')
			end

			it "should redirect back to the updated article" do
				put :update, id: @article, article: attributes_for(:article)
				expect(response).to redirect_to @article
			end
		end

		context 'Invalid update' do
			before :each do
				@article = create(:article, author:@user)
			end

			it "should not update invalid attributes for requested article" do
				put :update, id: @article, article: attributes_for(:article, title:nil, content:'changing content')
				@article.reload
				# Each test should have only one expectation.
				expect(@article.title).to eq("I LUV GAMES")
				expect(@article.content).to_not eq('changing content')
			end

			it "should re-render the edit form" do
				put :update, id: @article, article: attributes_for(:article, title: nil)
				expect(response).to render_template :edit
			end
		end
	end

	describe 'Get#new' do

		it "should render the template for the new article form" do
			get :new
			expect(:response).to render_template :new

		end

		it "should assign new article to variable @article" do
			get :new
			expect(assigns(:article)).to be_a_new(Article)
		end
	end

	describe 'Post#create' do

		context 'valid articles' do
			it "should save the new article to the database" do
				expect{post :create, article: attributes_for(:article)}.to change(Article, :count).by(1)
			end

			it "should redirect back to the new article(show)" do
				post :create, article: attributes_for(:article)
				expect(response).to redirect_to article_path(assigns[:article])
			end
		end
		context 'invalid articles' do
			it "should not save the new article to the database" do
				expect{post :create, article: attributes_for(:article, title:nil)}.to_not change(Article, :count)
			end

			it "should re-render the new form " do
				post :create, article: attributes_for(:article, title:nil)
				expect(response).to render_template :new
			end
		end
	end

	describe 'Delete#destroy' do
		before :each do
			@article = create(:article, author:@user)
		end

		it "should destroy requested article/delete from database" do
			expect{delete :destroy, id: @article}.to change(Article, :count).by(-1)
		end

		it "should redirect back to articles#index" do
			delete :destroy, id: @article
			expect(response).to redirect_to(articles_path)
		end
	end


	describe "Post#vote" do
		before do
			@user = create(:user)
			session[:user_id] = @user.id
			@article = create(:article, author:@user)
		end

		after do
		  session[:user_id] = nil
		end

		it 'should locate requested article' do
			post :vote, article_id: @article
			expect(assigns[:article]).to eq(@article)
		end

		it 'should save the vote to the database' do
			expect {post :vote, article_id: @article }.to change(Vote, :count).by(1)
		end

		it 'should have the voteable as Article' do
			post :vote, article_id: @article
			vote = assigns[:vote].reload
			expect(vote.voteable_type).to eq("Article")
		end
	end

end
