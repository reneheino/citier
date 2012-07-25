module InstanceMethods

  def self.included(base)
    base.send :include, ForcedWriters
  end
  
  module ForcedWriters
    def force_attributes(new_attributes, options = {})
      new_attributes = @attributes.merge(new_attributes) if options[:merge]
      @attributes = new_attributes
      
      if options[:clear_caches] != false
        @aggregation_cache = {}
        @association_cache = {}
        @attributes_cache = {}
      end
    end
  
    def force_changed_attributes(new_changed_attributes, options = {})
      new_changed_attributes = @attributes.merge(new_changed_attributes) if options[:merge]
      @changed_attributes = new_changed_attributes
    end
  end

  # Delete the model (and all parents it inherits from if applicable)
  def delete(id = self.id)
    citier_debug("Deleting #{self.class.to_s} with ID #{self.id}")

    # Delete information stored in the table associated to the class of the object
    # (if there is such a table)
    deleted = true
    c = self.class
    while c.superclass!=ActiveRecord::Base
      citier_debug("Deleting back up hierarchy #{c}")
      deleted &= c::Writable.delete(id)
      c = c.superclass
    end
    deleted &= c.delete(id)
    return deleted
  end

  def updatetype        
    sql = "UPDATE #{self.class.root_class.table_name} SET #{self.class.inheritance_column} = '#{self.class.to_s}' WHERE id = #{self.id}"
    self.connection.execute(sql)
    citier_debug("#{sql}")
  end

  def destroy
    return self.delete
  end

end