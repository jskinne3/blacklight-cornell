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

  before_filter :heading

  def heading
   @heading='BookBag'
  end

  def initialize
    super
    @bagname = "es287-bookbag-default"
    @bb = Bookbag.new(@bagname)
  end 

  def add
    @id = params[:id]
    value = "bibid-#{params[:id]}"
    @bb.create(value)
  end

  def delete
    @id = params[:id]
    value = "bibid-#{params[:id]}"
    @bb.delete(value)
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
