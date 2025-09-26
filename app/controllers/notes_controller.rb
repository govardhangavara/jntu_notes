class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show, :branch, :year, :subject, :filter_notes]

  # ------------------- CRUD -------------------
  # GET /notes
  def index
    if params[:search].present?
      @notes = Note.where(
        "title LIKE :q OR subject LIKE :q OR year LIKE :q OR branch LIKE :q",
        q: "%#{params[:search]}%"
      )
    else
      @notes = Note.all
    end
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy!
    respond_to do |format|
      format.html { redirect_to notes_path, notice: "Note was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # ------------------- Selection Flow -------------------
  # Step 1: Select Branch
  def branch
  end

  # Step 2: Select Year
  def year
    @branch = params[:branch]
  end

  # Step 3: Select Subject
  def subject
    @branch = params[:branch]
    @year   = params[:year]

    if @branch.present? && @year.present?
      @subjects = Note.where(branch: @branch, year: @year).pluck(:subject).uniq
    else
      @subjects = []
    end
  end

  # Step 4: Filter Notes by branch/year/subject
  def filter_notes
    @branch  = params[:branch]
    @year    = params[:year]
    @subject = params[:subject]

    @notes = Note.where(branch: @branch, year: @year, subject: @subject)
  end

  private

  # Set note for CRUD actions
  def set_note
    @note = Note.find(params[:id])
  end

  # Strong params for creating/updating notes
  def note_params
    params.require(:note).permit(:title, :subject, :year, :branch, :file)
  end
end
