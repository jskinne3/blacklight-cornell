class Bookmarklite
  attr_accessor :document_id


  def initialize(bid)
    @document_id = bid
  end

end

class BookBagsController < CatalogController
#class BookBagsController < ApplicationController
#  include Blacklight::Catalog
#  include BlacklightCornell::CornellCatalog

  #copy_blacklight_config_from(CatalogController)
  #
  before_action :authenticate_user!

  before_filter :heading
  append_before_filter :set_bag_name
 

  def set_bag_name
    @id = current_user.email
    @bb.bagname = "#{@id}-bookbag-default"
    search_session[:bookbag_count] = @bb.count
  end

  def heading
   @heading='BookBag'
  end

  def initialize
    super
    @bb = Bookbag.new(nil)
  end 

  def add
    @bibid = params[:id]
    value = "bibid-#{@bibid}"
    Rails.logger.info("es287_debug #{__FILE__} #{__LINE__} #{__method__} @bb = #{@bb.inspect}")
    Rails.logger.info("es287_debug #{__FILE__} #{__LINE__} #{__method__} value = #{value.inspect}")
    search_session[:bookbag_count] = @bb.count
    @bb.create(value)
    respond_to do |format|
      format.html { }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
      format.json { render json:   { }      } 
    end
  end

  def delete
    @bibid = params[:id]
    value = "bibid-#{@bibid}"
    @bb.delete(value)
    session[:bookbag_count] = @bb.count
    respond_to do |format|
      format.html { }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
      format.json do
        render json:   { }
      end
    end
  end

  def index
    @bms =@bb.index
    docs = @bms.map {|b| b.sub!("bibid-",'')}
    @response,@documents = fetch docs
    @document_list =  @documents
    @bookmarks = docs.map {|b| Bookmarklite.new(b)}
    Rails.logger.info("es287_debug #{__FILE__} #{__LINE__} #{__method__} @documents = #{@documents.inspect}")
    Rails.logger.info("es287_debug #{__FILE__} #{__LINE__} #{__method__} @response = #{@response.inspect}")
  end

end
