module Report
  class AdmirerReport
    attr_accessor :tags

    Tag = Struct.new(:name, :y)

    def initialize
      @tags = []
    end

    def user_admirers_count user
      user.admirers.genuine.each do |admirer|
        update_tag_count admirer.pitch_list.first
      end
    end

    def update_tag_count tag_name
      tag = find_or_initialize_by_tag_name(tag_name)
      tag["y"] += 1
    end

    def find_or_initialize_by_tag_name(name)
      self.tags.select{|tag| tag.name == name}.first || initialize_tag(name)
    end

    private

    def initialize_tag name
      tag = Tag.new(name, 0)
      self.tags << tag
      tag
    end
  end
end
