
class Bookbag 

  attr_accessor :bagname

  def initialize(bagname) 
    @r = Redis.new(port: 6379)
    @bagname = bagname unless bagname.nil?
  end

  def create(value)
    @r.rpush  @bagname,value
  end


  def delete(value)
    @r.lrem  @bagname,99,value
  end

  def index
    @r.lrange(@bagname, 0, -1)
  end

  def count 
    @r.llen(@bagname)
  end

end

