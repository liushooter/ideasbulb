# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ideasbulb::Application.initialize!

# Application Constant
IDEA_STATUS_UNDER_REVIEW = 'under_review'
IDEA_STATUS_REVIEWED_SUCCESS = 'reviewed_success'
IDEA_STATUS_LAUNCHED = 'launched'
PREFERENCE_SITE_NAME = 'site_name'
USER_NEW_IDEA_POINTS = 3
USER_NEW_SOLUTION_POINTS = 2
USER_NEW_COMMENT_POINTS = 1
USER_VOTE_POINTS = 1
IDEAS_SORT_HOT = 'hot'
IDEAS_SORT_NEWEST = 'new'
SEARCH_SOLR_FILTER = /&&|\|\||[\+\-!\(\)\{\}\[\]\^"~\*\?:\\]/
