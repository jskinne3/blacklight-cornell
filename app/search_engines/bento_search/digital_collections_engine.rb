class BentoSearch::DigitalCollectionsEngine

  include BentoSearch::SearchEngine

  # Next, at a minimum, you need to implement a #search_implementation method,
  # which takes a normalized hash of search instructions as input (see documentation
  # at #normalized_search_arguments), and returns BentoSearch::Results item.
  #
  # The Results object should have #total_items set with total hitcount, and contain
  # BentoSearch::ResultItem objects for each hit in the current page. See individual class
  # documentation for more info.
  def search_implementation(args)

    # 'args' should be a normalized search arguments hash including the following elements:
    # :query, :per_page, :start, :page, :search_field, :sort
    Rails.logger.debug("mjc12test: BlacklightEngine search called. Query is #{args[:query]}}")
    bento_results = BentoSearch::Results.new

    # Format is passed to the engine using the configuration set up in the bento_search initializer
    # If not specified, we can maybe default to books for now.
    format = configuration[:blacklight_format] || 'Digital Collections'
    q = args[:oq].gsub(" ","%20")
    portal_response = JSON.load(open("https://digital-stg.library.cornell.edu/catalog.json?utf8=%E2%9C%93&q=#{q}&search_field=all_fields&rows=3"))

    Rails.logger.debug "mjc12test: #{portal_response}"
    results = portal_response['response']['docs']

    results.each do |i|
      item = BentoSearch::ResultItem.new
      item.title = i['title_tesim'][0].to_s
      if i['collection_tesim'].present?
      item.abstract = i['collection_tesim'][0].to_s
      elsif i['description_tesim'].present?
        item.abstract = i['description_tesim'][0].to_s
      end
      if i['content_metadata_image_iiif_info_ssm'].present?
        item.format_str = i['content_metadata_image_iiif_info_ssm'][0].to_s
        item.format_str = item.format_str.gsub('info.json','full/100,/0/native.jpg')
        end
      if i['date_tesim'].present?
        item.publication_date = i['date_tesim'][0].to_s
      end
      if i['creator_facet_tesim'].present?
      i['creator_facet_tesim'].each do |a|
        # author_display comes in as a combined name and date with a pipe-delimited display name.
        # bento_search does some slightly odd things to author strings in order to display them,
        # so the raw string coming out of *our* display value turns into nonsense by default
        # Telling to create a new Author with an explicit 'display' value seems to work.
        item.authors << BentoSearch::Author.new({:display => a})
      end
    end
      if i['id'].start_with?('wa:') && i['wayback_url_tesim'].present?
        item.link = i['wayback_url_tesim'][0]
      else
      item.link = "http://digital-stg.library.cornell.edu/catalog/#{i['id']}"
    end
      bento_results << item
    end
    bento_results.total_items = portal_response['response']['pages']['total_count']

    return bento_results

  end


end
