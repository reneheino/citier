require 'active_record'

CITIER_DEBUGGING = (::Rails.env == 'development')

def citier_debug(s)
  if CITIER_DEBUGGING
    puts "citier -> " + s
  end
end

require 'citier/required_methods'
require 'citier/class_methods'
require 'citier/general_instance_methods'

ActiveRecord::Base.send :extend, Citier::RequiredMethods

# require 'citier/core_ext'
# 
# # Methods which will be used by the class
# require 'citier/class_methods'
# 
# # Methods that will be used for the instances of the Non Root Classes
# require 'citier/instance_methods'
# 
# # Methods that will be used for the instances of the Root Classes
# require 'citier/root_instance_methods'
# 
# # Methods that will be used for the instances of the Non Root Classes
# require 'citier/child_instance_methods'
# 
# # Require SQL Adapters
# require 'citier/sql_adapters'
# 
#Require acts_as_citier hook
# require 'citier/acts_as_citier'
# 
# # Methods that override ActiveRecord::Relation
# require 'citier/relation_methods'