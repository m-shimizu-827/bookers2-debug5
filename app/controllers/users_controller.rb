class UsersController < ApplicationController
  before_action :authenticate_user!
	before_action :baria_user, only: [:update,:edit]

  def show
  	@user = User.find(params[:id])
  	@books = @user.books.page(params[:page]).reverse_order
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end

  def index
  	@users = User.all #一覧表示するためにUserモデルのデータを全て変数に入れて取り出す。
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
    @user = current_user
  end

  def create
    @book = Book.new(params[:id])
    @book.user_id = current_user_id
    if @book.save
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end
  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  		redirect_to user_path(@user), notice: "successfully updated user!"
  	else
  		render :edit
  	end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.followings
    render :show_follow
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render :show_follower
  end

  def search
    @user_or_book = params[:option]
    @how_search = params[:choice]
    if @user_or_book == "1"
      @users = User.search(params[:search],@user_or_book,@how_search)
    else
      @books = Book.search(params[:search],@user_or_book,@how_search)
    end
  end

  private
  def book_params
    params.require(:book).permit(:title,:body)
  end
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image)
  end

  #url直接防止　メソッドを自己定義してbefore_actionで発動。
   def baria_user
  	unless params[:id].to_i == current_user.id
  		redirect_to user_path(current_user)
  	end
   end

end
