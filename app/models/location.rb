class Location < ActiveRecord::Base
  attr_accessible :code,:voyager_id,:display_name,:hours_page,:rmc_aeon


  def self.help_page(code)
   base_url = 'https://www.library.cornell.edu/libraries/'
   code.delete!(' ')
    rec = where("code = ?", code).first
    rec ?  rec.hours_page  : base_url
    location_url =
      case
        when rec && rec.hours_page.present? && rec.hours_page.include?('http:')
          rec.hours_page
        when rec && rec.hours_page.present? && !rec.hours_page.include?('http:')
          base_url + rec.hours_page
        else
          base_url
     end
    location_url 
  end

  def self.aeon_eligible?(code)
    ret = false 
    code.delete!(' ')
    rec = where("code = ?", code).first
    rec ?  rec.rmc_aeon : ret
  end

  def aeon_eligible?(code)
    code.delete!(' ')
    return where("code = ?", code).rmc_aeon 
  end
 # mann,spec location code 73
 # mann,spec location code 77
 # mann,href location code 78
  MANN_SPEC_SITES  = [
    'mann,href',
    'mann,spec'
  ]

  def self.mann_spec_eligible?(code)
    ret = false 
    code.delete!(' ')
    return MANN_SPEC_SITES.include?(code)
    #later ?
    #rec = where("code = ?", code).rst
    #rec ?  rec.mann_spec : ret
  end

end
