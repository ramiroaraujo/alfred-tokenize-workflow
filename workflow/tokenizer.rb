class Tokenizer

  def initialize
    @separators = [
        {:key => 'comma', :regex => /[[:space:]]*,[[:space:]]*/m},
        {:key => 'semicolon', :regex => /[[:space:]]*;[[:space:]]*/m},
        {:key => 'blank', :regex => /[[:space:]]+/m},
    ]

    @joins = [
        {:key => 'newline', :join => "\n", :enclose => ''},
        {:key => 'newline_quote', :join => "\"\n\"", :enclose => '"'},
        {:key => 'tab', :join => "\t", :enclose => ''},
        {:key => 'tab_quote', :join => "\"\t\"", :enclose => '"'},
        {:key => 'comma', :join => ",", :enclose => ''},
        {:key => 'comma_quote', :join => "\",\"", :enclose => '"'},
        {:key => 'semicolon', :join => ";", :enclose => ''},
        {:key => 'semicolon_quote', :join => "\";\"", :enclose => '"'},
        {:key => 'space', :join => " ", :enclose => ''},
        {:key => 'space_quote', :join => "\" \"", :enclose => '"'},
    ]

    @data = nil
  end

  def check text
    separator = detect_separator(text)

    return false if !separator[:num]

    separator_key = separator[:key]
    return text.split(separator[:regex]).count > 1
  end

  def separate text
    separator = detect_separator text
    @data = text.split separator[:regex]

    if @data.all? { |v| /^('|"|`).*\1$/ =~ v }
      @data.map! { |v| v = v[1..-2] }
    end
    self
  end

  def join operation
    raise Exception if !@data
    join = @joins.detect { |f| f[:key] == operation }
    join[:enclose] + @data.join(join[:join]) + join[:enclose]
  end

  private
  def detect_separator text
    separators = @separators.map do |f|
      f[:num] = text.scan(f[:regex]).size
      f
    end
    separators.sort_by! { |x| x[:num] }.reverse!

    separators.first
  end

  def separators
  end
end