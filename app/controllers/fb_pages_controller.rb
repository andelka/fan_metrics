class FbPagesController < ApplicationController
  before_action :set_fb_page, only: [:show, :edit, :update, :destroy]

  def index
    @fb_pages = FbPage.all

    respond_to do |format|
      format.html
      format.csv { send_data FbPage.to_csv(current_user), filename: "facebook_page-#{Date.today}.csv" }
    end
  end

  def show
  end

  def new
    @fb_page = FbPage.new
  end

  def edit
  end

  def create
    @fb_page = FbPage.new(fb_page_params)

    respond_to do |format|
      if @fb_page.save
        format.html { redirect_to @fb_page, notice: 'The facebook page was successfully created.' }
        format.json { render :show, status: :created, location: @fb_page }
      else
        format.html { render :new }
        format.json { render json: @fb_page.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @fb_page.update(fb_page_params)
        format.html { redirect_to @fb_page, notice: 'The facebook page was successfully updated.' }
        format.json { render :show, status: :ok, location: @fb_page }
      else
        format.html { render :edit }
        format.json { render json: @fb_page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @fb_page.destroy
    respond_to do |format|
      format.html { redirect_to fb_pages_url, notice: 'The facebook page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_fb_page
    @fb_page = FbPage.find(params[:id])
  end

  def fb_page_params
    params.require(:fb_page).permit(:name, :page_id, :post_amount)
  end
end
