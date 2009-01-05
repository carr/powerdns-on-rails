# See #Domain

# = Domain
# 
# A #Domain is a unique domain name entry, and contains various #Record entries to
# represent its data.
# 
# The zone is used for the following purposes:
# * It is the $ORIGIN off all its records
# * It specifies a default $TTL
# 
class Domain < ActiveRecord::Base

  scope_user
  
  belongs_to :user
  
  has_many :records, :dependent => :destroy
  
  has_one  :soa_record,    :class_name => 'SOA'
  has_many :ns_records,    :class_name => 'NS'
  has_many :mx_records,    :class_name => 'MX'
  has_many :a_records,     :class_name => 'A'
  has_many :txt_records,   :class_name => 'TXT'
  has_many :cname_records, :class_name => 'CNAME'
  has_one  :loc_record,    :class_name => 'LOC'
  has_many :aaaa_records,  :class_name => 'AAAA'
  has_many :spf_records,   :class_name => 'SPF'
  has_many :srv_records,   :class_name => 'SRV'
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # Disable single table inheritence (STI)
  set_inheritance_column 'not_used_here'
  
  # Virtual attributes that ease new zone creation. If present, they'll be
  # used to create an SOA for the domain
  SOA_FIELDS = [ :primary_ns, :contact, :refresh, :retry, :expire, :minimum ]
  SOA_FIELDS.each do |f|
    attr_accessor f
    validates_presence_of f, :on => :create
  end
  
  # Serial is optional, but will be passed to the SOA too
  attr_accessor :serial
  
  # Helper attributes for API clients and forms (keep it RESTful)
  attr_accessor :zone_template_id, :zone_template_name
  
  # return the records, excluding the SOA record
  def records_without_soa
    records.find(:all, :include => :domain ).select { |r| !r.is_a?( SOA ) }
  end

  # Nicer representation of the domain as XML
  def to_xml_with_cleanup(options = {}, &block)
    to_xml_without_cleanup(
                           :include => [:records],
                           :except => [:user_id]
                           )
  end
  alias_method_chain :to_xml, :cleanup
  
  # Expand our validations to include SOA details
  def after_validation_on_create #:nodoc:
    soa = SOA.new( :domain => self )
    SOA_FIELDS.each do |f|
      soa.send( "#{f}=", send( f ) )
    end
    soa.serial = serial unless serial.nil? # Optional
    
    unless soa.valid?
      soa.errors.each_full do |e|
        errors.add_to_base e
      end
    end
  end
  
  # Setup an SOA if we have the requirements
  def after_create #:nodoc:
    soa = SOA.new( :domain => self )
    SOA_FIELDS.each do |f|
      soa.send( "#{f}=", send( f ) )
    end
    soa.serial = serial unless serial.nil? # Optional
    soa.save
  end
  
  def attach_errors(e)
    e.message.split(":")[1].split(",").uniq.each do |m|
      self.errors.add(m , '')
    end
  end
end