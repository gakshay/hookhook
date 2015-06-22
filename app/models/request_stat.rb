class RequestStat < ActiveRecord::Base
  belongs_to :request
  belongs_to :user
end

class View < RequestStat; end
class Like < RequestStat; end
