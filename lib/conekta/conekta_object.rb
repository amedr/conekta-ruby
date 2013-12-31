module Conekta
  class ConektaObject < Hash
    attr_reader :id
    def initialize(id=nil)
      @values = Hash.new
      @id = id.to_s
    end
    def set_val(k,v)
      @values[k] = v
    end
    def unset_key(k)
      @values.delete(k)
    end
    def load_from(response)
      if response.instance_of?(Array)
        response.each_with_index do |v, i|
          load_from_enumerable(i,v)
        end
      elsif response.instance_of?(Hash)
        response.each do |k,v|
          load_from_enumerable(k,v)
        end
      end
    end
    def to_s
      @values.inspect
    end
    protected
    def load_from_enumerable(k,v)
      if v.respond_to? :each and !v.instance_of?(ConektaObject)
        v = Conekta::Util.convert_to_conekta_object(v)
      end
      if self.instance_of?(ConektaObject)
        self[k] = v
      else
        self.class.send(:define_method, k.to_sym, Proc.new {v})
      end
      self.set_val(k,v)
    end
    def inspect
      if self.respond_to? :each
        self.to_s
      else
        super
      end
    end
  end
end