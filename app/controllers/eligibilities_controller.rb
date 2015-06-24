class EligibilitiesController < ApplicationController
  # before_action :set_eligibility, only: [:show, :edit, :update, :destroy]

  # GET /eligibilities
  # GET /eligibilities.json
  # def index
  #   @eligibilities = Eligibility.all
  # end
  #
  # # GET /eligibilities/1
  # # GET /eligibilities/1.json
  # def show
  # end

  # GET /eligibilities/new
  def new
    @eligibility = Eligibility.new
  end

  # GET /eligibilities/1/edit
  # def edit
  # end

  # POST /eligibilities
  # POST /eligibilities.json
  def create
    @eligibility = Eligibility.new(eligibility_params)

    respond_to do |format|
      if @eligibility.save
        format.html { redirect_to @eligibility, notice: 'Eligibility was successfully tested.' }
        format.json { render :show, status: :created, location: @eligibility }
      else
        format.html { render :new }
        format.json { render json: @eligibility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eligibilities/1
  # PATCH/PUT /eligibilities/1.json
  # def update
  #   respond_to do |format|
  #     if @eligibility.update(eligibility_params)
  #       format.html { redirect_to @eligibility, notice: 'Eligibility was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @eligibility }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @eligibility.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # DELETE /eligibilities/1
  # # DELETE /eligibilities/1.json
  # def destroy
  #   @eligibility.destroy
  #   respond_to do |format|
  #     format.html { redirect_to eligibilities_url, notice: 'Eligibility was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eligibility
      @eligibility = Eligibility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eligibility_params
      params.require(:eligibility).permit(:email, :designation, :explore, :interest, :priority, :meet)
    end
end
