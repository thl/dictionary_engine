class UsersController < ApplicationController
  layout 'stgall'
  helper :habtm
  helper :sort
  include SortHelper

end
