class BooksController < ApplicationController
before_action :authenticate_user!
  def show
  	@book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
    @book_comments = @book.book_comments
    
  end

  def index
    @user = current_user
    @book = Book.new
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
  end

  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id =current_user.id

  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to book_path(@book.id), notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
      @user = current_user
      @books = Book.all
  		render :index
  	end
  end

  def edit
  	@book = Book.find(params[:id])
    if user_signed_in? && current_user.id == @book.user_id
       render :edit
    else
       redirect_to books_path
    end
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render :edit
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def user_params
    params.require(:user).permit(:username,:profile,:profile_image)

  end

  def book_params
  	params.require(:book).permit(:title,:body,:user_id)
  end

  def correct_user
    user = User.find(params[:id])
    if current_user != user
      redirect_to user_path(current_user)
    end
  end

end
