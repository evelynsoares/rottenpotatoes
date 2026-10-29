# Maps the page names used in the features ("the home page", "the edit
# page for "Alien"", ...) to app paths. Used by the generic navigation
# steps in web_steps.rb ("I am on ...", "I go to ...", "I should be on ..."),
# so a new page only needs one more line here instead of new steps.
module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /^the (RottenPotatoes )?home\s?page$/
      movies_path
    when /^the Create New Movie page$/
      new_movie_path
    when /^the edit page for "(.*)"$/
      edit_movie_path(movie_titled($1))
    when /^the details page for "(.*)"$/
      movie_path(movie_titled($1))
    when /^the Similar Movies page for "(.*)"$/
      similar_movie_path(movie_titled($1))
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
            "Now, go and add a mapping in #{__FILE__}"
    end
  end

  def movie_titled(title)
    Movie.find_by!(title: title)
  end
end

World(NavigationHelpers)
