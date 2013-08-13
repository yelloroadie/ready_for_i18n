module ReadyForI18N
  class LocaleDictionary
    def initialize(locale = nil)
      @locale = locale || 'en'
      @hash = {}
    end
    def push(key,value,path = nil)
      h = @hash
      path.each{|p| fp = p.sub(/^_/, ''); h[fp] ||= {}; h = h[fp] } if path
      h[key] = value
    end
    def write_to(out)
      # out.puts "#{@locale}:"
      $KCODE = 'UTF8'
      out.puts({"#{@locale}" => @hash}.ya2yaml)
    end
  end
end
