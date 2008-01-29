class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @person_entities = PersonEntity.find_all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person_entities }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    person_entity = PersonEntity.find(params[:id])
    @person = person_entity.current
    @locations = person_entity.current_locations

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    person_entity = PersonEntity.find(params[:id])
    @person = person_entity.current
  end

  # POST /people
  # POST /people.xml
  def create
    person_entity = PersonEntity.new
    @person = Person.new(params[:person])
    person_entity.current = @person

    respond_to do |format|
      if person_entity.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(person_url(person_entity)) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    person_entity = PersonEntity.find(params[:id])
    @person = Person.new(params[:person])

    respond_to do |format|
      if person_entity.people << @person
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(person_url(person_entity)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    #TODO: Make this a soft delete.  Currently orphans all children
    @person_entity = PersonEntity.find(params[:id])
    @person_entity.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
end
