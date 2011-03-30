class Admin::StoreChainsController < ApplicationController
  
  layout "admin"

  # only authorized users can access it
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :check_admin_ability

  # GET /store_chains
  # GET /store_chains.xml
  def index
    @store_chains = StoreChain.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @store_chains }
    end
  end

  # GET /store_chains/1
  # GET /store_chains/1.xml
  def show
    @store_chain = StoreChain.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store_chain }
    end
  end

  # GET /store_chains/new
  # GET /store_chains/new.xml
  def new
    @store_chain = StoreChain.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store_chain }
    end
  end

  # GET /store_chains/1/edit
  def edit
    @store_chain = StoreChain.find(params[:id])
  end

  # POST /store_chains
  # POST /store_chains.xml
  def create
    @store_chain = StoreChain.new(params[:store_chain])

    respond_to do |format|
      if @store_chain.save
        format.html { redirect_to(admin_store_chain_path(@store_chain, :notice => 'Store chain was successfully created.')) }
        format.xml  { render :xml => @store_chain, :status => :created, :location => @store_chain }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @store_chain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /store_chains/1
  # PUT /store_chains/1.xml
  def update
    @store_chain = StoreChain.find(params[:id])

    respond_to do |format|
      if @store_chain.update_attributes(params[:store_chain])
        format.html { redirect_to(admin_store_chain_path(@store_chain, :notice => 'Store chain was successfully updated.')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @store_chain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /store_chains/1
  # DELETE /store_chains/1.xml
  def destroy
    @store_chain = StoreChain.find(params[:id])
    @store_chain.destroy

    respond_to do |format|
      format.html { redirect_to(admin_store_chains_url) }
      format.xml  { head :ok }
    end
  end
end
