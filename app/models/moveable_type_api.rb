class MoveableTypeApi

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def getRecentPostTitles(blogid, username, password, numberOfPosts)
    raise "Invalid login" unless valid_login?(username, password)
    
    array = []
    articles = Article.find_all(nil,"created_at DESC", numberOfPosts)
    articles.each do |article|
      array << {"dateCreated"   => article.created_at,
                "userid"        => blogid.to_s,
                "postid"        => article.id.to_s,
                "title"         => article.title
               } 
    end
    array
  end

  def getCategoryList(blogid, username, password)
    raise "Invalid login" unless valid_login?(username, password)

    categories = Array.new
    Category.find_all.each { |c| 
      categories << {"categoryId"   => c.id,
                     "categoryName" => c.name
                    } 
    }
    categories
  end

  def getPostCategories(postid, username, password)
    raise "Invalid login" unless valid_login?(username, password)

    article = Article.find(postid)
    categories = Array.new
    article.categories.each { |c|
      categories << {"categoryName" => c.name,
                     "categoryId"   => c.id,
                     "isPrimary"    => c.is_primary
                    }
    }
    categories
  end

  def setPostCategories(postid, username, password, categories)
    raise "Invalid login" unless valid_login?(username, password)
    
    article = Article.find(postid)
    
    if categories != nil
      article.categories.clear
      categories.each do |c|
        category = Category.find(c['categoryId'])
        article.categories.push_with_attributes(category, :is_primary => c['isPrimary'])
      end
    end
    article.save
  end

  # Wow, this should really do something.
  # It's a little vague in the spec though.
  def supportedMethods()
  end

  #  No per post text filtering currently, maybe later.
  def supportedTextFilters()
    []
  end

  def getTrackbackPings(postid)
    article = Article.find(postid)
    tb = Array.new
    article.trackbacks.each { |t|
      tb << {'pingTitle' => t.title,
             'pingURL'   => t.url,
             'pingIP'    => t.ip}
    }
    tb
  end

  # I'm not sure if anything even needs to be done here 
  # since we're not generating static html.
  # Maybe we could empty the cache to regenerate the article?
  def publishPost(postid, username, password)
    raise "Invalid login" unless valid_login?(username, password)
    true
  end


  private

  def valid_login?(user,pass)
    user == CONFIG['login'] && pass == CONFIG['password']
  end

  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

end
