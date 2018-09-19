# frozen_string_literal: true
class BookmarksController < CatalogController  
  include Blacklight::Bookmarks

  def heading
    @heading='SelectedItems'
   end
 
  def email_login_required
    Rails.logger.level = 0
    Rails.logger.info("jgr25_debug #{__FILE__} #{__LINE__}  = " + "bookmarks email_login_required")
    Rails.logger.level = :warn

    flash[:notice] = I18n.t('blacklight.bookmarks.need_login') and raise Blacklight::Exceptions::AccessDenied
    redirect_to 'bookmarks'
  end

  # displays the email_login_required form partial... used by an AJAX request
  def show_email_login_required_bookmarks
    render :partial=>"bookmarks/email_login_required"
  end
 
  # same as show_email_login_required_bookmarks but for the catalog item view
  def show_email_login_required_item
    render :partial=>"bookmarks/email_login_required_item_view"
  end

end 