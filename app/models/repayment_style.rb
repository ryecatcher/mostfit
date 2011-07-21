class RepaymentStyle
  include DataMapper::Resource
  
  before :save, :convert_blank_to_nil

  property :id,       Serial
  property :name,     String
  property :style,    String
  property :round_total_to, Integer
  property :round_interest_to, Integer
  property :active, Boolean
  property :rounding_style, String
  property :force_num_installments, Boolean

  def to_s
    style
  end

  def convert_blank_to_nil
    self.attributes.each{|k, v|
      if v.is_a?(String) and v.empty? and (self.class.send(k).type == Integer or self.class.send(k).type == Float)
        self.send("#{k}=", nil)
      end
    }
  end

end
