class ListsController < ApplicationController
  #the line below is strictly for demo only
  @@lat_long = [["37.76","-122.41"], ["37.73","-122.42"], ["37.75","-122.40"], ["37.75","-122.43"]]
  @@counter = 0

  # GET /lists
  # GET /lists.json
  def index
    @lists  = List.all
    @list   = List.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lists }
    end
  end

  #the demo-able action
  def now
    lat, long = @@lat_long[@@counter]
    @list_places = List.by_lat_long(lat, long)
    if @@counter == 3
      @@counter = 0
    else
      @@counter += 1
    end
    respond_to do |format|
      format.html
      format.json { render json: @list_places }
    end
  end

  def search
    @list_places = List.by_lat_long(params[:lat], params[:long])
    respond_to do |format|
      format.html
      format.json { render json: @list_places }
    end
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    @list = List.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.json
  def new
    @list = List.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(params[:list])

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render json: @list, status: :created, location: @list }
      else
        format.html { render action: "new" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.json
  def update
    @list = List.find(params[:id])

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list = List.find(params[:id])
    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url }
      format.json { head :no_content }
    end
  end
end
