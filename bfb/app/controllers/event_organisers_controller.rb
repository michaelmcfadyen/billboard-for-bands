class EventOrganisersController < ApplicationController
  before_action :set_event_organiser, only: [:show, :edit, :update, :destroy]

  # GET /event_organisers
  # GET /event_organisers.json
  def index
    @event_organisers = EventOrganiser.all
  end

  # GET /event_organisers/1
  # GET /event_organisers/1.json
  def show
  end

  # GET /event_organisers/new
  def new
    @event_organiser = EventOrganiser.new
  end

  # GET /event_organisers/1/edit
  def edit
  end

  # POST /event_organisers
  # POST /event_organisers.json
  def create
    @event_organiser = EventOrganiser.new(event_organiser_params)

    respond_to do |format|
      if @event_organiser.save
        format.html { redirect_to @event_organiser, notice: 'Event organiser was successfully created.' }
        format.json { render :show, status: :created, location: @event_organiser }
      else
        format.html { render :new }
        format.json { render json: @event_organiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_organisers/1
  # PATCH/PUT /event_organisers/1.json
  def update
    respond_to do |format|
      if @event_organiser.update(event_organiser_params)
        format.html { redirect_to @event_organiser, notice: 'Event organiser was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_organiser }
      else
        format.html { render :edit }
        format.json { render json: @event_organiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_organisers/1
  # DELETE /event_organisers/1.json
  def destroy
    @event_organiser.destroy
    respond_to do |format|
      format.html { redirect_to event_organisers_url, notice: 'Event organiser was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_organiser
      @event_organiser = EventOrganiser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_organiser_params
      params.require(:event_organiser).permit(:firstName, :lastName, :email, :phoneNumber, :password, :password_confirmation)
    end
end
