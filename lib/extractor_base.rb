require 'stringio'

module ReadyForI18N
  module ExtractorBase
    
    def self.use_dot(on_off)
      @use_dot = on_off
    end
    def self.use_dot?
      @use_dot
    end
    def self.key_mapper=(mapper)
      @key_mapper = mapper
    end
    def self.key_mapper
      @key_mapper
    end
    
    def extract(input)
      buffer = StringIO.new
      input.each do |line|
        unless skip_line?(line)
          values_in_line(line).each do |e|
            if can_replace?(e)
              yield(to_key(e),to_value(e)) if block_given?
              replace_line(line,e)
            end
          end
        end
        buffer << line
      end
      buffer.string
    end
    
    
    def to_key(s)
      val = to_value(s)
      result = (ExtractorBase.key_mapper) ? ExtractorBase.key_mapper.key_for(val) : val.scan(/\w+/).join('_').downcase
      
      #trim long keys
      if result.length > 50
        result.gsub!(/_/, ' ')
        result.gsub!(/\b(the|be|to|of|and|a|in|that|have|I|it|for|not|on|with|he|as|you|do|at)\b/i,' ')
        result.gsub!(/\s{2,}/,' ')
        if result.length > 50
          result = result[0..49]
        end
        result.strip!
        result.gsub!(/\s/, '_')
      end

      key_prefix ? "#{key_prefix}_#{result}" : result
    end


    def can_replace?(e)
      e.strip.size > 1
    end
    def t_method(val,wrap=false)
      m = ExtractorBase.use_dot? ? "t('.#{to_key(val)}')" : "t(:#{to_key(val)})"
      wrap ? "<%=#{m}%>" : m
    end
  end
end
