module Report
  class AdmirerReport
    attr_accessor :tags, :total

    Tag = Struct.new(:name, :count)

    def initialize
      @tags = []
      @total = 0
      load_initial_tags
    end

    def load_initial_tags
      Request::Tags.keys.each do |tag|
        self.tags << Tag.new(tag, 0)
      end
    end

    def user_admirers_count user
      user.admirers.genuine.each do |admirer|
        update_tag_count admirer.pitch_list.first
      end
      convert_into_percentage if @total > 0
    end

    def update_tag_count tag_name
      tag = find_or_initialize_by_tag_name(tag_name)
      @total += 1
      tag["count"] += 1
    end

    def find_or_initialize_by_tag_name(name)
      self.tags.select{|tag| tag.name == name}.first || initialize_tag(name)
    end

    def convert_into_percentage
      @tags.map!{|tag| {name: tag.name, count: tag.count, y: (100*tag.count/@total)}}
    end

    private

    def initialize_tag name
      tag = Tag.new(name, 0)
      self.tags << tag
      tag
    end
  end
end
