class CommentsController < ApplicationController
  before_filter :load_commentable

  def index
    @comments = @commentable.logs
  end

  def create
    @comment = @commentable.logs.new(params[:comment])
    if @comment.save
      redirect_to @commentable, notice: "Log created."
    else
      render :new
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to(:back,notice: "Log was deleted") }
    end
  end

  private

  def load_commentable
    klass = [Account].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)
  end

end
